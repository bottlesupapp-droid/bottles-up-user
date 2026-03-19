-- =============================================================================
-- PROFILES TABLE MIGRATION
-- =============================================================================
-- This migration adds the missing profiles table that the Apple Sign-In service expects
-- Run this in your Supabase SQL editor to fix the "Database error saving new user" issue

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
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
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles USING btree(email);
CREATE INDEX IF NOT EXISTS idx_profiles_name ON profiles USING btree(name);
CREATE INDEX IF NOT EXISTS idx_profiles_active ON profiles USING btree(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_profiles_created_at ON profiles USING btree(created_at DESC);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view their own profile" ON profiles 
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON profiles 
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON profiles 
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can delete their own profile" ON profiles 
    FOR DELETE USING (auth.uid() = id);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER trigger_update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_profiles_updated_at();

-- Function to create profile automatically when user signs up
CREATE OR REPLACE FUNCTION create_profile_for_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, name, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
        NEW.email
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to create profile when new user is created in auth.users
CREATE TRIGGER trigger_create_profile_on_signup
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION create_profile_for_new_user();

-- =============================================================================
-- MIGRATION COMPLETE
-- =============================================================================

-- Verify the table was created successfully
SELECT 'Profiles table created successfully!' as status;