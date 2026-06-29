
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = "https://iyvikdxzcpcjivmbiwik.supabase.co";
const supabaseAnonKey = "sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2";

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function testConnection() {
    console.log('Testing Supabase connection...');
    
    try {
        const { data: tables, error } = await supabase
            .from('profiles')
            .select('count', { count: 'exact', head: true });
        
        if (error) {
            console.error('Profiles table error:', error);
        } else {
            console.log('Profiles table exists. Count:', tables);
        }

        const { data: teams, error: teamsError } = await supabase
            .from('teams')
            .select('count', { count: 'exact', head: true });
            
        if (teamsError) {
            console.error('Teams table error:', teamsError);
        } else {
            console.log('Teams table exists.');
        }

        const { data: clients, error: clientsError } = await supabase
            .from('clients')
            .select('count', { count: 'exact', head: true });
            
        if (clientsError) {
            console.error('Clients table error:', clientsError);
        } else {
            console.log('Clients table exists.');
        }

        const { data: products, error: productsError } = await supabase
            .from('products')
            .select('count', { count: 'exact', head: true });
            
        if (productsError) {
            console.error('Products table error:', productsError);
        } else {
            console.log('Products table exists.');
        }
    } catch (err) {
        console.error('Unexpected error:', err);
    }
}

testConnection();
