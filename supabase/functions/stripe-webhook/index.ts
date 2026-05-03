import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import Stripe from 'https://esm.sh/stripe@14.11.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

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

    // Verify webhook signature
    const event = stripe.webhooks.constructEvent(body, signature, webhookSecret)

    // Get Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('Webhook event type:', event.type)

    // Handle different event types
    switch (event.type) {
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent

        // Update payment transaction
        const { error: txnError } = await supabase
          .from('payment_transactions')
          .update({
            status: 'paid',
            updated_at: new Date().toISOString(),
          })
          .eq('payment_intent_id', paymentIntent.id)

        if (txnError) {
          console.error('Failed to update transaction:', txnError)
        }

        // Get transaction to update booking
        const { data: transaction } = await supabase
          .from('payment_transactions')
          .select('booking_id, event_id, user_id, metadata')
          .eq('payment_intent_id', paymentIntent.id)
          .maybeSingle()

        if (transaction) {
          // Update booking if applicable
          if (transaction.booking_id) {
            await supabase
              .from('bookings')
              .update({
                status: 'confirmed',
                payment_status: 'paid',
                updated_at: new Date().toISOString(),
              })
              .eq('id', transaction.booking_id)
          }

          // Update event booking if applicable
          if (transaction.event_id) {
            await supabase
              .from('event_bookings')
              .update({
                status: 'confirmed',
                payment_status: 'paid',
                updated_at: new Date().toISOString(),
              })
              .eq('event_id', transaction.event_id)
              .eq('user_id', transaction.user_id)
          }
        }

        console.log('Payment Intent succeeded:', paymentIntent.id)
        break
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

        // Update event booking if applicable
        if (metadata.event_id) {
          const { error: eventError } = await supabase
            .from('event_bookings')
            .update({
              status: 'confirmed',
              payment_status: 'paid',
              updated_at: new Date().toISOString(),
            })
            .eq('event_id', metadata.event_id)
            .eq('user_id', metadata.user_id)

          if (eventError) {
            console.error('Failed to update event booking:', eventError)
          }
        }

        console.log('Payment completed:', session.id)
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

        // Find transaction by payment intent ID
        await supabase
          .from('payment_transactions')
          .update({
            status: 'failed',
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
  } catch (error) {
    console.error('Webhook error:', error)

    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
