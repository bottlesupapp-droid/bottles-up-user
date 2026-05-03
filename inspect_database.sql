-- =====================================================
-- INSPECT CURRENT SUPABASE DATABASE
-- =====================================================
-- Run this in Supabase SQL Editor to see what exists
-- =====================================================

-- 1. List all public tables
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- 2. Count total tables
SELECT COUNT(*) as total_public_tables
FROM pg_tables
WHERE schemaname = 'public';

-- 3. List all columns for each table (detailed)
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 4. Check if specific base tables exist
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'venues') 
        THEN 'EXISTS' 
        ELSE 'MISSING' 
    END as venues_table,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'events') 
        THEN 'EXISTS' 
        ELSE 'MISSING' 
    END as events_table,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'user_profiles') 
        THEN 'EXISTS' 
        ELSE 'MISSING' 
    END as user_profiles_table,
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'users') 
        THEN 'EXISTS' 
        ELSE 'MISSING' 
    END as users_table;

-- 5. Check auth schema (Supabase auth)
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'auth' AND tablename = 'users') 
        THEN 'EXISTS' 
        ELSE 'MISSING' 
    END as auth_users_table;
