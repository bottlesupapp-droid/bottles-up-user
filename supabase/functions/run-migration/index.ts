import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Run the migration SQL
    const migrationSQL = `
-- Create stripe_customers table for storing Stripe customer IDs
CREATE TABLE IF NOT EXISTS stripe_customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  stripe_customer_id VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_stripe_customers_user_id ON stripe_customers(user_id);
CREATE INDEX IF NOT EXISTS idx_stripe_customers_stripe_id ON stripe_customers(stripe_customer_id);

-- Add stripe_customer_id to payment_transactions if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'payment_transactions'
    AND column_name = 'stripe_customer_id'
  ) THEN
    ALTER TABLE payment_transactions
    ADD COLUMN stripe_customer_id VARCHAR(255);
  END IF;
END $$;

-- Enable RLS
ALTER TABLE stripe_customers ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own Stripe customer" ON stripe_customers;
DROP POLICY IF EXISTS "Service role can manage all Stripe customers" ON stripe_customers;

-- Create policies
CREATE POLICY "Users can view their own Stripe customer"
  ON stripe_customers FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Service role can manage all Stripe customers"
  ON stripe_customers FOR ALL
  USING (auth.jwt()->>'role' = 'service_role');

-- Add updated_at trigger
CREATE OR REPLACE FUNCTION update_stripe_customers_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS stripe_customers_updated_at ON stripe_customers;

-- Create trigger
CREATE TRIGGER stripe_customers_updated_at
  BEFORE UPDATE ON stripe_customers
  FOR EACH ROW
  EXECUTE FUNCTION update_stripe_customers_updated_at();
    `

    // Execute the migration
    const { data, error } = await supabase.rpc('exec_sql', {
      query: migrationSQL
    })

    if (error) {
      console.error('Migration error:', error)
      return new Response(
        JSON.stringify({
          success: false,
          error: error.message,
          details: error
        }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Migration completed successfully',
        data
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message
      }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
