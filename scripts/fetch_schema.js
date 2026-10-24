const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://hwmynlghrmtoufyrcihp.supabase.co';
const supabaseKey = 'sbp_8eb13a655be8e8b374b1911e5c91300f524ea2cc';

const supabase = createClient(supabaseUrl, supabaseKey);

async function fetchSchema() {
    try {
        console.log('Fetching existing Supabase schema...\n');
        
        // Use raw SQL query to get table information
        const { data, error } = await supabase.rpc('exec_sql', {
            query: `
                SELECT 
                    table_name,
                    column_name,
                    data_type,
                    is_nullable,
                    column_default
                FROM information_schema.columns
                WHERE table_schema = 'public'
                ORDER BY table_name, ordinal_position;
            `
        });

        if (error) {
            console.error('Error:', error.message);
            console.log('\nNote: exec_sql RPC might not exist. Using alternative method...\n');
            
            // Alternative: Query public tables directly
            const tablesQuery = `
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public'
                ORDER BY table_name;
            `;
            
            console.log('Attempting to query tables list...');
        } else {
            console.log('Schema data:', JSON.stringify(data, null, 2));
        }
        
    } catch (err) {
        console.error('Fetch error:', err.message);
    }
}

fetchSchema();
