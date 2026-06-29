import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://iyvikdxzcpcjivmbiwik.supabase.co';
const supabaseKey = 'sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2';
const supabase = createClient(supabaseUrl, supabaseKey);

async function testGoogle() {
  console.log("Testing Google Auth...");
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'google'
  });
  console.log("Error:", error);
  console.log("Data:", data);
}

testGoogle();
