import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://iyvikdxzcpcjivmbiwik.supabase.co';
const supabaseKey = 'sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2';
const supabase = createClient(supabaseUrl, supabaseKey);

async function testAuth() {
  console.log("Testing Auth...");
  const { data, error } = await supabase.auth.signInWithPassword({
    email: 'test@example.com',
    password: 'password123'
  });
  console.log("Error:", error);
  console.log("Data:", data);
}

testAuth();
