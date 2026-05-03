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

CREATE TRIGGER stripe_customers_updated_at
  BEFORE UPDATE ON stripe_customers
  FOR EACH ROW
  EXECUTE FUNCTION update_stripe_customers_updated_at();
