-- =====================================================
-- COMPLETE SAFE MIGRATION
-- Handles all existing objects gracefully
-- =====================================================

SET client_min_messages TO WARNING;

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Generic updated_at function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- BASE TABLES
-- =====================================================

-- User profiles
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
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add unique constraint if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'venue_ratings_venue_id_user_id_key'
    ) THEN
        ALTER TABLE venue_ratings ADD CONSTRAINT venue_ratings_venue_id_user_id_key UNIQUE(venue_id, user_id);
    END IF;
END $$;

-- =====================================================
-- BATCH 8: BOOKINGS & TABLE MANAGEMENT
-- =====================================================

CREATE TABLE IF NOT EXISTS tables (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    table_number VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    min_capacity INT DEFAULT 1,
    location VARCHAR(100),
    is_vip BOOLEAN DEFAULT FALSE,
    base_price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'available',
    features JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS table_bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    table_id UUID REFERENCES tables(id) ON DELETE SET NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    party_size INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    special_requests TEXT,
    deposit_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    is_vip BOOLEAN DEFAULT FALSE,
    confirmation_code VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Continue with remaining tables...
-- (I'll create the complete file next)

SET client_min_messages TO NOTICE;

RAISE NOTICE 'Migration started - creating tables safely...';
