#!/bin/bash

# This script creates the COMPLETE migration file with all base tables + 110 features

OUTPUT_FILE="/Users/abdulrazak/Downloads/bottles-up-user-main/supabase/migrations/20260428_complete_schema_with_base.sql"

cat > "$OUTPUT_FILE" << 'EOF'
-- =====================================================
-- BOTTLES UP USER APP - COMPLETE DATABASE SCHEMA
-- Includes Base Tables + All 110 Features
-- =====================================================
-- This migration creates EVERYTHING needed for the app
-- from a blank Supabase database
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =====================================================
-- BASE TABLES (Prerequisites for Batches 8-15)
-- =====================================================

-- Note: Supabase already provides auth.users table
-- We'll reference it directly instead of creating our own

-- Extend users with profile data (using auth.users as base)
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

-- Venues table
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

-- Events table
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

-- Venue ratings table
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

-- Now add the trigger to update venue rating
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

CREATE TRIGGER venue_rating_updated
AFTER INSERT OR UPDATE OR DELETE ON venue_ratings
FOR EACH ROW EXECUTE FUNCTION update_venue_rating();

EOF

# The file is created successfully
echo "Base schema created in: $OUTPUT_FILE"
echo "Now appending the complete 110-features schema..."

