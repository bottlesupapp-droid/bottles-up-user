# Supabase Database Migration Guide
## BottlesUp User App - Feature Enhancements

**Migration Date**: April 16, 2026
**Version**: 2.0.0
**Author**: Claude AI Assistant

---

## 📋 Table of Contents
1. [Overview](#overview)
2. [New Tables](#new-tables)
3. [Modified Tables](#modified-tables)
4. [Database Functions](#database-functions)
5. [Row Level Security (RLS) Policies](#rls-policies)
6. [Storage Buckets](#storage-buckets)
7. [Indexes](#indexes)
8. [Migration Scripts](#migration-scripts)

---

## Overview

This migration adds support for 27 new features including:
- Wallet integration (Google/Apple)
- Enhanced search and filtering
- Bottle upgrades
- Add-ons system (hookah, decor, sparklers)
- Special requests
- Trending algorithm
- Refund management
- Ticket resale marketplace
- Contact invites
- Photo uploads

**IMPORTANT**: Run migrations in the order specified below to avoid foreign key constraint errors.

---

## 🆕 New Tables

### 1. wallet_passes
Stores Google Wallet and Apple Wallet pass information.

```sql
CREATE TABLE wallet_passes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  wallet_type TEXT NOT NULL CHECK (wallet_type IN ('google', 'apple')),
  pass_url TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'expired')),
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  UNIQUE(ticket_id, wallet_type)
);

-- Index for fast lookups
CREATE INDEX idx_wallet_passes_ticket_id ON wallet_passes(ticket_id);
CREATE INDEX idx_wallet_passes_status ON wallet_passes(status);

-- Enable RLS
ALTER TABLE wallet_passes ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own wallet passes"
  ON wallet_passes FOR SELECT
  USING (
    ticket_id IN (
      SELECT id FROM tickets WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert their own wallet passes"
  ON wallet_passes FOR INSERT
  WITH CHECK (
    ticket_id IN (
      SELECT id FROM tickets WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update their own wallet passes"
  ON wallet_passes FOR UPDATE
  USING (
    ticket_id IN (
      SELECT id FROM tickets WHERE user_id = auth.uid()
    )
  );

-- Trigger for updated_at
CREATE TRIGGER update_wallet_passes_updated_at
  BEFORE UPDATE ON wallet_passes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 2. search_history
Tracks user search queries for autocomplete and analytics.

```sql
CREATE TABLE search_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  query TEXT NOT NULL,
  filters JSONB DEFAULT '{}'::jsonb,
  results_count INT DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_search_history_user_id ON search_history(user_id);
CREATE INDEX idx_search_history_created_at ON search_history(created_at DESC);
CREATE INDEX idx_search_history_query ON search_history USING gin(to_tsvector('english', query));

-- Enable RLS
ALTER TABLE search_history ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own search history"
  ON search_history FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert their own searches"
  ON search_history FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can delete their own search history"
  ON search_history FOR DELETE
  USING (user_id = auth.uid());
```

### 3. bottle_upgrades
Available bottle upgrade options.

```sql
CREATE TABLE bottle_upgrades (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bottle_id UUID NOT NULL REFERENCES bottles(id) ON DELETE CASCADE,
  upgrade_bottle_id UUID NOT NULL REFERENCES bottles(id) ON DELETE CASCADE,
  original_bottle_name TEXT NOT NULL,
  upgrade_bottle_name TEXT NOT NULL,
  original_price DECIMAL(10,2) NOT NULL,
  upgrade_price DECIMAL(10,2) NOT NULL,
  price_difference DECIMAL(10,2) GENERATED ALWAYS AS (upgrade_price - original_price) STORED,
  description TEXT,
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  is_premium BOOLEAN DEFAULT false,
  remaining_stock INT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT different_bottles CHECK (bottle_id != upgrade_bottle_id)
);

-- Indexes
CREATE INDEX idx_bottle_upgrades_bottle_id ON bottle_upgrades(bottle_id);
CREATE INDEX idx_bottle_upgrades_available ON bottle_upgrades(is_available) WHERE is_available = true;
CREATE INDEX idx_bottle_upgrades_premium ON bottle_upgrades(is_premium) WHERE is_premium = true;

-- Enable RLS
ALTER TABLE bottle_upgrades ENABLE ROW LEVEL SECURITY;

-- RLS Policies (public read)
CREATE POLICY "Anyone can view available upgrades"
  ON bottle_upgrades FOR SELECT
  USING (is_available = true);

-- Trigger
CREATE TRIGGER update_bottle_upgrades_updated_at
  BEFORE UPDATE ON bottle_upgrades
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 4. upgrade_requests
User requests to upgrade their bottle.

```sql
CREATE TABLE upgrade_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  original_bottle_id UUID NOT NULL REFERENCES bottles(id),
  upgrade_bottle_id UUID NOT NULL REFERENCES bottles(id),
  price_difference DECIMAL(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed')),
  notes TEXT,
  approved_at TIMESTAMPTZ,
  rejected_at TIMESTAMPTZ,
  rejection_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT valid_status_times CHECK (
    (status = 'approved' AND approved_at IS NOT NULL) OR
    (status = 'rejected' AND rejected_at IS NOT NULL) OR
    (status IN ('pending', 'completed'))
  )
);

-- Indexes
CREATE INDEX idx_upgrade_requests_booking_id ON upgrade_requests(booking_id);
CREATE INDEX idx_upgrade_requests_user_id ON upgrade_requests(user_id);
CREATE INDEX idx_upgrade_requests_status ON upgrade_requests(status);

-- Enable RLS
ALTER TABLE upgrade_requests ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own upgrade requests"
  ON upgrade_requests FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can create upgrade requests for their bookings"
  ON upgrade_requests FOR INSERT
  WITH CHECK (
    user_id = auth.uid() AND
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can update their pending requests"
  ON upgrade_requests FOR UPDATE
  USING (user_id = auth.uid() AND status = 'pending');
```

### 5. addons
Available add-ons (hookah, decor, sparklers, etc).

```sql
CREATE TABLE addons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('hookah', 'decoration', 'sparklers', 'photography', 'entertainment', 'food', 'other')),
  price DECIMAL(10,2) NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  requires_approval BOOLEAN DEFAULT false,
  max_quantity INT,
  available_stock INT,
  included_items TEXT[],
  estimated_duration TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_addons_venue_id ON addons(venue_id);
CREATE INDEX idx_addons_category ON addons(category);
CREATE INDEX idx_addons_available ON addons(is_available) WHERE is_available = true;

-- Enable RLS
ALTER TABLE addons ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Anyone can view available addons"
  ON addons FOR SELECT
  USING (is_available = true);

-- Trigger
CREATE TRIGGER update_addons_updated_at
  BEFORE UPDATE ON addons
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 6. booking_addons
Add-ons attached to bookings.

```sql
CREATE TABLE booking_addons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  addon_id UUID NOT NULL REFERENCES addons(id),
  addon_name TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
  total_price DECIMAL(10,2) GENERATED ALWAYS AS (price * quantity) STORED,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'preparing', 'delivered', 'cancelled')),
  special_instructions TEXT,
  scheduled_time TIMESTAMPTZ,
  approved_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_booking_addons_booking_id ON booking_addons(booking_id);
CREATE INDEX idx_booking_addons_addon_id ON booking_addons(addon_id);
CREATE INDEX idx_booking_addons_status ON booking_addons(status);

-- Enable RLS
ALTER TABLE booking_addons ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view addons for their bookings"
  ON booking_addons FOR SELECT
  USING (
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can add addons to their bookings"
  ON booking_addons FOR INSERT
  WITH CHECK (
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can update their booking addons"
  ON booking_addons FOR UPDATE
  USING (
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );
```

### 7. special_requests
Custom requests for bookings (dietary, accessibility, etc).

```sql
CREATE TABLE special_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('dietary', 'accessibility', 'music', 'seating', 'celebration', 'other')),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'acknowledged', 'approved', 'declined', 'completed')),
  response_message TEXT,
  response_time TIMESTAMPTZ,
  is_priority BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_special_requests_booking_id ON special_requests(booking_id);
CREATE INDEX idx_special_requests_user_id ON special_requests(user_id);
CREATE INDEX idx_special_requests_status ON special_requests(status);
CREATE INDEX idx_special_requests_type ON special_requests(type);

-- Enable RLS
ALTER TABLE special_requests ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own requests"
  ON special_requests FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can create requests for their bookings"
  ON special_requests FOR INSERT
  WITH CHECK (
    user_id = auth.uid() AND
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );

CREATE POLICY "Users can update their pending requests"
  ON special_requests FOR UPDATE
  USING (user_id = auth.uid() AND status = 'pending');

-- Trigger
CREATE TRIGGER update_special_requests_updated_at
  BEFORE UPDATE ON special_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 8. request_templates
Pre-made templates for special requests.

```sql
CREATE TABLE request_templates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type TEXT NOT NULL CHECK (type IN ('dietary', 'accessibility', 'music', 'seating', 'celebration', 'other')),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  example_text TEXT,
  is_popular BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index
CREATE INDEX idx_request_templates_type ON request_templates(type);
CREATE INDEX idx_request_templates_popular ON request_templates(is_popular) WHERE is_popular = true;

-- Enable RLS
ALTER TABLE request_templates ENABLE ROW LEVEL SECURITY;

-- RLS Policy (public read)
CREATE POLICY "Anyone can view request templates"
  ON request_templates FOR SELECT
  USING (true);

-- Insert default templates
INSERT INTO request_templates (type, title, description, example_text, is_popular) VALUES
  ('celebration', 'Birthday Celebration', 'Special arrangements for birthday', 'Please help arrange a birthday surprise with cake and sparklers', true),
  ('dietary', 'Dietary Restrictions', 'Food allergies or dietary needs', 'I have a gluten allergy and need gluten-free options', true),
  ('music', 'Music Request', 'Specific music preferences', 'Please play more hip-hop music during our time', true),
  ('seating', 'Seating Preference', 'Preferred table location', 'We prefer a table near the dance floor', true),
  ('accessibility', 'Accessibility Needs', 'Wheelchair access or other needs', 'Wheelchair accessible table needed', true);
```

### 9. event_views
Track event views for trending algorithm.

```sql
CREATE TABLE event_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  session_id TEXT,
  ip_address INET,
  user_agent TEXT
);

-- Indexes
CREATE INDEX idx_event_views_event_id ON event_views(event_id);
CREATE INDEX idx_event_views_user_id ON event_views(user_id);
CREATE INDEX idx_event_views_viewed_at ON event_views(viewed_at DESC);

-- Enable RLS
ALTER TABLE event_views ENABLE ROW LEVEL SECURITY;

-- RLS Policy (anyone can insert, users can view their own)
CREATE POLICY "Anyone can track event views"
  ON event_views FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can view their own event views"
  ON event_views FOR SELECT
  USING (user_id = auth.uid() OR user_id IS NULL);
```

### 10. event_shares
Track event shares for viral tracking.

```sql
CREATE TABLE event_shares (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  platform TEXT NOT NULL CHECK (platform IN ('facebook', 'instagram', 'twitter', 'whatsapp', 'sms', 'email', 'link')),
  shared_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_event_shares_event_id ON event_shares(event_id);
CREATE INDEX idx_event_shares_platform ON event_shares(platform);
CREATE INDEX idx_event_shares_shared_at ON event_shares(shared_at DESC);

-- Enable RLS
ALTER TABLE event_shares ENABLE ROW LEVEL SECURITY;

-- RLS Policy
CREATE POLICY "Anyone can track shares"
  ON event_shares FOR INSERT
  WITH CHECK (true);
```

### 11. ticket_resales
Ticket resale marketplace.

```sql
CREATE TABLE ticket_resales (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ticket_id UUID NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
  seller_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
  original_price DECIMAL(10,2) NOT NULL,
  listing_price DECIMAL(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'listed' CHECK (status IN ('listed', 'sold', 'cancelled', 'expired')),
  buyer_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  sold_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT valid_price CHECK (listing_price > 0),
  CONSTRAINT seller_not_buyer CHECK (seller_id != buyer_id OR buyer_id IS NULL)
);

-- Indexes
CREATE INDEX idx_ticket_resales_ticket_id ON ticket_resales(ticket_id);
CREATE INDEX idx_ticket_resales_seller_id ON ticket_resales(seller_id);
CREATE INDEX idx_ticket_resales_event_id ON ticket_resales(event_id);
CREATE INDEX idx_ticket_resales_status ON ticket_resales(status);

-- Enable RLS
ALTER TABLE ticket_resales ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Anyone can view active listings"
  ON ticket_resales FOR SELECT
  USING (status = 'listed');

CREATE POLICY "Sellers can manage their listings"
  ON ticket_resales FOR ALL
  USING (seller_id = auth.uid());

-- Trigger
CREATE TRIGGER update_ticket_resales_updated_at
  BEFORE UPDATE ON ticket_resales
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
```

### 12. resale_offers
Offers on resale tickets.

```sql
CREATE TABLE resale_offers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  resale_id UUID NOT NULL REFERENCES ticket_resales(id) ON DELETE CASCADE,
  buyer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  offered_price DECIMAL(10,2) NOT NULL CHECK (offered_price > 0),
  message TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'expired')),
  responded_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '24 hours'),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_resale_offers_resale_id ON resale_offers(resale_id);
CREATE INDEX idx_resale_offers_buyer_id ON resale_offers(buyer_id);
CREATE INDEX idx_resale_offers_status ON resale_offers(status);

-- Enable RLS
ALTER TABLE resale_offers ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Buyers can create offers"
  ON resale_offers FOR INSERT
  WITH CHECK (buyer_id = auth.uid());

CREATE POLICY "Buyers can view their offers"
  ON resale_offers FOR SELECT
  USING (buyer_id = auth.uid());

CREATE POLICY "Sellers can view offers on their listings"
  ON resale_offers FOR SELECT
  USING (
    resale_id IN (SELECT id FROM ticket_resales WHERE seller_id = auth.uid())
  );

CREATE POLICY "Sellers can update offers"
  ON resale_offers FOR UPDATE
  USING (
    resale_id IN (SELECT id FROM ticket_resales WHERE seller_id = auth.uid())
  );
```

### 13. event_invites
Track contact invitations.

```sql
CREATE TABLE event_invites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  recipient_email TEXT,
  recipient_phone TEXT,
  event_link TEXT NOT NULL,
  invite_type TEXT NOT NULL CHECK (invite_type IN ('email', 'sms', 'whatsapp')),
  status TEXT NOT NULL DEFAULT 'sent' CHECK (status IN ('sent', 'opened', 'accepted', 'declined')),
  opened_at TIMESTAMPTZ,
  responded_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT has_recipient CHECK (recipient_email IS NOT NULL OR recipient_phone IS NOT NULL)
);

-- Indexes
CREATE INDEX idx_event_invites_sender_id ON event_invites(sender_id);
CREATE INDEX idx_event_invites_event_id ON event_invites(event_id);
CREATE INDEX idx_event_invites_status ON event_invites(status);
CREATE INDEX idx_event_invites_email ON event_invites(recipient_email);

-- Enable RLS
ALTER TABLE event_invites ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their sent invites"
  ON event_invites FOR SELECT
  USING (sender_id = auth.uid());

CREATE POLICY "Users can send invites"
  ON event_invites FOR INSERT
  WITH CHECK (sender_id = auth.uid());
```

### 14. refund_requests
Refund request management.

```sql
CREATE TABLE refund_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  booking_id UUID NOT NULL REFERENCES bookings(id) ON DELETE CASCADE,
  original_amount DECIMAL(10,2) NOT NULL,
  requested_amount DECIMAL(10,2) NOT NULL,
  approved_amount DECIMAL(10,2),
  reason TEXT NOT NULL CHECK (reason IN ('event_cancelled', 'poor_experience', 'service_issue', 'billing_error', 'personal', 'other')),
  description TEXT NOT NULL,
  attachments TEXT[],
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed')),
  reviewed_by UUID REFERENCES auth.users(id),
  reviewed_at TIMESTAMPTZ,
  review_notes TEXT,
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT valid_amounts CHECK (requested_amount > 0 AND requested_amount <= original_amount)
);

-- Indexes
CREATE INDEX idx_refund_requests_user_id ON refund_requests(user_id);
CREATE INDEX idx_refund_requests_booking_id ON refund_requests(booking_id);
CREATE INDEX idx_refund_requests_status ON refund_requests(status);

-- Enable RLS
ALTER TABLE refund_requests ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own refund requests"
  ON refund_requests FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can create refund requests for their bookings"
  ON refund_requests FOR INSERT
  WITH CHECK (
    user_id = auth.uid() AND
    booking_id IN (SELECT id FROM bookings WHERE user_id = auth.uid())
  );
```

---

## 📦 Storage Buckets

### 1. event-photos
For user-uploaded event photos.

```sql
-- Create storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('event-photos', 'event-photos', true);

-- Storage policies
CREATE POLICY "Users can upload event photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'event-photos' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Anyone can view event photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'event-photos');

CREATE POLICY "Users can delete their own photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'event-photos' AND
  (storage.foldername(name))[1] = auth.uid()::text
);
```

### 2. refund-attachments
For refund request attachments.

```sql
-- Create storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('refund-attachments', 'refund-attachments', false);

-- Storage policies
CREATE POLICY "Users can upload refund attachments"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'refund-attachments' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can view their own attachments"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'refund-attachments' AND
  (storage.foldername(name))[1] = auth.uid()::text
);
```

---

## 🔧 Database Functions

### 1. Trending Events Algorithm

```sql
CREATE OR REPLACE FUNCTION get_trending_events(
  limit_count INT DEFAULT 10,
  category_filter TEXT DEFAULT NULL
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  venue_name TEXT,
  event_date TIMESTAMPTZ,
  cover_image TEXT,
  trending_score DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.name,
    v.name as venue_name,
    e.event_date,
    e.cover_image,
    (
      -- Views in last 7 days (weight: 1)
      COALESCE((SELECT COUNT(*) FROM event_views WHERE event_id = e.id AND viewed_at > NOW() - INTERVAL '7 days'), 0) * 1.0 +

      -- Bookings in last 7 days (weight: 5)
      COALESCE((SELECT COUNT(*) FROM bookings WHERE event_id = e.id AND created_at > NOW() - INTERVAL '7 days'), 0) * 5.0 +

      -- Shares in last 7 days (weight: 3)
      COALESCE((SELECT COUNT(*) FROM event_shares WHERE event_id = e.id AND shared_at > NOW() - INTERVAL '7 days'), 0) * 3.0 +

      -- Venue rating (weight: 2)
      COALESCE(v.rating, 0) * 2.0
    ) as trending_score
  FROM events e
  INNER JOIN venues v ON e.venue_id = v.id
  WHERE
    e.event_date > NOW() AND
    e.is_published = true AND
    (category_filter IS NULL OR e.category = category_filter)
  ORDER BY trending_score DESC, e.event_date ASC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 2. Personalized Recommendations

```sql
CREATE OR REPLACE FUNCTION get_personalized_recommendations(
  user_id_param UUID,
  limit_count INT DEFAULT 10
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  venue_name TEXT,
  event_date TIMESTAMPTZ,
  cover_image TEXT,
  recommendation_score DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.id,
    e.name,
    v.name as venue_name,
    e.event_date,
    e.cover_image,
    (
      -- User's favorite categories (weight: 5)
      CASE WHEN e.category IN (
        SELECT DISTINCT category FROM bookings b
        INNER JOIN events ev ON b.event_id = ev.id
        WHERE b.user_id = user_id_param
        LIMIT 3
      ) THEN 5.0 ELSE 0.0 END +

      -- Venue rating (weight: 2)
      COALESCE(v.rating, 0) * 2.0 +

      -- Price range preference (weight: 3)
      CASE WHEN e.min_price BETWEEN
        COALESCE((SELECT AVG(total_amount) * 0.8 FROM bookings WHERE user_id = user_id_param), 0) AND
        COALESCE((SELECT AVG(total_amount) * 1.2 FROM bookings WHERE user_id = user_id_param), 10000)
      THEN 3.0 ELSE 0.0 END
    ) as recommendation_score
  FROM events e
  INNER JOIN venues v ON e.venue_id = v.id
  WHERE
    e.event_date > NOW() AND
    e.is_published = true AND
    e.id NOT IN (SELECT event_id FROM bookings WHERE user_id = user_id_param)
  ORDER BY recommendation_score DESC, e.event_date ASC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 3. Search Events and Venues

```sql
CREATE OR REPLACE FUNCTION search_events_and_venues(
  search_query TEXT,
  categories TEXT[] DEFAULT NULL,
  date_start TIMESTAMPTZ DEFAULT NULL,
  date_end TIMESTAMPTZ DEFAULT NULL,
  price_min DECIMAL DEFAULT NULL,
  price_max DECIMAL DEFAULT NULL,
  max_distance DECIMAL DEFAULT NULL,
  neighborhoods TEXT[] DEFAULT NULL,
  amenities TEXT[] DEFAULT NULL,
  has_availability BOOLEAN DEFAULT NULL,
  bottle_service BOOLEAN DEFAULT NULL,
  verified_only BOOLEAN DEFAULT NULL,
  sort_by TEXT DEFAULT 'relevance',
  limit_count INT DEFAULT 20,
  offset_count INT DEFAULT 0
)
RETURNS TABLE (
  id UUID,
  type TEXT,
  title TEXT,
  subtitle TEXT,
  image_url TEXT,
  rating DECIMAL,
  review_count INT,
  price DECIMAL,
  location TEXT,
  event_date TIMESTAMPTZ,
  is_verified BOOLEAN,
  is_featured BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  -- Events
  SELECT
    e.id,
    'event'::TEXT as type,
    e.name as title,
    v.name as subtitle,
    e.cover_image as image_url,
    v.rating,
    v.review_count,
    e.min_price as price,
    v.address as location,
    e.event_date,
    v.is_verified,
    e.is_featured
  FROM events e
  INNER JOIN venues v ON e.venue_id = v.id
  WHERE
    (search_query IS NULL OR
     e.name ILIKE '%' || search_query || '%' OR
     e.description ILIKE '%' || search_query || '%' OR
     v.name ILIKE '%' || search_query || '%') AND
    (categories IS NULL OR e.category = ANY(categories)) AND
    (date_start IS NULL OR e.event_date >= date_start) AND
    (date_end IS NULL OR e.event_date <= date_end) AND
    (price_min IS NULL OR e.min_price >= price_min) AND
    (price_max IS NULL OR e.min_price <= price_max) AND
    (has_availability IS NULL OR e.available_tickets > 0) AND
    e.is_published = true

  UNION ALL

  -- Venues
  SELECT
    v.id,
    'venue'::TEXT as type,
    v.name as title,
    v.neighborhood as subtitle,
    v.cover_image as image_url,
    v.rating,
    v.review_count,
    NULL as price,
    v.address as location,
    NULL as event_date,
    v.is_verified,
    false as is_featured
  FROM venues v
  WHERE
    (search_query IS NULL OR
     v.name ILIKE '%' || search_query || '%' OR
     v.description ILIKE '%' || search_query || '%') AND
    (neighborhoods IS NULL OR v.neighborhood = ANY(neighborhoods)) AND
    (verified_only IS NULL OR verified_only = false OR v.is_verified = true)

  ORDER BY
    CASE
      WHEN sort_by = 'price_low' THEN price
      WHEN sort_by = 'price_high' THEN -price
      WHEN sort_by = 'rating' THEN -rating
      WHEN sort_by = 'date' THEN EXTRACT(EPOCH FROM event_date)
      ELSE -COALESCE(rating, 0)
    END
  LIMIT limit_count
  OFFSET offset_count;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 4. Process Upgrade Payment

```sql
CREATE OR REPLACE FUNCTION process_upgrade_payment(
  upgrade_request_id UUID,
  user_id UUID,
  amount DECIMAL
)
RETURNS BOOLEAN AS $$
DECLARE
  success BOOLEAN := false;
BEGIN
  -- In production, integrate with Stripe/payment processor
  -- For now, simulate payment

  -- Update upgrade request
  UPDATE upgrade_requests
  SET
    status = 'approved',
    approved_at = NOW()
  WHERE id = upgrade_request_id AND user_id = user_id;

  -- Create payment record
  INSERT INTO payments (user_id, amount, type, status, metadata)
  VALUES (
    user_id,
    amount,
    'upgrade',
    'completed',
    jsonb_build_object('upgrade_request_id', upgrade_request_id)
  );

  success := true;
  RETURN success;
EXCEPTION
  WHEN OTHERS THEN
    RETURN false;
END;
$$ LANGUAGE plpgsql;
```

### 5. Get Popular Add-ons

```sql
CREATE OR REPLACE FUNCTION get_popular_addons(
  limit_count INT DEFAULT 10
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  description TEXT,
  category TEXT,
  price DECIMAL,
  image_url TEXT,
  order_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    a.id,
    a.name,
    a.description,
    a.category,
    a.price,
    a.image_url,
    COUNT(ba.id) as order_count
  FROM addons a
  LEFT JOIN booking_addons ba ON a.id = ba.addon_id
  WHERE a.is_available = true
  GROUP BY a.id
  ORDER BY order_count DESC, a.name ASC
  LIMIT limit_count;
END;
$$ LANGUAGE plpgsql STABLE;
```

---

## 📊 Indexes for Performance

```sql
-- Full-text search indexes
CREATE INDEX idx_events_search ON events USING gin(
  to_tsvector('english', name || ' ' || COALESCE(description, ''))
);

CREATE INDEX idx_venues_search ON venues USING gin(
  to_tsvector('english', name || ' ' || COALESCE(description, ''))
);

-- Composite indexes for common queries
CREATE INDEX idx_events_date_published ON events(event_date, is_published)
  WHERE is_published = true;

CREATE INDEX idx_events_category_date ON events(category, event_date)
  WHERE is_published = true;

-- Partial indexes for active records
CREATE INDEX idx_bookings_active ON bookings(user_id, status)
  WHERE status IN ('confirmed', 'pending');

CREATE INDEX idx_tickets_active ON tickets(user_id, status)
  WHERE status = 'active';
```

---

## 🔐 Additional RLS Policies

### Update users table for wallet preferences

```sql
-- Add columns to existing users/profiles table
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS
  wallet_preferences JSONB DEFAULT '{
    "google_wallet_enabled": true,
    "apple_wallet_enabled": true,
    "auto_add_to_wallet": false
  }'::jsonb;

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS
  notification_preferences JSONB DEFAULT '{
    "push_enabled": true,
    "email_enabled": true,
    "sms_enabled": true,
    "marketing_enabled": true
  }'::jsonb;
```

---

## 🚀 Migration Script (Run in Order)

```sql
-- Migration Script v2.0.0
-- Run this script in Supabase SQL Editor

BEGIN;

-- Step 1: Create updated_at trigger function (if not exists)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create all tables in dependency order
-- (Copy each CREATE TABLE statement from above)

-- Step 3: Create storage buckets
-- (Copy bucket creation statements)

-- Step 4: Create functions
-- (Copy all function definitions)

-- Step 5: Create indexes
-- (Copy all index creation statements)

-- Step 6: Insert seed data
-- (Copy request_templates INSERT)

COMMIT;

-- Verify migration
SELECT
  'wallet_passes' as table_name, COUNT(*) as count FROM wallet_passes
UNION ALL
SELECT 'search_history', COUNT(*) FROM search_history
UNION ALL
SELECT 'bottle_upgrades', COUNT(*) FROM bottle_upgrades
UNION ALL
SELECT 'upgrade_requests', COUNT(*) FROM upgrade_requests
UNION ALL
SELECT 'addons', COUNT(*) FROM addons
UNION ALL
SELECT 'booking_addons', COUNT(*) FROM booking_addons
UNION ALL
SELECT 'special_requests', COUNT(*) FROM special_requests
UNION ALL
SELECT 'request_templates', COUNT(*) FROM request_templates
UNION ALL
SELECT 'event_views', COUNT(*) FROM event_views
UNION ALL
SELECT 'event_shares', COUNT(*) FROM event_shares
UNION ALL
SELECT 'ticket_resales', COUNT(*) FROM ticket_resales
UNION ALL
SELECT 'resale_offers', COUNT(*) FROM resale_offers
UNION ALL
SELECT 'event_invites', COUNT(*) FROM event_invites
UNION ALL
SELECT 'refund_requests', COUNT(*) FROM refund_requests;
```

---

## ✅ Post-Migration Checklist

- [ ] All tables created successfully
- [ ] RLS policies enabled on all tables
- [ ] Storage buckets created with policies
- [ ] Database functions created and tested
- [ ] Indexes created for performance
- [ ] Seed data inserted
- [ ] Test data migration rollback plan prepared
- [ ] Backup created before migration
- [ ] App updated with new schema
- [ ] API endpoints tested
- [ ] Performance benchmarks verified

---

## 🔄 Rollback Plan

If migration fails, run:

```sql
BEGIN;

-- Drop tables in reverse order
DROP TABLE IF EXISTS refund_requests CASCADE;
DROP TABLE IF EXISTS event_invites CASCADE;
DROP TABLE IF EXISTS resale_offers CASCADE;
DROP TABLE IF EXISTS ticket_resales CASCADE;
DROP TABLE IF EXISTS event_shares CASCADE;
DROP TABLE IF EXISTS event_views CASCADE;
DROP TABLE IF EXISTS request_templates CASCADE;
DROP TABLE IF EXISTS special_requests CASCADE;
DROP TABLE IF EXISTS booking_addons CASCADE;
DROP TABLE IF EXISTS addons CASCADE;
DROP TABLE IF EXISTS upgrade_requests CASCADE;
DROP TABLE IF EXISTS bottle_upgrades CASCADE;
DROP TABLE IF EXISTS search_history CASCADE;
DROP TABLE IF EXISTS wallet_passes CASCADE;

-- Drop functions
DROP FUNCTION IF EXISTS get_trending_events CASCADE;
DROP FUNCTION IF EXISTS get_personalized_recommendations CASCADE;
DROP FUNCTION IF EXISTS search_events_and_venues CASCADE;
DROP FUNCTION IF EXISTS process_upgrade_payment CASCADE;
DROP FUNCTION IF EXISTS get_popular_addons CASCADE;

-- Remove storage buckets
DELETE FROM storage.buckets WHERE id IN ('event-photos', 'refund-attachments');

COMMIT;
```

---

**END OF MIGRATION DOCUMENT**

*For support, contact: dev@bottlesup.app*
