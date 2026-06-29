import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';

const envFile = fs.readFileSync('.env.local', 'utf8');
const env = {};
envFile.split('\n').forEach(line => {
    if (line.includes('=')) {
        const [key, ...rest] = line.split('=');
        env[key.trim()] = rest.join('=').trim();
    }
});

const supabaseUrl = env['NEXT_PUBLIC_SUPABASE_URL'];
const supabaseKey = env['NEXT_PUBLIC_SUPABASE_ANON_KEY'];
const supabase = createClient(supabaseUrl, supabaseKey);

async function checkAdmin() {
    const { data: users, error } = await supabase
        .from('profiles')
        .select('*');

    if (error) {
        console.error('Error fetching users:', error);
        return;
    }

    const admin = users.find(u => u.display_name === 'jefferyonaction@gmail.com' || u.business_email === 'jefferyonaction@gmail.com' || (u.email && u.email === 'jefferyonaction@gmail.com'));
    if (admin) {
        console.log('Admin found:', admin);
    } else {
        console.log('Admin user not found. All users:', users.map(u => ({ id: u.id, display_name: u.display_name, subscription_tier: u.subscription_tier })));
    }
}

checkAdmin();
