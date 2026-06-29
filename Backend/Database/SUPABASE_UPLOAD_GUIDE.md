# NobleInvoice Backend: Supabase Upload Guide 🚀

This guide provides a step-by-step walkthrough for deploying the **NobleInvoice** database schema, storage policies, and logic to your Supabase project.

## 📂 Pre-requisites
1.  A **Supabase Account** (https://supabase.com).
2.  A new **Project** created in the Supabase Dashboard.
3.  The **Supabase CLI** installed (optional, but recommended for Edge Functions).

---

## 🏗️ Step 1: Execute SQL Migrations
Go to the **SQL Editor** in your Supabase Dashboard and run the following files in order:

### 1. `nobleinvoice_schema.sql` (Base Schema)
**Action**: Copy-paste contents and click **Run**.
> This creates the core tables: `profiles`, `invoices`, `clients`, `invoice_items`.

### 2. `phase1_migration.sql` (System Setup)
**Action**: Run this next.
> This sets up the automatic profile creation for new Auth users and initial RLS (Row Level Security) policies.

### 3. `expenses_migration_v1.sql` (Expenses & Vendors)
**Action**: Run this for the Expense Management module.
> This creates the `expenses` and `vendors` tables with RLS isolation.

### 4. `inventory_migration_v1.sql` & `link_items_to_inventory.sql`
**Action**: Run both for Inventory features.
> This enables the **Product Catalog**, **Stock Ledger**, and links line items to inventory.

### 5. `phase4_storage_migration.sql` (Storage Policies)
**Action**: Run this to secure your file uploads.
> This ensures that only owners can upload/view their logos and receipts.

---

## 📦 Step 2: Create Storage Buckets
Go to **Storage** in the Supabase Dashboard and create the following buckets with **Public = No** (Private):

1.  `logos`: For business branding.
2.  `receipts`: For expense management documents.
3.  `avatars`: For user profile pictures.

---

## ⚡ Step 3: Deploy Edge Functions
NobleInvoice uses Supabase Edge Functions for advanced logic. Use the Supabase CLI to deploy them from your local project:

1.  Open your terminal in the project root.
2.  Run the following commands:
    ```bash
    supabase functions deploy invoice-portal
    supabase functions deploy process-invoice-payment
    supabase functions deploy payment-webhook
    supabase functions deploy process-recurring-invoices
    supabase functions deploy send-overdue-reminders
    ```

### 🔑 Important Environment Variables
In the Supabase Dashboard (Settings -> Edge Functions), add the following secrets:
*   `PAYSTACK_SECRET_KEY`: Your live Paystack API Key.
*   `APP_URL`: Your production portal URL.

---

## 🧹 Legacy Cleanup: `go-server`
The `go-server` (Node/Express) was a legacy backend attempt. Because we have fully migrated to **Direct Supabase Integration** (Flutter) and **Supabase Edge Functions** (TypeScript/Deno), the `go-server` folder is **no longer needed**.

**Recommended Action**:
*   You can safely **delete** the legacy `go-server` directory.
*   Ensure you have copied any custom `.env` variables (like specific LLM keys) to your Edge Functions before deleting.

---

**Your NobleInvoice backend is now production-ready!**
