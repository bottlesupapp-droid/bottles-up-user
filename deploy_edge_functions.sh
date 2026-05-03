#!/bin/bash

# BottlesUp Edge Function Deployment Script
# This script deploys the Stripe payment edge functions to Supabase

set -e  # Exit on error

echo "🚀 BottlesUp Payment System Deployment"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI not found${NC}"
    echo "Install it from: https://supabase.com/docs/guides/cli"
    exit 1
fi

echo -e "${GREEN}✅ Supabase CLI found${NC}"
echo ""

# Project details
PROJECT_REF="hwmynlghrmtoufyrcihp"
PROJECT_URL="https://$PROJECT_REF.supabase.co"

echo "📋 Project Details:"
echo "   Project Ref: $PROJECT_REF"
echo "   Project URL: $PROJECT_URL"
echo ""

# Step 1: Check if already linked
echo "🔗 Step 1: Linking to Supabase project..."
if supabase status &>/dev/null; then
    echo -e "${GREEN}✅ Already linked to project${NC}"
else
    echo "Linking to project $PROJECT_REF..."
    echo -e "${YELLOW}You will be prompted for your database password.${NC}"
    echo "Get it from: https://supabase.com/dashboard/project/$PROJECT_REF/settings/database"
    echo ""

    if ! supabase link --project-ref "$PROJECT_REF"; then
        echo -e "${RED}❌ Failed to link project${NC}"
        echo "Please check your database password and try again."
        exit 1
    fi
    echo -e "${GREEN}✅ Successfully linked${NC}"
fi
echo ""

# Step 2: Check secrets
echo "🔐 Step 2: Checking Stripe secrets..."
echo ""

# Check for STRIPE_SECRET_KEY
if ! supabase secrets list 2>/dev/null | grep -q "STRIPE_SECRET_KEY"; then
    echo -e "${YELLOW}⚠️  STRIPE_SECRET_KEY not found${NC}"
    echo ""
    echo "Please enter your Stripe Secret Key (from https://dashboard.stripe.com/apikeys):"
    echo -e "${YELLOW}It should start with 'sk_test_' (test) or 'sk_live_' (production)${NC}"
    read -r -p "Stripe Secret Key: " STRIPE_KEY

    if [ -z "$STRIPE_KEY" ]; then
        echo -e "${RED}❌ No key provided${NC}"
        exit 1
    fi

    echo "Setting STRIPE_SECRET_KEY..."
    if supabase secrets set STRIPE_SECRET_KEY="$STRIPE_KEY"; then
        echo -e "${GREEN}✅ STRIPE_SECRET_KEY set${NC}"
    else
        echo -e "${RED}❌ Failed to set secret${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ STRIPE_SECRET_KEY already set${NC}"
fi
echo ""

# Step 3: Deploy functions
echo "📦 Step 3: Deploying edge functions..."
echo ""

# Deploy create-checkout-session
echo "Deploying create-checkout-session..."
if supabase functions deploy create-checkout-session --no-verify-jwt; then
    echo -e "${GREEN}✅ create-checkout-session deployed${NC}"
else
    echo -e "${RED}❌ Failed to deploy create-checkout-session${NC}"
    exit 1
fi
echo ""

# Deploy stripe-webhook
echo "Deploying stripe-webhook..."
if supabase functions deploy stripe-webhook --no-verify-jwt; then
    echo -e "${GREEN}✅ stripe-webhook deployed${NC}"
else
    echo -e "${RED}❌ Failed to deploy stripe-webhook${NC}"
    exit 1
fi
echo ""

# Step 4: List deployed functions
echo "📋 Step 4: Verifying deployment..."
echo ""
supabase functions list
echo ""

# Step 5: Webhook configuration
echo "🔔 Step 5: Stripe Webhook Configuration"
echo "========================================"
echo ""
echo "Next, configure your Stripe webhook:"
echo ""
echo "1. Go to: https://dashboard.stripe.com/webhooks"
echo "2. Click 'Add endpoint'"
echo "3. Set endpoint URL to:"
echo -e "   ${GREEN}$PROJECT_URL/functions/v1/stripe-webhook${NC}"
echo ""
echo "4. Select these events:"
echo "   - checkout.session.completed"
echo "   - checkout.session.expired"
echo "   - payment_intent.payment_failed"
echo "   - charge.refunded"
echo ""
echo "5. After creating the webhook, copy the 'Signing secret' (starts with whsec_)"
echo "6. Then run:"
echo -e "   ${YELLOW}supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_YOUR_SECRET${NC}"
echo ""

# Step 6: Test URLs
echo "🧪 Testing URLs"
echo "==============="
echo ""
echo "Checkout Function:"
echo "  $PROJECT_URL/functions/v1/create-checkout-session"
echo ""
echo "Webhook Function:"
echo "  $PROJECT_URL/functions/v1/stripe-webhook"
echo ""

# Final summary
echo "✅ DEPLOYMENT COMPLETE!"
echo "======================"
echo ""
echo "What's deployed:"
echo "  ✅ create-checkout-session function"
echo "  ✅ stripe-webhook function"
echo "  ✅ STRIPE_SECRET_KEY configured"
echo ""
echo "Still needed:"
echo "  ⏳ Configure Stripe webhook (instructions above)"
echo "  ⏳ Set STRIPE_WEBHOOK_SECRET"
echo ""
echo "Test your app:"
echo "  flutter run"
echo ""
echo "View logs:"
echo "  supabase functions logs create-checkout-session"
echo "  supabase functions logs stripe-webhook"
echo ""
echo -e "${GREEN}🎉 Your payment system is ready!${NC}"
