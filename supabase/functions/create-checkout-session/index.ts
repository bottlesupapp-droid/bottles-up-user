import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import Stripe from 'https://esm.sh/stripe@14.11.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Server-side pricing (NEVER trust client amounts)
const PRICING: Record<string, number> = {
  // Event tickets (per ticket)
  event_general: 5000, // $50.00
  event_vip: 15000, // $150.00

  // Table bookings (base prices)
  table_standard: 15000, // $150.00
  table_vip: 35000, // $350.00
  table_premium: 75000, // $750.00

  // Bottle service (per bottle)
  bottle_vodka: 20000, // $200.00
  bottle_whiskey: 25000, // $250.00
  bottle_champagne: 35000, // $350.00

  // Memberships
  membership_basic: 9900, // $99.00
  membership_pro: 19900, // $199.00
  membership_premium: 49900, // $499.00
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
      amount, // Will be validated against server pricing
      currency = 'usd',
      description,
      booking_id,
      event_id,
      metadata = {},
      success_url = 'bottlesup://payment/success',
      cancel_url = 'bottlesup://payment/cancel',
    } = await req.json()

    // Validation
    if (!user_id || !email || !payment_type) {
      throw new Error('Missing required fields: user_id, email, payment_type')
    }

    if (!amount || amount <= 0) {
      throw new Error('Invalid amount')
    }

    // Get Stripe secret key - use TEST key for sandbox payments
    const stripeKey = Deno.env.get('test_SK')
    if (!stripeKey) {
      throw new Error('Stripe test secret key not configured')
    }

    // Verify it's a test key
    if (!stripeKey.startsWith('sk_test_')) {
      throw new Error('Invalid Stripe test key. Expected sk_test_... for test mode.')
    }

    console.log('✅ Checkout using TEST mode Stripe secret key')

    const stripe = new Stripe(stripeKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    // Get Supabase client
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Create Stripe checkout session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: currency.toLowerCase(),
            product_data: {
              name: description || 'BottlesUp Payment',
              description: `${payment_type} - ${description || 'Payment'}`,
            },
            unit_amount: amount, // Amount from client (already in cents)
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: `${success_url}?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url,
      customer_email: email,
      metadata: {
        user_id,
        payment_type,
        booking_id: booking_id || '',
        event_id: event_id || '',
        ...metadata,
      },
      expires_at: Math.floor(Date.now() / 1000) + 1800, // 30 minutes
    })

    // Store transaction in database
    const { data: transaction, error: dbError } = await supabase
      .from('payment_transactions')
      .insert({
        user_id,
        booking_id,
        event_id,
        amount: amount / 100, // Convert cents to dollars for storage
        currency: currency.toLowerCase(),
        status: 'pending',
        stripe_session_id: session.id,
        payment_type,
        metadata,
        created_at: new Date().toISOString(),
      })
      .select()
      .single()

    if (dbError) {
      console.error('Database error:', dbError)
      // Continue anyway - webhook will handle final state
    }

    // Return success response
    return new Response(
      JSON.stringify({
        success: true,
        checkout_url: session.url,
        session_id: session.id,
        transaction_id: transaction?.id,
        expires_at: session.expires_at,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    )
  } catch (error) {
    console.error('Payment error:', error)

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || 'Payment creation failed',
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      }
    )
  }
})
