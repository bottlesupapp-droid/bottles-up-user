-- =============================================================================
-- SUPABASE DATABASE SCHEMA FOR NIGHTCLUB BOOKING APP
-- =============================================================================
-- This schema supports a mobile app similar to "District" for nightclub bookings
-- Features: club listings, reviews, bottle menus, table bookings
-- =============================================================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- CATEGORIES TABLE
-- =============================================================================
-- Stores nightclub categories (e.g., Rooftop, Underground, Sports Bar, etc.)
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    icon VARCHAR(50) NOT NULL, -- Icon identifier for mobile app
    description TEXT,
    color VARCHAR(7), -- Hex color code (e.g., #FF6B00)
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments for documentation
COMMENT ON TABLE categories IS 'Stores nightclub categories for filtering and organization';
COMMENT ON COLUMN categories.icon IS 'Icon identifier for mobile app display';
COMMENT ON COLUMN categories.color IS 'Hex color code for category theming';

-- Index for categories table
CREATE INDEX idx_categories_active ON categories USING btree(is_active) WHERE is_active = true;
CREATE INDEX idx_categories_name ON categories USING btree(name);

-- =============================================================================
-- PROFILES TABLE
-- =============================================================================
-- User profiles with additional information beyond auth.users
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    age INTEGER CHECK (age >= 13 AND age <= 120),
    avatar_url TEXT,
    bio TEXT,
    location VARCHAR(255),
    preferences JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments for documentation
COMMENT ON TABLE profiles IS 'User profiles with additional information beyond auth.users';
COMMENT ON COLUMN profiles.id IS 'References auth.users.id - one profile per user';
COMMENT ON COLUMN profiles.name IS 'Display name for the user';
COMMENT ON COLUMN profiles.email IS 'User email (may differ from auth.users.email)';
COMMENT ON COLUMN profiles.phone_number IS 'User phone number';
COMMENT ON COLUMN profiles.age IS 'User age (13-120 years)';
COMMENT ON COLUMN profiles.preferences IS 'JSON object for user preferences and settings';

-- Create indexes for better performance
CREATE INDEX idx_profiles_email ON profiles USING btree(email);
CREATE INDEX idx_profiles_name ON profiles USING btree(name);
CREATE INDEX idx_profiles_active ON profiles USING btree(is_active) WHERE is_active = true;
CREATE INDEX idx_profiles_created_at ON profiles USING btree(created_at DESC);

-- =============================================================================
-- CLUBS TABLE
-- =============================================================================
-- Stores nightclub information with location, pricing, and ratings
CREATE TABLE clubs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    location TEXT NOT NULL,
    description TEXT,
    price_min DECIMAL(10,2) CHECK (price_min >= 0),
    price_max DECIMAL(10,2) CHECK (price_max >= price_min),
    avg_rating DECIMAL(3,2) DEFAULT 0 CHECK (avg_rating >= 0 AND avg_rating <= 5),
    review_count INTEGER DEFAULT 0 CHECK (review_count >= 0),
    image_url TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    website_url TEXT,
    opening_hours JSONB, -- Store opening hours as JSON for flexibility
    dress_code TEXT DEFAULT 'Smart casual to formal attire required', -- Dress code requirements
    age_requirement TEXT DEFAULT '21+ with valid ID', -- Age requirements
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL, -- Club category
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments for documentation
COMMENT ON TABLE clubs IS 'Stores nightclub information including location, pricing, and aggregated ratings';
COMMENT ON COLUMN clubs.price_min IS 'Minimum price range for the club (currency in cents)';
COMMENT ON COLUMN clubs.price_max IS 'Maximum price range for the club (currency in cents)';
COMMENT ON COLUMN clubs.avg_rating IS 'Denormalized average rating (1-5 scale)';
COMMENT ON COLUMN clubs.review_count IS 'Denormalized total number of reviews';
COMMENT ON COLUMN clubs.opening_hours IS 'JSON object with daily opening hours';

-- Indexes for clubs table
CREATE INDEX idx_clubs_location ON clubs USING btree(location);
CREATE INDEX idx_clubs_avg_rating ON clubs USING btree(avg_rating DESC);
CREATE INDEX idx_clubs_price_range ON clubs USING btree(price_min, price_max);
CREATE INDEX idx_clubs_active ON clubs USING btree(is_active) WHERE is_active = true;
CREATE INDEX idx_clubs_category_id ON clubs USING btree(category_id);

-- =============================================================================
-- REVIEWS TABLE
-- =============================================================================
-- User reviews and ratings for clubs
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    is_verified BOOLEAN DEFAULT false, -- For verified bookings
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Prevent duplicate reviews per user per club
    CONSTRAINT unique_user_club_review UNIQUE(user_id, club_id)
);

