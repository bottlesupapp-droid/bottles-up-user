import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import Stripe from 'https://esm.sh/stripe@14.11.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Parse request body
    const {
      user_id,
      email,
      payment_type,
      amount,
      currency = 'usd',
      description,
      booking_id,
      event_id,
      metadata = {},
      customer_id, // Existing Stripe customer ID (for saved cards)
    } = await req.json()

    // Validation
    if (!user_id || !email || !payment_type) {
      throw new Error('Missing required fields: user_id, email, payment_type')
    }

    if (!amount || amount <= 0) {
      throw new Error('Invalid amount')
    }

    // Get Stripe secret key — reads from live_SK in live mode, test_SK in test mode
    const stripeMode = Deno.env.get('STRIPE_MODE') ?? 'test'
    const skSecret = stripeMode === 'live' ? 'live_SK' : 'test_SK'
    const stripeKey = Deno.env.get(skSecret)
    if (!stripeKey) {
      throw new Error(`Stripe secret key not configured (expected secret: ${skSecret})`)
    }

    console.log(`✅ Using ${stripeMode.toUpperCase()} mode Stripe secret key`)

    const stripe = new Stripe(stripeKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    // Get Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Get or create Stripe customer
    let stripeCustomerId = customer_id

    if (!stripeCustomerId) {
      // Check if customer exists in our database
      const { data: existingCustomer } = await supabase
        .from('stripe_customers')
        .select('stripe_customer_id')
        .eq('user_id', user_id)
        .maybeSingle()

      if (existingCustomer?.stripe_customer_id) {
        // Verify the customer exists in the current Stripe mode before using it
        try {
          await stripe.customers.retrieve(existingCustomer.stripe_customer_id)
          stripeCustomerId = existingCustomer.stripe_customer_id
          console.log('✅ Using existing customer:', stripeCustomerId)
        } catch (err: any) {
          // Customer doesn't exist in this mode (e.g. live customer used with test key)
          console.log('⚠️ Existing customer invalid in current mode, creating new one:', err.message)
        }
      }

      if (!stripeCustomerId) {
        // Create new Stripe customer
        console.log('Creating new customer for user:', user_id)
        const customer = await stripe.customers.create({
          email,
          metadata: { user_id },
        })
        stripeCustomerId = customer.id
        console.log('✅ Created new customer:', stripeCustomerId)

        // Update or insert database record
        if (existingCustomer) {
          await supabase.from('stripe_customers')
            .update({
              stripe_customer_id: stripeCustomerId,
              email,
              updated_at: new Date().toISOString(),
            })
            .eq('user_id', user_id)
        } else {
          await supabase.from('stripe_customers').insert({
            user_id,
            stripe_customer_id: stripeCustomerId,
            email,
          })
        }
      }
    }

    // Create ephemeral key for customer
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: stripeCustomerId },
      { apiVersion: '2023-10-16' }
    )

    // Create Payment Intent
    // Use payment_method_types: ["card"] instead of automatic_payment_methods
    // to avoid enabling unsupported payment methods (us_bank_account, Link, etc.)
    const paymentIntent = await stripe.paymentIntents.create({
      amount, // Already in cents
      currency: currency.toLowerCase(),
      customer: stripeCustomerId,
      description: description || 'BottlesUp Payment',
      metadata: {
        user_id,
        payment_type,
        booking_id: booking_id || '',
        event_id: event_id || '',
        ...metadata,
      },
      payment_method_types: ['card'], // Only enable card payments
    })

    // Store transaction in database
    const { data: transaction, error: dbError } = await supabase
      .from('payment_transactions')
      .insert({
        user_id,
        booking_id,
        event_id,
        amount: amount / 100,
        currency: currency.toLowerCase(),
        status: 'pending',
        payment_intent_id: paymentIntent.id,
        stripe_customer_id: stripeCustomerId,
        payment_type,
        metadata,
        created_at: new Date().toISOString(),
      })
      .select()
      .single()

    if (dbError) {
      console.error('Database error:', dbError)
    }

    // Get publishable key matching current mode
    const pkSecret = stripeMode === 'live' ? 'live_PK' : 'test_PK'
    const publishableKey = Deno.env.get(pkSecret)
    if (!publishableKey) {
      throw new Error(`Stripe publishable key not configured (expected secret: ${pkSecret})`)
    }

    console.log(`✅ Returning ${stripeMode.toUpperCase()} mode publishable key`)

    // Return payment intent details
    return new Response(
      JSON.stringify({
        success: true,
        payment_intent: paymentIntent.client_secret,
        ephemeral_key: ephemeralKey.secret,
        customer: stripeCustomerId,
        publishable_key: publishableKey,
        transaction_id: transaction?.id,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Payment intent error:', error)

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || 'Payment intent creation failed',
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})
