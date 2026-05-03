-- =====================================================
-- CURRENT DATABASE SCHEMA INSPECTOR
-- Run this to see your exact database state
-- =====================================================

-- 1. List ALL existing tables
\echo '=============================================='
\echo 'EXISTING TABLES:'
\echo '=============================================='
SELECT 
    schemaname as schema,
    tablename as table_name
FROM pg_tables
WHERE schemaname IN ('public', 'auth')
ORDER BY schemaname, tablename;

-- 2. Get table column details for public schema
\echo ''
\echo '=============================================='
\echo 'PUBLIC SCHEMA COLUMNS:'
\echo '=============================================='
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- 3. List all triggers
\echo ''
\echo '=============================================='
\echo 'EXISTING TRIGGERS:'
\echo '=============================================='
SELECT 
    trigger_name,
    event_object_table as table_name,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- 4. List all indexes
\echo ''
\echo '=============================================='
\echo 'EXISTING INDEXES:'
\echo '=============================================='
SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- 5. Count tables
\echo ''
\echo '=============================================='
\echo 'TABLE COUNT:'
\echo '=============================================='
SELECT COUNT(*) as total_public_tables
FROM pg_tables
WHERE schemaname = 'public';