-- Add comments
COMMENT ON TABLE reviews IS 'User reviews and ratings for nightclubs';
COMMENT ON COLUMN reviews.rating IS 'Rating from 1 to 5 stars';
COMMENT ON COLUMN reviews.is_verified IS 'True if review is from a verified booking';

-- Indexes for reviews table
CREATE INDEX idx_reviews_club_id ON reviews USING btree(club_id);
CREATE INDEX idx_reviews_user_id ON reviews USING btree(user_id);
CREATE INDEX idx_reviews_rating ON reviews USING btree(rating);
CREATE INDEX idx_reviews_created_at ON reviews USING btree(created_at DESC);

-- =============================================================================
-- BOTTLES TABLE
-- =============================================================================
-- Beverage menu for each club (wines, beers, spirits)
CREATE TABLE bottles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('wine', 'beer', 'spirits', 'champagne', 'cocktail', 'non_alcoholic')),
    subcategory VARCHAR(100), -- e.g., 'red_wine', 'whiskey', 'vodka'
    brand VARCHAR(255),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    volume_ml INTEGER CHECK (volume_ml > 0),
    alcohol_content DECIMAL(4,2) CHECK (alcohol_content >= 0 AND alcohol_content <= 100),
    description TEXT,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false, -- For highlighting special bottles
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add comments
COMMENT ON TABLE bottles IS 'Beverage menu items available at each nightclub';
COMMENT ON COLUMN bottles.category IS 'Main beverage category (wine, beer, spirits, etc.)';
COMMENT ON COLUMN bottles.subcategory IS 'More specific category within main category';
COMMENT ON COLUMN bottles.volume_ml IS 'Volume in milliliters';
COMMENT ON COLUMN bottles.alcohol_content IS 'Alcohol by volume percentage';

-- Indexes for bottles table
CREATE INDEX idx_bottles_club_id ON bottles USING btree(club_id);
CREATE INDEX idx_bottles_category ON bottles USING btree(category);
CREATE INDEX idx_bottles_price ON bottles USING btree(price);
CREATE INDEX idx_bottles_available ON bottles USING btree(is_available) WHERE is_available = true;
CREATE INDEX idx_bottles_featured ON bottles USING btree(is_featured) WHERE is_featured = true;

-- =============================================================================
-- CLUB TABLES TABLE
-- =============================================================================
-- Physical tables/seating areas available for booking at each club
CREATE TABLE club_tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, -- e.g., "Table A1", "VIP Booth 3"
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    is_vip BOOLEAN DEFAULT false,
    location_description TEXT, -- e.g., "Near the DJ booth", "By the bar"
    minimum_spend DECIMAL(10,2) CHECK (minimum_spend >= 0),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure unique table names within each club
    CONSTRAINT unique_club_table_name UNIQUE(club_id, name)
);

-- Add comments
COMMENT ON TABLE club_tables IS 'Physical tables and seating areas available for booking';
COMMENT ON COLUMN club_tables.capacity IS 'Maximum number of guests for this table';
COMMENT ON COLUMN club_tables.price IS 'Base booking price for this table';
COMMENT ON COLUMN club_tables.minimum_spend IS 'Minimum spend requirement for this table';

