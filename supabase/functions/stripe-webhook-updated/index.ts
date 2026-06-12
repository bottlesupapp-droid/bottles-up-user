import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import Stripe from 'https://esm.sh/stripe@14.11.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

/**
 * UPDATED STRIPE WEBHOOK HANDLER
 *
 * KEY CHANGES:
 * 1. Creates bookings server-side (not client-side)
 * 2. Uses atomic booking function to prevent race conditions
 * 3. Handles payment success as source of truth
 * 4. Implements error recovery for failed booking creation
 */

serve(async (req) => {
  const signature = req.headers.get('stripe-signature')

  if (!signature) {
    return new Response(
      JSON.stringify({ error: 'No signature provided' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }

  try {
    const body = await req.text()

    // Get Stripe keys
    const stripeKey = Deno.env.get('STRIPE_SECRET_KEY')
    const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')

    if (!stripeKey || !webhookSecret) {
      throw new Error('Stripe configuration missing')
    }

    const stripe = new Stripe(stripeKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    // ✅ CRITICAL: Verify webhook signature to prevent forged requests
    const event = stripe.webhooks.constructEvent(body, signature, webhookSecret)

    // Get Supabase client with service role (bypasses RLS)
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('Webhook event type:', event.type)

    // Handle different event types
    switch (event.type) {
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent

        console.log('Payment Intent succeeded:', paymentIntent.id)
        console.log('Amount:', paymentIntent.amount, 'Currency:', paymentIntent.currency)

        // 1. Update payment transaction to 'paid'
        const { error: txnError } = await supabase
          .from('payment_transactions')
          .update({
            status: 'paid',
            updated_at: new Date().toISOString(),
          })
          .eq('payment_intent_id', paymentIntent.id)

        if (txnError) {
          console.error('Failed to update transaction:', txnError)
          // Continue anyway - we'll try to create booking
        }

        // 2. Get transaction details including metadata
        const { data: transaction } = await supabase
          .from('payment_transactions')
          .select('id, user_id, event_id, booking_id, payment_type, metadata')
          .eq('payment_intent_id', paymentIntent.id)
          .maybeSingle()

        if (!transaction) {
          console.error('No transaction found for payment intent:', paymentIntent.id)
          // Still return 200 to ack webhook
          return new Response(
            JSON.stringify({
              received: true,
              warning: 'Transaction not found - payment received but no booking metadata'
            }),
            { status: 200, headers: { 'Content-Type': 'application/json' } }
          )
        }

        console.log('Transaction found:', transaction.id, 'Type:', transaction.payment_type)

        // 3. Handle table bookings - CREATE booking server-side
        if (transaction.payment_type === 'tableBooking' && transaction.metadata) {
          try {
            const metadata = transaction.metadata as Record<string, any>

            // Extract booking details from metadata
            const eventId = metadata.event_id || transaction.event_id
            const tableId = metadata.table_id
            const partySize = parseInt(metadata.party_size || '1')
            const depositAmount = parseFloat(metadata.deposit_amount || metadata.table_cost || '0')
            const minimumBottles = parseInt(metadata.minimum_bottles || '1')
            const specialRequests = metadata.special_requests || null
            const contactEmail = paymentIntent.receipt_email || null

            if (!eventId || !tableId) {
              throw new Error('Missing event_id or table_id in metadata')
            }

            console.log('Creating table booking:', {
              eventId,
              tableId,
              userId: transaction.user_id,
              partySize,
              depositAmount,
            })

            // ✅ CRITICAL: Use atomic function to create booking
            // This prevents race conditions and double-booking
            const { data: bookingId, error: bookingError } = await supabase
              .rpc('create_table_booking_atomic', {
                p_event_id: eventId,
                p_user_id: transaction.user_id,
                p_table_id: tableId,
                p_party_size: partySize,
                p_deposit_amount: depositAmount,
                p_minimum_bottles: minimumBottles,
                p_special_requests: specialRequests,
                p_contact_email: contactEmail,
                p_metadata: {
                  payment_intent_id: paymentIntent.id,
                  payment_transaction_id: transaction.id,
                  ...metadata
                }
              })

            if (bookingError) {
              // Handle specific error codes from atomic function
              if (bookingError.code === '90003') {
                // Table already booked - refund payment
                console.error('Table already booked, initiating refund:', bookingError)

                // Create refund
                await stripe.refunds.create({
                  payment_intent: paymentIntent.id,
                  reason: 'duplicate',
                  metadata: {
                    reason: 'Table was already booked by another user'
                  }
                })

                // Update transaction
                await supabase
                  .from('payment_transactions')
                  .update({
                    status: 'refunded',
                    metadata: {
                      ...transaction.metadata,
                      refund_reason: 'Table already booked'
                    }
                  })
                  .eq('id', transaction.id)

                console.log('Refund initiated for payment:', paymentIntent.id)
              } else {
                // Other booking error - log for manual review
                console.error('CRITICAL: Booking creation failed:', bookingError)
                console.error('Payment confirmed but booking failed - requires manual review')
                console.error('Transaction ID:', transaction.id, 'Payment Intent:', paymentIntent.id)

                // Update transaction with error
                await supabase
                  .from('payment_transactions')
                  .update({
                    metadata: {
                      ...transaction.metadata,
                      booking_error: bookingError.message,
                      booking_error_code: bookingError.code,
                      requires_manual_review: true
                    }
                  })
                  .eq('id', transaction.id)

                // TODO: Send alert to monitoring system (Sentry, PagerDuty, etc.)
              }

              // Return 200 to acknowledge webhook (prevents retry storm)
              return new Response(
                JSON.stringify({
                  received: true,
                  payment_confirmed: true,
                  booking_failed: true,
                  error: bookingError.message,
                  requires_manual_review: true
                }),
                { status: 200, headers: { 'Content-Type': 'application/json' } }
              )
            }

            console.log('✅ Booking created successfully:', bookingId)

            // Update transaction with booking_id
            await supabase
              .from('payment_transactions')
              .update({
                booking_id: bookingId,
                metadata: {
                  ...transaction.metadata,
                  booking_created_at: new Date().toISOString()
                }
              })
              .eq('id', transaction.id)

            // TODO: Send confirmation email via trigger or separate function

            return new Response(
              JSON.stringify({
                received: true,
                payment_confirmed: true,
                booking_created: true,
                booking_id: bookingId
              }),
              { status: 200, headers: { 'Content-Type': 'application/json' } }
            )
          } catch (error: any) {
            console.error('Error creating table booking:', error)

            // Log error for manual review
            await supabase
              .from('payment_transactions')
              .update({
                metadata: {
                  ...transaction.metadata,
                  booking_error: error.message,
                  requires_manual_review: true
                }
              })
              .eq('id', transaction.id)

            // Return 200 to acknowledge webhook
            return new Response(
              JSON.stringify({
                received: true,
                payment_confirmed: true,
                booking_failed: true,
                error: error.message,
                requires_manual_review: true
              }),
              { status: 200, headers: { 'Content-Type': 'application/json' } }
            )
          }
        }

        // 4. Handle other booking types (regular bookings, tickets, etc.)
        if (transaction.booking_id) {
          // Booking already exists (created client-side) - just update status
          await supabase
            .from('bookings')
            .update({
              status: 'confirmed',
              payment_status: 'paid',
              updated_at: new Date().toISOString(),
            })
            .eq('id', transaction.booking_id)

          console.log('Updated existing booking:', transaction.booking_id)
        }

        // Success
        return new Response(
          JSON.stringify({ received: true, payment_confirmed: true }),
          { status: 200, headers: { 'Content-Type': 'application/json' } }
        )
      }

      case 'checkout.session.completed': {
        const session = event.data.object as Stripe.Checkout.Session

        // Update payment transaction
        const { error: txnError } = await supabase
          .from('payment_transactions')
          .update({
            status: 'paid',
            payment_intent_id: session.payment_intent as string,
            updated_at: new Date().toISOString(),
          })
          .eq('stripe_session_id', session.id)

        if (txnError) {
          console.error('Failed to update transaction:', txnError)
        }

        // Update booking status if applicable
        const metadata = session.metadata || {}
        if (metadata.booking_id) {
          const { error: bookingError } = await supabase
            .from('bookings')
            .update({
              status: 'confirmed',
              payment_status: 'paid',
              updated_at: new Date().toISOString(),
            })
            .eq('id', metadata.booking_id)

          if (bookingError) {
            console.error('Failed to update booking:', bookingError)
          }
        }

        console.log('Checkout session completed:', session.id)
        break
      }

      case 'checkout.session.expired': {
        const session = event.data.object as Stripe.Checkout.Session

        await supabase
          .from('payment_transactions')
          .update({
            status: 'cancelled',
            updated_at: new Date().toISOString(),
          })
          .eq('stripe_session_id', session.id)

        console.log('Session expired:', session.id)
        break
      }

      case 'payment_intent.payment_failed': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent

        // Update transaction to failed
        await supabase
          .from('payment_transactions')
          .update({
            status: 'failed',
            metadata: {
              error_message: paymentIntent.last_payment_error?.message || 'Payment failed'
            },
            updated_at: new Date().toISOString(),
          })
          .eq('payment_intent_id', paymentIntent.id)

        console.log('Payment failed:', paymentIntent.id)
        break
      }

      case 'charge.refunded': {
        const charge = event.data.object as Stripe.Charge

        await supabase
          .from('payment_transactions')
          .update({
            status: 'refunded',
            updated_at: new Date().toISOString(),
          })
          .eq('payment_intent_id', charge.payment_intent as string)

        console.log('Charge refunded:', charge.id)
        break
      }

      default:
        console.log('Unhandled event type:', event.type)
    }

    return new Response(
      JSON.stringify({ received: true }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error: any) {
    console.error('Webhook error:', error)

    // Return 400 for signature verification failures
    // Return 500 for other errors
    const status = error.message?.includes('signature') ? 400 : 500

    return new Response(
      JSON.stringify({ error: error.message }),
      { status, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
