#!/bin/bash

# Script to deploy stripe_customers migration to Supabase
# This uses the Supabase Management API to run SQL directly

PROJECT_REF="hwmynlghrmtoufyrcihp"
ACCESS_TOKEN="sbp_8eb13a655be8e8b374b1911e5c91300f524ea2cc"

echo "🚀 Deploying stripe_customers migration..."
echo ""

# Step 1: Create stripe_customers table
echo "1️⃣ Creating stripe_customers table..."
RESPONSE=$(curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE TABLE IF NOT EXISTS stripe_customers (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL, stripe_customer_id VARCHAR(255) UNIQUE NOT NULL, email VARCHAR(255) NOT NULL, created_at TIMESTAMP DEFAULT NOW(), updated_at TIMESTAMP DEFAULT NOW(), UNIQUE(user_id));"
  }')

if echo "$RESPONSE" | grep -q "error"; then
  echo "❌ Error creating table: $RESPONSE"
  exit 1
fi
echo "✅ Table created"
echo ""

# Step 2: Create indexes
echo "2️⃣ Creating indexes..."
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE INDEX IF NOT EXISTS idx_stripe_customers_user_id ON stripe_customers(user_id);"
  }' > /dev/null

curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE INDEX IF NOT EXISTS idx_stripe_customers_stripe_id ON stripe_customers(stripe_customer_id);"
  }' > /dev/null
echo "✅ Indexes created"
echo ""

# Step 3: Add column to payment_transactions
echo "3️⃣ Adding stripe_customer_id to payment_transactions..."
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = '\''payment_transactions'\'' AND column_name = '\''stripe_customer_id'\'') THEN ALTER TABLE payment_transactions ADD COLUMN stripe_customer_id VARCHAR(255); END IF; END $$;"
  }' > /dev/null
echo "✅ Column added"
echo ""

# Step 4: Enable RLS
echo "4️⃣ Enabling Row Level Security..."
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "ALTER TABLE stripe_customers ENABLE ROW LEVEL SECURITY;"
  }' > /dev/null
echo "✅ RLS enabled"
echo ""

# Step 5: Create RLS policies
echo "5️⃣ Creating RLS policies..."
# Drop existing policies first
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "DROP POLICY IF EXISTS \"Users can view their own Stripe customer\" ON stripe_customers;"
  }' > /dev/null

curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "DROP POLICY IF EXISTS \"Service role can manage all Stripe customers\" ON stripe_customers;"
  }' > /dev/null

# Create new policies
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE POLICY \"Users can view their own Stripe customer\" ON stripe_customers FOR SELECT USING (auth.uid() = user_id);"
  }' > /dev/null

curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE POLICY \"Service role can manage all Stripe customers\" ON stripe_customers FOR ALL USING (auth.jwt()->>'\''role'\'' = '\''service_role'\'');"
  }' > /dev/null
echo "✅ Policies created"
echo ""

# Step 6: Create trigger function
echo "6️⃣ Creating trigger function..."
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE OR REPLACE FUNCTION update_stripe_customers_updated_at() RETURNS TRIGGER AS $$ BEGIN NEW.updated_at = NOW(); RETURN NEW; END; $$ LANGUAGE plpgsql;"
  }' > /dev/null
echo "✅ Function created"
echo ""

# Step 7: Create trigger
echo "7️⃣ Creating trigger..."
curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "DROP TRIGGER IF EXISTS stripe_customers_updated_at ON stripe_customers;"
  }' > /dev/null

curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "CREATE TRIGGER stripe_customers_updated_at BEFORE UPDATE ON stripe_customers FOR EACH ROW EXECUTE FUNCTION update_stripe_customers_updated_at();"
  }' > /dev/null
echo "✅ Trigger created"
echo ""

# Verify migration
echo "8️⃣ Verifying migration..."
VERIFY=$(curl -s -X POST "https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "SELECT table_name FROM information_schema.tables WHERE table_name = '\''stripe_customers'\'' AND table_schema = '\''public'\'';"
  }')

if echo "$VERIFY" | grep -q "stripe_customers"; then
  echo "✅ Migration verified successfully!"
  echo ""
  echo "🎉 stripe_customers table is ready!"
  echo ""
  echo "Next steps:"
  echo "1. Set STRIPE_PUBLISHABLE_KEY secret"
  echo "2. Update Stripe webhook events"
  echo "3. Update Flutter checkout screens"
else
  echo "❌ Verification failed"
  exit 1
fi