-- Indexes for club_tables table
CREATE INDEX idx_club_tables_club_id ON club_tables USING btree(club_id);
CREATE INDEX idx_club_tables_capacity ON club_tables USING btree(capacity);
CREATE INDEX idx_club_tables_price ON club_tables USING btree(price);
CREATE INDEX idx_club_tables_vip ON club_tables USING btree(is_vip) WHERE is_vip = true;
CREATE INDEX idx_club_tables_active ON club_tables USING btree(is_active) WHERE is_active = true;

-- =============================================================================
-- TABLE BOOKINGS TABLE
-- =============================================================================
-- Customer table reservations with availability constraints
CREATE TABLE table_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    table_id UUID NOT NULL REFERENCES club_tables(id) ON DELETE CASCADE,
    guest_count INTEGER NOT NULL CHECK (guest_count > 0),
    booking_date DATE NOT NULL,
    time_slot VARCHAR(20) NOT NULL, -- e.g., "20:00-23:00", "21:30-01:30"
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed', 'no_show')),
    total_price DECIMAL(10,2) NOT NULL CHECK (total_price >= 0),
    special_requests TEXT,
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    confirmation_code VARCHAR(20) UNIQUE, -- For booking reference
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Prevent overlapping bookings for the same table and time slot
    CONSTRAINT unique_table_booking_slot UNIQUE(table_id, booking_date, time_slot)
);

-- Add comments
COMMENT ON TABLE table_bookings IS 'Customer table reservations and booking management';
COMMENT ON COLUMN table_bookings.time_slot IS 'Time range for the booking (e.g., "20:00-23:00")';
COMMENT ON COLUMN table_bookings.status IS 'Booking status workflow';
COMMENT ON COLUMN table_bookings.confirmation_code IS 'Unique code for booking reference';

-- Indexes for table_bookings table
CREATE INDEX idx_table_bookings_user_id ON table_bookings USING btree(user_id);
CREATE INDEX idx_table_bookings_table_date ON table_bookings USING btree(table_id, booking_date);
CREATE INDEX idx_table_bookings_status ON table_bookings USING btree(status);
CREATE INDEX idx_table_bookings_date ON table_bookings USING btree(booking_date);
CREATE INDEX idx_table_bookings_created_at ON table_bookings USING btree(created_at DESC);

-- =============================================================================
-- ADDITIONAL HELPER TABLES
-- =============================================================================

-- Club amenities/features table
CREATE TABLE club_amenities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, -- e.g., "Outdoor Terrace", "Live DJ", "Valet Parking"
    icon VARCHAR(50), -- Icon identifier for mobile app
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_club_amenities_club_id ON club_amenities USING btree(club_id);

-- Club operating hours table (alternative to JSON in clubs table)
CREATE TABLE club_hours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    club_id UUID NOT NULL REFERENCES clubs(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday, 6=Saturday
    open_time TIME,
    close_time TIME,
    is_closed BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    CONSTRAINT unique_club_day UNIQUE(club_id, day_of_week)
);

CREATE INDEX idx_club_hours_club_id ON club_hours USING btree(club_id);

-- =============================================================================
-- TRIGGERS FOR MAINTAINING DENORMALIZED DATA
-- =============================================================================

-- Function to update club rating statistics
CREATE OR REPLACE FUNCTION update_club_rating_stats()
RETURNS TRIGGER AS $$
BEGIN
    -- Update avg_rating and review_count for the affected club
    UPDATE clubs 
    SET 
        avg_rating = (
            SELECT COALESCE(AVG(rating), 0) 
            FROM reviews 
            WHERE club_id = COALESCE(NEW.club_id, OLD.club_id)
        ),
        review_count = (
            SELECT COUNT(*) 
            FROM reviews 
            WHERE club_id = COALESCE(NEW.club_id, OLD.club_id)
        ),
        updated_at = NOW()
    WHERE id = COALESCE(NEW.club_id, OLD.club_id);
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Triggers to maintain rating statistics
CREATE TRIGGER trigger_update_club_rating_on_insert
    AFTER INSERT ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_club_rating_stats();

