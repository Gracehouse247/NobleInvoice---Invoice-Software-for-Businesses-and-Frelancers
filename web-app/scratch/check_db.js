const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://iyvikdxzcpcjivmbiwik.supabase.co';
const supabaseKey = 'sb_publishable_P7Cqz0FeBivOCQAtMVHd7A_CwRzIyN2';

console.log('Connecting to Supabase URL:', supabaseUrl);

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkDatabase() {
  try {
    // 1. Check if we can list the invoices table
    console.log('Checking "invoices" table...');
    const { data: invoices, error: invError } = await supabase
      .from('invoices')
      .select('*')
      .limit(1);
    
    if (invError) {
      console.log('Error querying invoices:', invError);
    } else {
      console.log('Success querying invoices, found records count:', invoices.length);
    }

    // 2. Check table schema by querying columns or other core tables
    const tables = ['invoices', 'invoice_items', 'clients', 'products', 'product_categories', 'expenses', 'vendors', 'stock_ledger', 'wallet_transactions'];
    for (const t of tables) {
      const { data, error } = await supabase.from(t).select('*').limit(1);
      if (error) {
        console.log(`Table "${t}": NOT AVAILABLE / ERROR:`, error.message);
      } else {
        console.log(`Table "${t}": AVAILABLE (records count: ${data.length})`);
      }
    }

    // 3. Check storage buckets
    console.log('Checking storage buckets...');
    const { data: buckets, error: bucketError } = await supabase.storage.listBuckets();
    if (bucketError) {
      console.log('Error listing buckets:', bucketError);
    } else {
      console.log('Available buckets:', buckets.map(b => b.name));
    }
  } catch (err) {
    console.error('Unhandled script error:', err);
  }
}

checkDatabase();
