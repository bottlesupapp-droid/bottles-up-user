-- Copy and run this in Supabase Dashboard SQL Editor
-- Then share the complete output with me

SELECT json_build_object(
    'tables', (
        SELECT json_agg(tablename ORDER BY tablename)
        FROM pg_tables 
        WHERE schemaname = 'public'
    ),
    'triggers', (
        SELECT json_agg(json_build_object(
            'name', trigger_name,
            'table', event_object_table
        ) ORDER BY trigger_name)
        FROM information_schema.triggers
        WHERE trigger_schema = 'public'
    ),
    'table_count', (
        SELECT COUNT(*)
        FROM pg_tables 
        WHERE schemaname = 'public'
    ),
    'columns', (
        SELECT json_agg(json_build_object(
            'table', table_name,
            'column', column_name,
            'type', data_type
        ) ORDER BY table_name, ordinal_position)
        FROM information_schema.columns
        WHERE table_schema = 'public'
    )
) as database_state;
