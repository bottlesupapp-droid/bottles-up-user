-- =====================================================
-- SAFE INCREMENTAL MIGRATION
-- Creates only missing tables (won't fail if some exist)
-- =====================================================

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- STEP 1: CREATE BASE TABLES (if they don't exist)
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
-- STEP 2: VERIFY BASE TABLES EXIST
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE 'Base tables created/verified:';
    RAISE NOTICE '  - user_profiles';
    RAISE NOTICE '  - venues';
    RAISE NOTICE '  - events';
    RAISE NOTICE '  - venue_ratings';
    RAISE NOTICE '';
    RAISE NOTICE 'Ready to proceed with feature tables!';
END $$;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

SELECT 
    COUNT(*) FILTER (WHERE table_name = 'user_profiles') as user_profiles_exists,
    COUNT(*) FILTER (WHERE table_name = 'venues') as venues_exists,
    COUNT(*) FILTER (WHERE table_name = 'events') as events_exists,
    COUNT(*) FILTER (WHERE table_name = 'venue_ratings') as venue_ratings_exists
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('user_profiles', 'venues', 'events', 'venue_ratings');
