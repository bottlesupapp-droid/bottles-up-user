-- =====================================================
-- SAFE MIGRATION - Handles Existing Objects
-- =====================================================
-- This migration safely creates tables and objects
-- without failing if they already exist
-- =====================================================

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- STEP 1: CREATE BASE TABLES (IF NOT EXISTS)
-- =====================================================

-- User profiles (extends auth.users)
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name VARCHAR(255),
    avatar_url TEXT,
    phone VARCHAR(20),
    date_of_birth DATE,
    bio TEXT,
    location JSONB,
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Venues
CREATE TABLE IF NOT EXISTS venues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    phone VARCHAR(20),
    email VARCHAR(255),
    website TEXT,
    logo_url TEXT,
    cover_image TEXT,
    images TEXT[] DEFAULT '{}',
    category VARCHAR(100),
    subcategory VARCHAR(100),
    price_range VARCHAR(10),
    rating DECIMAL(3,2) DEFAULT 0,
    total_ratings INT DEFAULT 0,
    capacity INT,
    amenities JSONB DEFAULT '[]',
    opening_hours JSONB,
    dress_code VARCHAR(100),
    music_type VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Events
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID REFERENCES venues(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    cover_image TEXT,
    images TEXT[] DEFAULT '{}',
    category VARCHAR(100),
    ticket_price DECIMAL(10,2),
    vip_price DECIMAL(10,2),
    early_bird_price DECIMAL(10,2),
    capacity INT,
    tickets_sold INT DEFAULT 0,
    min_age INT DEFAULT 18,
    dress_code VARCHAR(100),
    lineup JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Venue ratings
CREATE TABLE IF NOT EXISTS venue_ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    rating DECIMAL(3,2) NOT NULL CHECK (rating >= 0 AND rating <= 5),
    review TEXT,
    photos TEXT[] DEFAULT '{}',
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(venue_id, user_id)
);

-- =====================================================
-- STEP 2: CREATE TRIGGERS (DROP FIRST IF EXISTS)
-- =====================================================

-- Update venue rating function
CREATE OR REPLACE FUNCTION update_venue_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE venues
    SET 
        rating = (SELECT AVG(rating) FROM venue_ratings WHERE venue_id = NEW.venue_id),
        total_ratings = (SELECT COUNT(*) FROM venue_ratings WHERE venue_id = NEW.venue_id)
    WHERE id = NEW.venue_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists, then create
DROP TRIGGER IF EXISTS venue_rating_updated ON venue_ratings;
CREATE TRIGGER venue_rating_updated
AFTER INSERT OR UPDATE OR DELETE ON venue_ratings
FOR EACH ROW EXECUTE FUNCTION update_venue_rating();

-- Generic updated_at function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for tables with updated_at (drop first if exists)
DO $$ 
BEGIN
    -- Venues
    DROP TRIGGER IF EXISTS trigger_venues_updated_at ON venues;
    CREATE TRIGGER trigger_venues_updated_at
        BEFORE UPDATE ON venues
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- Events
    DROP TRIGGER IF EXISTS trigger_events_updated_at ON events;
    CREATE TRIGGER trigger_events_updated_at
        BEFORE UPDATE ON events
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- User profiles
    DROP TRIGGER IF EXISTS trigger_user_profiles_updated_at ON user_profiles;
    CREATE TRIGGER trigger_user_profiles_updated_at
        BEFORE UPDATE ON user_profiles
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    
    -- Venue ratings
    DROP TRIGGER IF EXISTS trigger_venue_ratings_updated_at ON venue_ratings;
    CREATE TRIGGER trigger_venue_ratings_updated_at
        BEFORE UPDATE ON venue_ratings
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
        
    RAISE NOTICE 'Base triggers created successfully';
EXCEPTION
    WHEN undefined_table THEN
        RAISE NOTICE 'Some tables do not exist yet, skipping their triggers';
END $$;

-- =====================================================
-- STEP 3: VERIFICATION
-- =====================================================

DO $$
DECLARE
    table_count INT;
BEGIN
    SELECT COUNT(*) INTO table_count
    FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_name IN ('user_profiles', 'venues', 'events', 'venue_ratings');
    
    RAISE NOTICE '';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Base Tables Migration Complete!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Tables created: %', table_count;
    RAISE NOTICE '';
    RAISE NOTICE 'Created tables:';
    RAISE NOTICE '  - user_profiles';
    RAISE NOTICE '  - venues';
    RAISE NOTICE '  - events';
    RAISE NOTICE '  - venue_ratings';
    RAISE NOTICE '';
    RAISE NOTICE 'Ready for feature tables migration!';
    RAISE NOTICE '==============================================';
END $$;

-- Show results
SELECT 
    table_name,
    CASE 
        WHEN table_name IN (
            SELECT tablename FROM pg_tables WHERE schemaname = 'public'
        ) THEN 'EXISTS'
        ELSE 'MISSING'
    END as status
FROM (
    VALUES 
        ('user_profiles'),
        ('venues'),
        ('events'),
        ('venue_ratings')
) AS t(table_name)
ORDER BY table_name;
