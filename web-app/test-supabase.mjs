import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://iyvikdxzcpcjivmbiwik.supabase.co',
  'sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2'
);

async function test() {
  const { data: invoices, error } = await supabase.from('invoices').select('id, user_id, team_id, client_id, currency_code, total_amount, status').limit(10);
  console.log('Invoices:', invoices, error);
  
  const { data: clients, error: cError } = await supabase.from('clients').select('id, user_id, team_id, name').limit(10);
  console.log('Clients:', clients, cError);
}

test();
