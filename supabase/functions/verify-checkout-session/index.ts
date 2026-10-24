import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import Stripe from 'https://esm.sh/stripe@14.21.0';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // Get TEST mode Stripe key from Supabase secrets
    const stripeSecretKey = Deno.env.get('test_SK');
    const stripePublishableKey = Deno.env.get('test_PK');

    if (!stripeSecretKey || !stripePublishableKey) {
      throw new Error('Stripe keys not configured in Supabase secrets');
    }

    // Verify we're using TEST mode keys
    if (!stripeSecretKey.startsWith('sk_test_')) {
      throw new Error('SECURITY: Only TEST mode keys are allowed. Use test_SK secret.');
    }

    if (!stripePublishableKey.startsWith('pk_test_')) {
      throw new Error('SECURITY: Only TEST mode keys are allowed. Use test_PK secret.');
    }

    const stripe = new Stripe(stripeSecretKey, {
      apiVersion: '2023-10-16',
    });

    const { sessionId } = await req.json();

    if (!sessionId) {
      return new Response(
        JSON.stringify({ error: 'Session ID is required' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    console.log('💳 Verifying checkout session:', sessionId);

    // Retrieve the checkout session from Stripe
    const session = await stripe.checkout.sessions.retrieve(sessionId);

    console.log('💳 Session status:', session.payment_status);
    console.log('💳 Session amount:', session.amount_total);

    // Check if payment was successful
    if (session.payment_status === 'paid') {
      console.log('✅ Payment verified successfully');

      return new Response(
        JSON.stringify({
          success: true,
          session: {
            id: session.id,
            paymentStatus: session.payment_status,
            amount: session.amount_total,
            currency: session.currency,
            customerEmail: session.customer_details?.email,
            paymentIntent: session.payment_intent,
          },
          publishableKey: stripePublishableKey,
        }),
        {
          status: 200,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    } else {
      console.log('❌ Payment not completed');

      return new Response(
        JSON.stringify({
          success: false,
          error: 'Payment not completed',
          session: {
            id: session.id,
            paymentStatus: session.payment_status,
          },
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }
  } catch (error: any) {
    console.error('❌ Error verifying checkout session:', error);

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || 'Failed to verify checkout session',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});