CREATE TRIGGER trigger_update_club_rating_on_update
    AFTER UPDATE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_club_rating_stats();

CREATE TRIGGER trigger_update_club_rating_on_delete
    AFTER DELETE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_club_rating_stats();

-- Function to generate booking confirmation codes
CREATE OR REPLACE FUNCTION generate_confirmation_code()
RETURNS TRIGGER AS $$
BEGIN
    NEW.confirmation_code = UPPER(SUBSTRING(MD5(RANDOM()::TEXT) FROM 1 FOR 8));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate confirmation codes
CREATE TRIGGER trigger_generate_confirmation_code
    BEFORE INSERT ON table_bookings
    FOR EACH ROW
    EXECUTE FUNCTION generate_confirmation_code();

-- =============================================================================
-- USEFUL VIEWS FOR COMMON QUERIES
-- =============================================================================

-- View for club listings with complete information
CREATE VIEW club_listings AS
SELECT 
    c.*,
    json_agg(
        json_build_object(
            'name', ca.name,
            'icon', ca.icon
        )
    ) FILTER (WHERE ca.id IS NOT NULL) as amenities
FROM clubs c
LEFT JOIN club_amenities ca ON c.id = ca.club_id
WHERE c.is_active = true
GROUP BY c.id;

-- View for clubs with category information (used by mobile app)
CREATE VIEW clubs_with_categories AS
SELECT 
    c.*,
    cat.name as category_name,
    cat.icon as category_icon,
    cat.color as category_color
FROM clubs c
LEFT JOIN categories cat ON c.category_id = cat.id
WHERE c.is_active = true;

-- View for available tables on a specific date
CREATE OR REPLACE FUNCTION get_available_tables(
    p_club_id UUID,
    p_date DATE,
    p_time_slot VARCHAR(20)
) RETURNS TABLE (
    table_id UUID,
    table_name VARCHAR(100),
    capacity INTEGER,
    price DECIMAL(10,2),
    is_vip BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ct.id,
        ct.name,
        ct.capacity,
        ct.price,
        ct.is_vip
    FROM club_tables ct
    WHERE ct.club_id = p_club_id 
        AND ct.is_active = true
        AND NOT EXISTS (
            SELECT 1 
            FROM table_bookings tb 
            WHERE tb.table_id = ct.id 
                AND tb.booking_date = p_date 
                AND tb.time_slot = p_time_slot 
                AND tb.status IN ('confirmed', 'pending')
        );
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
<<<<<<< HEAD
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
=======
>>>>>>> c4d0068626585d816becf7d06e1e3e7550ab80de
ALTER TABLE clubs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE bottles ENABLE ROW LEVEL SECURITY;
ALTER TABLE club_tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE table_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE club_amenities ENABLE ROW LEVEL SECURITY;
ALTER TABLE club_hours ENABLE ROW LEVEL SECURITY;

-- Public read access for clubs and related data
CREATE POLICY "Public read access for categories" ON categories FOR SELECT USING (is_active = true);
CREATE POLICY "Public read access for clubs" ON clubs FOR SELECT USING (is_active = true);
CREATE POLICY "Public read access for bottles" ON bottles FOR SELECT USING (is_available = true);
CREATE POLICY "Public read access for club_tables" ON club_tables FOR SELECT USING (is_active = true);
CREATE POLICY "Public read access for reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Public read access for amenities" ON club_amenities FOR SELECT USING (true);
CREATE POLICY "Public read access for hours" ON club_hours FOR SELECT USING (true);

<<<<<<< HEAD
-- User access policies for profiles
CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can delete their own profile" ON profiles FOR DELETE USING (auth.uid() = id);

=======
>>>>>>> c4d0068626585d816becf7d06e1e3e7550ab80de
-- User access policies for reviews
CREATE POLICY "Users can insert their own reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own reviews" ON reviews FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own reviews" ON reviews FOR DELETE USING (auth.uid() = user_id);

-- User access policies for bookings
CREATE POLICY "Users can insert their own bookings" ON table_bookings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can view their own bookings" ON table_bookings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update their own bookings" ON table_bookings FOR UPDATE USING (auth.uid() = user_id);

-- =============================================================================
-- SAMPLE DATA INSERTION (OPTIONAL)
-- =============================================================================
/*
-- Sample categories
INSERT INTO categories (name, icon, description, color) VALUES
('Rooftop', 'rooftop', 'Outdoor rooftop bars with skyline views', '#FF6B00'),
('Underground', 'underground', 'Underground clubs with electronic music', '#8B5CF6'),
('Lounge', 'lounge', 'Sophisticated lounge bars', '#F59E0B'),
('Sports Bar', 'sports', 'Sports bars with live games', '#10B981'),
('Dance Club', 'dance', 'High-energy dance clubs', '#EF4444'),
('Jazz Club', 'jazz', 'Intimate jazz venues', '#6366F1'),
('Cocktail Bar', 'cocktail', 'Craft cocktail specialists', '#EC4899'),
('Wine Bar', 'wine', 'Wine-focused establishments', '#84CC16');

-- Sample clubs with categories
INSERT INTO clubs (name, location, description, price_min, price_max, avg_rating, image_url, phone, email, category_id) VALUES
('Sky Lounge NYC', '123 Downtown Ave, New York, NY', 'Premier rooftop experience with world-class DJs and stunning city views', 5000, 15000, 4.8, 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&h=600&fit=crop', '+1-555-0123', 'info@skyloungeqnyc.com', (SELECT id FROM categories WHERE name = 'Rooftop')),
('The Underground', '456 Basement St, New York, NY', 'Deep house and techno in an intimate underground setting', 3000, 8000, 4.5, 'https://images.unsplash.com/photo-1516997121675-4c2d1684aa3e?w=800&h=600&fit=crop', '+1-555-0124', 'info@theunderground.com', (SELECT id FROM categories WHERE name = 'Underground')),
('Velvet Lounge', '789 Uptown Blvd, New York, NY', 'Sophisticated cocktails and smooth jazz', 4000, 12000, 4.6, 'https://images.unsplash.com/photo-1566417713940-fe7c737a9ef2?w=800&h=600&fit=crop', '+1-555-0125', 'info@velvetlounge.com', (SELECT id FROM categories WHERE name = 'Lounge')),
('Sports Central', '321 Game Ave, New York, NY', 'Watch the game while enjoying craft beers and wings', 2000, 6000, 4.2, 'https://images.unsplash.com/photo-1544961503-7ad5ac882d5d?w=800&h=600&fit=crop', '+1-555-0126', 'info@sportscentral.com', (SELECT id FROM categories WHERE name = 'Sports Bar')),
('Electric Nights', '555 Dance St, New York, NY', 'High-energy dance floor with top DJs every night', 6000, 20000, 4.9, 'https://images.unsplash.com/photo-1571266028243-4f824f74043c?w=800&h=600&fit=crop', '+1-555-0127', 'info@electricnights.com', (SELECT id FROM categories WHERE name = 'Dance Club')),
('Blue Note', '888 Jazz Rd, New York, NY', 'Intimate jazz performances in a classic setting', 3500, 9000, 4.4, 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=600&fit=crop', '+1-555-0128', 'info@bluenote.com', (SELECT id FROM categories WHERE name = 'Jazz Club')),
('Mixology Lab', '999 Craft Ave, New York, NY', 'Innovative cocktails by award-winning mixologists', 4500, 11000, 4.7, 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=800&h=600&fit=crop', '+1-555-0129', 'info@mixologylab.com', (SELECT id FROM categories WHERE name = 'Cocktail Bar')),
('Vintage Vines', '111 Wine St, New York, NY', 'Extensive wine selection with sommelier pairings', 3000, 10000, 4.3, 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=600&fit=crop', '+1-555-0130', 'info@vintagevines.com', (SELECT id FROM categories WHERE name = 'Wine Bar'));

-- Sample amenities for clubs
INSERT INTO club_amenities (club_id, name, icon) 
SELECT c.id, unnest(ARRAY['VIP Lounge', 'Outdoor Terrace', 'Live DJ', 'Valet Parking', 'Bottle Service']), 
       unnest(ARRAY['vip', 'outdoor', 'music', 'parking', 'bottle'])
FROM clubs c WHERE c.name = 'Sky Lounge NYC';

INSERT INTO club_amenities (club_id, name, icon) 
SELECT c.id, unnest(ARRAY['Sound System', 'Dance Floor', 'Coat Check', 'VIP Tables']), 
       unnest(ARRAY['sound', 'dance', 'coat', 'vip'])
FROM clubs c WHERE c.name = 'The Underground';

-- Sample operating hours (Most clubs open late)
INSERT INTO club_hours (club_id, day_of_week, open_time, close_time)
SELECT c.id, generate_series(0, 6), '20:00'::TIME, '03:00'::TIME
FROM clubs c WHERE c.name IN ('Sky Lounge NYC', 'The Underground', 'Electric Nights');

-- Sample reviews
INSERT INTO reviews (user_id, club_id, rating, comment, is_verified) VALUES
((SELECT id FROM auth.users LIMIT 1), (SELECT id FROM clubs WHERE name = 'Sky Lounge NYC'), 5, 'Amazing views and great service!', true),
((SELECT id FROM auth.users LIMIT 1), (SELECT id FROM clubs WHERE name = 'The Underground'), 4, 'Great music but a bit crowded', false);

-- Sample tables
INSERT INTO club_tables (club_id, name, capacity, price, is_vip, location_description, minimum_spend) VALUES
((SELECT id FROM clubs WHERE name = 'Sky Lounge NYC'), 'Table A1', 6, 50000, true, 'Premium view of the city', 100000),
((SELECT id FROM clubs WHERE name = 'Sky Lounge NYC'), 'Table B2', 4, 30000, false, 'Near the bar', 60000),
((SELECT id FROM clubs WHERE name = 'The Underground'), 'Booth 1', 8, 40000, true, 'VIP section near DJ', 80000);

-- Sample bottles
INSERT INTO bottles (club_id, name, category, subcategory, brand, price, volume_ml, alcohol_content, description, is_featured) VALUES
((SELECT id FROM clubs WHERE name = 'Sky Lounge NYC'), 'Dom Pérignon Vintage', 'champagne', 'vintage_champagne', 'Dom Pérignon', 75000, 750, 12.5, 'Prestigious champagne for special occasions', true),
((SELECT id FROM clubs WHERE name = 'Sky Lounge NYC'), 'Grey Goose Vodka', 'spirits', 'vodka', 'Grey Goose', 45000, 750, 40.0, 'Premium French vodka', false),
((SELECT id FROM clubs WHERE name = 'The Underground'), 'Hennessy XO', 'spirits', 'cognac', 'Hennessy', 85000, 700, 40.0, 'Exceptional cognac aged to perfection', true);
*/

-- =============================================================================
-- SCHEMA CREATION COMPLETE
-- =============================================================================

<<<<<<< HEAD
COMMENT ON SCHEMA public IS 'Nightclub booking app schema with clubs, reviews, bottles, tables, and bookings';
=======
COMMENT ON SCHEMA public IS 'Nightclub booking app schema with clubs, reviews, bottles, tables, and bookings'; 
>>>>>>> c4d0068626585d816becf7d06e1e3e7550ab80de
