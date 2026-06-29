create type "public"."sub_tier" as enum ('solo', 'pro', 'squad');

create sequence "public"."client_communication_logs_id_seq";

create sequence "public"."webhook_logs_id_seq";

drop trigger if exists "set_clients_updated_at" on "public"."clients";

drop trigger if exists "set_invoices_updated_at" on "public"."invoices";

drop trigger if exists "set_products_updated_at" on "public"."products";

drop trigger if exists "set_profiles_updated_at" on "public"."profiles";

drop trigger if exists "set_teams_updated_at" on "public"."teams";

drop policy "Team client access" on "public"."clients";

drop policy "Team expense access" on "public"."expenses";

drop policy "Users manage own tokens" on "public"."fcm_tokens";

drop policy "Invoice items access" on "public"."invoice_items";

drop policy "Team invoice access" on "public"."invoices";

drop policy "Team product access" on "public"."products";

drop policy "Users manage own profiles" on "public"."profiles";

drop policy "Team recurring access" on "public"."recurring_invoices";

drop policy "Member management" on "public"."team_members";

drop policy "Member visibility" on "public"."team_members";

drop policy "Team management" on "public"."teams";

drop policy "Team visibility" on "public"."teams";

revoke delete on table "public"."clients" from "anon";

revoke insert on table "public"."clients" from "anon";

revoke references on table "public"."clients" from "anon";

revoke trigger on table "public"."clients" from "anon";

revoke truncate on table "public"."clients" from "anon";

revoke update on table "public"."clients" from "anon";

revoke delete on table "public"."expenses" from "anon";

revoke insert on table "public"."expenses" from "anon";

revoke references on table "public"."expenses" from "anon";

revoke trigger on table "public"."expenses" from "anon";

revoke truncate on table "public"."expenses" from "anon";

revoke update on table "public"."expenses" from "anon";

revoke delete on table "public"."fcm_tokens" from "anon";

revoke insert on table "public"."fcm_tokens" from "anon";

revoke references on table "public"."fcm_tokens" from "anon";

revoke trigger on table "public"."fcm_tokens" from "anon";

revoke truncate on table "public"."fcm_tokens" from "anon";

revoke update on table "public"."fcm_tokens" from "anon";

revoke delete on table "public"."invoice_items" from "anon";

revoke insert on table "public"."invoice_items" from "anon";

revoke references on table "public"."invoice_items" from "anon";

revoke trigger on table "public"."invoice_items" from "anon";

revoke truncate on table "public"."invoice_items" from "anon";

revoke update on table "public"."invoice_items" from "anon";

revoke delete on table "public"."invoices" from "anon";

revoke insert on table "public"."invoices" from "anon";

revoke references on table "public"."invoices" from "anon";

revoke trigger on table "public"."invoices" from "anon";

revoke truncate on table "public"."invoices" from "anon";

revoke update on table "public"."invoices" from "anon";

revoke delete on table "public"."product_categories" from "anon";

revoke insert on table "public"."product_categories" from "anon";

revoke references on table "public"."product_categories" from "anon";

revoke trigger on table "public"."product_categories" from "anon";

revoke truncate on table "public"."product_categories" from "anon";

revoke update on table "public"."product_categories" from "anon";

revoke delete on table "public"."products" from "anon";

revoke insert on table "public"."products" from "anon";

revoke references on table "public"."products" from "anon";

revoke trigger on table "public"."products" from "anon";

revoke truncate on table "public"."products" from "anon";

revoke update on table "public"."products" from "anon";

revoke delete on table "public"."profiles" from "anon";

revoke insert on table "public"."profiles" from "anon";

revoke references on table "public"."profiles" from "anon";

revoke trigger on table "public"."profiles" from "anon";

revoke truncate on table "public"."profiles" from "anon";

revoke update on table "public"."profiles" from "anon";

revoke delete on table "public"."recurring_invoices" from "anon";

revoke insert on table "public"."recurring_invoices" from "anon";

revoke references on table "public"."recurring_invoices" from "anon";

revoke trigger on table "public"."recurring_invoices" from "anon";

revoke truncate on table "public"."recurring_invoices" from "anon";

revoke update on table "public"."recurring_invoices" from "anon";

revoke delete on table "public"."stock_ledger" from "anon";

revoke insert on table "public"."stock_ledger" from "anon";

revoke references on table "public"."stock_ledger" from "anon";

revoke trigger on table "public"."stock_ledger" from "anon";

revoke truncate on table "public"."stock_ledger" from "anon";

revoke update on table "public"."stock_ledger" from "anon";

revoke delete on table "public"."team_members" from "anon";

revoke insert on table "public"."team_members" from "anon";

revoke references on table "public"."team_members" from "anon";

revoke trigger on table "public"."team_members" from "anon";

revoke truncate on table "public"."team_members" from "anon";

revoke update on table "public"."team_members" from "anon";

revoke delete on table "public"."teams" from "anon";

revoke insert on table "public"."teams" from "anon";

revoke references on table "public"."teams" from "anon";

revoke trigger on table "public"."teams" from "anon";

revoke truncate on table "public"."teams" from "anon";

revoke update on table "public"."teams" from "anon";

alter table "public"."clients" drop constraint "clients_team_id_fkey";

alter table "public"."expenses" drop constraint "expenses_team_id_fkey";

alter table "public"."fcm_tokens" drop constraint "fcm_tokens_team_id_fkey";

alter table "public"."invoice_items" drop constraint "invoice_items_invoice_id_fkey";

alter table "public"."invoice_items" drop constraint "invoice_items_product_id_fkey";

alter table "public"."invoices" drop constraint "invoices_client_id_fkey";

alter table "public"."invoices" drop constraint "invoices_team_id_fkey";

alter table "public"."product_categories" drop constraint "product_categories_team_id_fkey";

alter table "public"."products" drop constraint "products_category_id_fkey";

alter table "public"."products" drop constraint "products_team_id_fkey";

alter table "public"."recurring_invoices" drop constraint "recurring_invoices_client_id_fkey";

alter table "public"."recurring_invoices" drop constraint "recurring_invoices_team_id_fkey";

alter table "public"."stock_ledger" drop constraint "stock_ledger_product_id_fkey";

alter table "public"."stock_ledger" drop constraint "stock_ledger_team_id_fkey";

alter table "public"."team_members" drop constraint "team_members_team_id_fkey";

alter table "public"."team_members" drop constraint "team_members_user_id_fkey";

alter table "public"."teams" drop constraint "teams_owner_id_fkey";

drop function if exists "public"."check_team_access"(t_id uuid, required_roles team_role[]);

drop function if exists "public"."is_team_owner"(t_id uuid);

drop index if exists "public"."idx_clients_payment_token";

drop index if exists "public"."idx_invoices_status_due_date";


  create table "public"."billing_history" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "amount" numeric(10,2) not null,
    "currency" text not null default 'USD'::text,
    "plan" text not null,
    "billing_period" text,
    "transaction_ref" text,
    "status" text default 'success'::text,
    "created_at" timestamp with time zone default now(),
    "transaction_id" text,
    "verified_at" timestamp with time zone
      );


alter table "public"."billing_history" enable row level security;


  create table "public"."business_cards" (
    "id" uuid not null default gen_random_uuid(),
    "team_id" uuid,
    "format" text default 'standard'::text,
    "template_id" text default 'modern_flat'::text,
    "custom_name" text,
    "custom_title" text,
    "custom_phone" text,
    "custom_email" text,
    "custom_website" text,
    "custom_address" text,
    "qr_data" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."business_cards" enable row level security;


  create table "public"."client_communication_logs" (
    "id" bigint not null default nextval('public.client_communication_logs_id_seq'::regclass),
    "team_id" uuid,
    "client_id" bigint,
    "author_id" uuid,
    "type" text not null,
    "summary" text,
    "logged_at" timestamp with time zone default now()
      );


alter table "public"."client_communication_logs" enable row level security;


  create table "public"."client_documents" (
    "id" bigint generated by default as identity not null,
    "client_id" bigint not null,
    "uploader_id" uuid,
    "name" text not null,
    "file_url" text not null,
    "file_size" bigint,
    "file_type" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."client_documents" enable row level security;


  create table "public"."client_ledger" (
    "id" bigint generated always as identity not null,
    "team_id" uuid,
    "client_id" bigint,
    "invoice_id" bigint,
    "transaction_type" text not null,
    "amount" numeric not null,
    "balance_before" numeric not null,
    "balance_after" numeric not null,
    "created_at" timestamp with time zone default now(),
    "metadata" jsonb default '{}'::jsonb
      );


alter table "public"."client_ledger" enable row level security;


  create table "public"."client_notes" (
    "id" bigint generated by default as identity not null,
    "client_id" bigint not null,
    "author_id" uuid,
    "content" text not null,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "sentiment" character varying(50),
    "sentiment_confidence" numeric(3,2)
      );


alter table "public"."client_notes" enable row level security;


  create table "public"."expense_categories" (
    "id" bigint generated by default as identity not null,
    "user_id" uuid,
    "name" text not null,
    "icon" text,
    "color" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."expense_categories" enable row level security;


  create table "public"."folders" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "name" text not null,
    "icon_name" text,
    "created_at" timestamp with time zone default now(),
    "team_id" uuid
      );


alter table "public"."folders" enable row level security;


  create table "public"."live_chat_messages" (
    "id" bigint generated by default as identity not null,
    "user_id" uuid,
    "message" text not null,
    "is_support" boolean default false,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."live_chat_messages" enable row level security;


  create table "public"."payment_methods" (
    "id" bigint generated by default as identity not null,
    "user_id" uuid,
    "type" text,
    "details" jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."payment_methods" enable row level security;


  create table "public"."pending_invitations" (
    "id" uuid not null default gen_random_uuid(),
    "team_id" uuid not null,
    "email" text not null,
    "role" text not null default 'staff'::text,
    "invited_by" uuid not null,
    "created_at" timestamp with time zone default now(),
    "expires_at" timestamp with time zone not null
      );


alter table "public"."pending_invitations" enable row level security;


  create table "public"."qr_codes" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "folder_id" uuid,
    "name" text not null,
    "type" text not null,
    "content" jsonb not null,
    "color_primary" text default '#2563EB'::text,
    "asset_path" text,
    "asset_url" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "team_id" uuid
      );


alter table "public"."qr_codes" enable row level security;


  create table "public"."qr_scans" (
    "id" bigint generated by default as identity not null,
    "qr_code_id" uuid,
    "scanned_at" timestamp with time zone default now(),
    "device_info" jsonb,
    "location" text
      );


alter table "public"."qr_scans" enable row level security;


  create table "public"."usage_metrics" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "user_id" uuid,
    "month_year" text not null,
    "clients_created" integer default 0,
    "clients_edited" integer default 0,
    "invoices_created" integer default 0,
    "invoices_edited" integer default 0,
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."usage_metrics" enable row level security;


  create table "public"."user_sessions" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "device_name" text,
    "location" text,
    "is_current" boolean default false,
    "device_info" jsonb,
    "last_active" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now()
      );


alter table "public"."user_sessions" enable row level security;


  create table "public"."vendors" (
    "id" bigint generated by default as identity not null,
    "team_id" uuid,
    "user_id" uuid not null,
    "name" text not null,
    "email" text,
    "phone" text,
    "category" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."vendors" enable row level security;


  create table "public"."webhook_logs" (
    "id" bigint not null default nextval('public.webhook_logs_id_seq'::regclass),
    "payload" jsonb,
    "headers" jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."webhook_logs" enable row level security;

alter table "public"."clients" drop column "metadata";

alter table "public"."clients" add column "business_name" text;

alter table "public"."clients" add column "company_name" text;

alter table "public"."clients" add column "current_balance" numeric default 0;

alter table "public"."clients" add column "lead_status" text default 'active'::text;

alter table "public"."clients" add column "position" text;

alter table "public"."clients" add column "user_id" uuid;

alter table "public"."clients" alter column "team_id" drop not null;

alter table "public"."expenses" add column "category_id" bigint;

alter table "public"."expenses" add column "currency_code" text default 'USD'::text;

alter table "public"."expenses" add column "invoice_id" bigint;

alter table "public"."expenses" add column "is_recurring" boolean default false;

alter table "public"."expenses" add column "user_id" uuid;

alter table "public"."expenses" add column "vendor_id" bigint;

alter table "public"."expenses" alter column "amount" set default 0;

alter table "public"."expenses" alter column "expense_date" set default CURRENT_DATE;

alter table "public"."expenses" alter column "team_id" drop not null;

alter table "public"."invoices" drop column "paid_at";

alter table "public"."invoices" add column "gateway_transaction_id" character varying(255);

alter table "public"."invoices" add column "opened_at" timestamp with time zone;

alter table "public"."invoices" add column "payment_gateway" character varying(50);

alter table "public"."invoices" add column "tracking_token" uuid default gen_random_uuid();

alter table "public"."invoices" add column "user_id" uuid;

alter table "public"."invoices" add column "view_count" integer default 0;

alter table "public"."invoices" alter column "currency_code" set default 'USD'::text;

alter table "public"."invoices" alter column "team_id" drop not null;

alter table "public"."product_categories" alter column "team_id" drop not null;

alter table "public"."products" add column "user_id" uuid;

alter table "public"."products" alter column "team_id" drop not null;

alter table "public"."profiles" add column "avatar_url" text;

alter table "public"."profiles" add column "brand_signature_url" text;

alter table "public"."profiles" add column "business_industry" text;

alter table "public"."profiles" add column "company" text;

alter table "public"."profiles" add column "country" text;

alter table "public"."profiles" add column "default_invoice_template" text;

alter table "public"."profiles" add column "fcm_token" text;

alter table "public"."profiles" add column "industry" text;

alter table "public"."profiles" add column "is_yearly_plan" boolean default false;

alter table "public"."profiles" add column "subscription_expires_at" timestamp with time zone;

alter table "public"."profiles" add column "subscription_expiry" timestamp with time zone;

alter table "public"."profiles" add column "subscription_status" text default 'active'::text;

alter table "public"."recurring_invoices" drop column "updated_at";

alter table "public"."recurring_invoices" add column "amount" numeric(15,2);

alter table "public"."recurring_invoices" add column "status" text default 'active'::text;

alter table "public"."recurring_invoices" alter column "frequency" drop default;

alter table "public"."recurring_invoices" alter column "id" drop default;

alter table "public"."recurring_invoices" alter column "id" add generated by default as identity;

alter table "public"."recurring_invoices" alter column "id" set data type bigint using "id"::bigint;

alter table "public"."recurring_invoices" alter column "next_run_at" drop default;

alter table "public"."recurring_invoices" alter column "next_run_at" drop not null;

alter table "public"."recurring_invoices" alter column "next_run_at" set data type date using "next_run_at"::date;

alter table "public"."recurring_invoices" alter column "team_id" drop not null;

alter table "public"."stock_ledger" alter column "team_id" drop not null;

alter table "public"."team_members" drop column "joined_at";

alter table "public"."team_members" add column "created_at" timestamp with time zone default now();

alter table "public"."team_members" alter column "id" set default gen_random_uuid();

alter table "public"."team_members" alter column "id" drop identity;

alter table "public"."team_members" alter column "id" set data type uuid using "id"::uuid;

alter table "public"."team_members" alter column "role" set default 'staff'::text;

alter table "public"."team_members" alter column "role" drop not null;

alter table "public"."team_members" alter column "role" set data type text using "role"::text;

alter table "public"."team_members" alter column "team_id" drop not null;

alter table "public"."team_members" alter column "user_id" drop not null;

alter table "public"."teams" add column "brand_color" text default '#2563EB'::text;

alter table "public"."teams" add column "brand_logo_url" text;

alter table "public"."teams" add column "brand_signature_url" text;

alter table "public"."teams" add column "business_address" text;

alter table "public"."teams" add column "business_email" text;

alter table "public"."teams" add column "business_phone" text;

alter table "public"."teams" add column "default_invoice_template" text;

alter table "public"."teams" add column "default_payment_terms" text default 'Payment is due within 14 days of invoice issue.'::text;

alter table "public"."teams" add column "default_vat_rate" numeric default 0;

alter table "public"."teams" add column "default_wht_rate" numeric default 0;

alter table "public"."teams" add column "flutterwave_subaccount_id" text;

alter table "public"."teams" add column "invoice_footer" text;

alter table "public"."teams" add column "invoice_prefix" text default 'NGO'::text;

alter table "public"."teams" add column "tax_number" text;

alter table "public"."teams" alter column "brand_voice" set default 'Professional & Trusted'::text;

alter table "public"."teams" alter column "owner_id" drop not null;

alter table "public"."teams" alter column "primary_color" set default '0xFF2563EB'::text;

alter table "public"."teams" alter column "secondary_color" set default '0xFF1E293B'::text;

alter sequence "public"."client_communication_logs_id_seq" owned by "public"."client_communication_logs"."id";

alter sequence "public"."webhook_logs_id_seq" owned by "public"."webhook_logs"."id";

CREATE UNIQUE INDEX billing_history_pkey ON public.billing_history USING btree (id);

CREATE UNIQUE INDEX billing_history_transaction_ref_key ON public.billing_history USING btree (transaction_ref);

CREATE UNIQUE INDEX business_cards_pkey ON public.business_cards USING btree (id);

CREATE UNIQUE INDEX business_cards_team_id_key ON public.business_cards USING btree (team_id);

CREATE UNIQUE INDEX client_communication_logs_pkey ON public.client_communication_logs USING btree (id);

CREATE UNIQUE INDEX client_documents_pkey ON public.client_documents USING btree (id);

CREATE UNIQUE INDEX client_ledger_pkey ON public.client_ledger USING btree (id);

CREATE UNIQUE INDEX client_notes_pkey ON public.client_notes USING btree (id);

CREATE UNIQUE INDEX expense_categories_pkey ON public.expense_categories USING btree (id);

CREATE UNIQUE INDEX folders_pkey ON public.folders USING btree (id);

CREATE INDEX idx_billing_history_user ON public.billing_history USING btree (user_id);

CREATE INDEX idx_client_ledger_cid ON public.client_ledger USING btree (client_id);

CREATE INDEX idx_client_ledger_team ON public.client_ledger USING btree (team_id);

CREATE INDEX idx_client_notes_sentiment ON public.client_notes USING btree (sentiment);

CREATE INDEX idx_clients_lead_status ON public.clients USING btree (lead_status);

CREATE INDEX idx_clients_payment_vault ON public.clients USING btree (payment_token) WHERE (payment_token IS NOT NULL);

CREATE INDEX idx_comm_logs_client ON public.client_communication_logs USING btree (client_id);

CREATE INDEX idx_expenses_invoice_id ON public.expenses USING btree (invoice_id) WHERE (invoice_id IS NOT NULL);

CREATE INDEX idx_expenses_team_date ON public.expenses USING btree (team_id, expense_date DESC);

CREATE INDEX idx_invoice_metadata ON public.invoices USING gin (metadata);

CREATE INDEX idx_invoices_due_reminder ON public.invoices USING btree (status, due_date) WHERE (status = 'pending'::text);

CREATE INDEX idx_invoices_overdue_scan ON public.invoices USING btree (status, due_date) WHERE (status = 'pending'::text);

CREATE INDEX idx_invoices_tracking ON public.invoices USING btree (tracking_token);

CREATE INDEX idx_invoices_type_status ON public.invoices USING btree (invoice_type, status);

CREATE INDEX idx_recurring_generation ON public.recurring_invoices USING btree (is_active, next_run_at) WHERE (is_active = true);

CREATE INDEX idx_usage_metrics_user_month ON public.usage_metrics USING btree (user_id, month_year);

CREATE UNIQUE INDEX live_chat_messages_pkey ON public.live_chat_messages USING btree (id);

CREATE UNIQUE INDEX payment_methods_pkey ON public.payment_methods USING btree (id);

CREATE UNIQUE INDEX pending_invitations_pkey ON public.pending_invitations USING btree (id);

CREATE UNIQUE INDEX pending_invitations_team_id_email_key ON public.pending_invitations USING btree (team_id, email);

CREATE UNIQUE INDEX qr_codes_pkey ON public.qr_codes USING btree (id);

CREATE UNIQUE INDEX qr_scans_pkey ON public.qr_scans USING btree (id);

CREATE UNIQUE INDEX usage_metrics_pkey ON public.usage_metrics USING btree (id);

CREATE UNIQUE INDEX usage_metrics_user_id_month_year_key ON public.usage_metrics USING btree (user_id, month_year);

CREATE UNIQUE INDEX user_sessions_pkey ON public.user_sessions USING btree (id);

CREATE UNIQUE INDEX vendors_pkey ON public.vendors USING btree (id);

CREATE UNIQUE INDEX webhook_logs_pkey ON public.webhook_logs USING btree (id);

alter table "public"."billing_history" add constraint "billing_history_pkey" PRIMARY KEY using index "billing_history_pkey";

alter table "public"."business_cards" add constraint "business_cards_pkey" PRIMARY KEY using index "business_cards_pkey";

alter table "public"."client_communication_logs" add constraint "client_communication_logs_pkey" PRIMARY KEY using index "client_communication_logs_pkey";

alter table "public"."client_documents" add constraint "client_documents_pkey" PRIMARY KEY using index "client_documents_pkey";

alter table "public"."client_ledger" add constraint "client_ledger_pkey" PRIMARY KEY using index "client_ledger_pkey";

alter table "public"."client_notes" add constraint "client_notes_pkey" PRIMARY KEY using index "client_notes_pkey";

alter table "public"."expense_categories" add constraint "expense_categories_pkey" PRIMARY KEY using index "expense_categories_pkey";

alter table "public"."folders" add constraint "folders_pkey" PRIMARY KEY using index "folders_pkey";

alter table "public"."live_chat_messages" add constraint "live_chat_messages_pkey" PRIMARY KEY using index "live_chat_messages_pkey";

alter table "public"."payment_methods" add constraint "payment_methods_pkey" PRIMARY KEY using index "payment_methods_pkey";

alter table "public"."pending_invitations" add constraint "pending_invitations_pkey" PRIMARY KEY using index "pending_invitations_pkey";

alter table "public"."qr_codes" add constraint "qr_codes_pkey" PRIMARY KEY using index "qr_codes_pkey";

alter table "public"."qr_scans" add constraint "qr_scans_pkey" PRIMARY KEY using index "qr_scans_pkey";

alter table "public"."usage_metrics" add constraint "usage_metrics_pkey" PRIMARY KEY using index "usage_metrics_pkey";

alter table "public"."user_sessions" add constraint "user_sessions_pkey" PRIMARY KEY using index "user_sessions_pkey";

alter table "public"."vendors" add constraint "vendors_pkey" PRIMARY KEY using index "vendors_pkey";

alter table "public"."webhook_logs" add constraint "webhook_logs_pkey" PRIMARY KEY using index "webhook_logs_pkey";

alter table "public"."billing_history" add constraint "billing_history_transaction_ref_key" UNIQUE using index "billing_history_transaction_ref_key";

alter table "public"."billing_history" add constraint "billing_history_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."billing_history" validate constraint "billing_history_user_id_fkey";

alter table "public"."business_cards" add constraint "business_cards_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."business_cards" validate constraint "business_cards_team_id_fkey";

alter table "public"."business_cards" add constraint "business_cards_team_id_key" UNIQUE using index "business_cards_team_id_key";

alter table "public"."client_communication_logs" add constraint "client_communication_logs_author_id_fkey" FOREIGN KEY (author_id) REFERENCES auth.users(id) not valid;

alter table "public"."client_communication_logs" validate constraint "client_communication_logs_author_id_fkey";

alter table "public"."client_communication_logs" add constraint "client_communication_logs_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE not valid;

alter table "public"."client_communication_logs" validate constraint "client_communication_logs_client_id_fkey";

alter table "public"."client_communication_logs" add constraint "client_communication_logs_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."client_communication_logs" validate constraint "client_communication_logs_team_id_fkey";

alter table "public"."client_ledger" add constraint "client_ledger_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE CASCADE not valid;

alter table "public"."client_ledger" validate constraint "client_ledger_client_id_fkey";

alter table "public"."client_ledger" add constraint "client_ledger_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE SET NULL not valid;

alter table "public"."client_ledger" validate constraint "client_ledger_invoice_id_fkey";

alter table "public"."client_ledger" add constraint "client_ledger_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."client_ledger" validate constraint "client_ledger_team_id_fkey";

alter table "public"."clients" add constraint "clients_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."clients" validate constraint "clients_user_id_fkey";

alter table "public"."expenses" add constraint "expenses_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.expense_categories(id) ON DELETE SET NULL not valid;

alter table "public"."expenses" validate constraint "expenses_category_id_fkey";

alter table "public"."expenses" add constraint "expenses_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE SET NULL not valid;

alter table "public"."expenses" validate constraint "expenses_invoice_id_fkey";

alter table "public"."expenses" add constraint "expenses_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."expenses" validate constraint "expenses_user_id_fkey";

alter table "public"."expenses" add constraint "expenses_vendor_id_fkey" FOREIGN KEY (vendor_id) REFERENCES public.vendors(id) ON DELETE SET NULL not valid;

alter table "public"."expenses" validate constraint "expenses_vendor_id_fkey";

alter table "public"."folders" add constraint "folders_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) not valid;

alter table "public"."folders" validate constraint "folders_team_id_fkey";

alter table "public"."folders" add constraint "folders_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."folders" validate constraint "folders_user_id_fkey";

alter table "public"."invoices" add constraint "invoices_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."invoices" validate constraint "invoices_user_id_fkey";

alter table "public"."live_chat_messages" add constraint "live_chat_messages_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."live_chat_messages" validate constraint "live_chat_messages_user_id_fkey";

alter table "public"."payment_methods" add constraint "payment_methods_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."payment_methods" validate constraint "payment_methods_user_id_fkey";

alter table "public"."pending_invitations" add constraint "pending_invitations_invited_by_fkey" FOREIGN KEY (invited_by) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."pending_invitations" validate constraint "pending_invitations_invited_by_fkey";

alter table "public"."pending_invitations" add constraint "pending_invitations_team_id_email_key" UNIQUE using index "pending_invitations_team_id_email_key";

alter table "public"."pending_invitations" add constraint "pending_invitations_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."pending_invitations" validate constraint "pending_invitations_team_id_fkey";

alter table "public"."products" add constraint "products_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) not valid;

alter table "public"."products" validate constraint "products_user_id_fkey";

alter table "public"."qr_codes" add constraint "qr_codes_folder_id_fkey" FOREIGN KEY (folder_id) REFERENCES public.folders(id) ON DELETE SET NULL not valid;

alter table "public"."qr_codes" validate constraint "qr_codes_folder_id_fkey";

alter table "public"."qr_codes" add constraint "qr_codes_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."qr_codes" validate constraint "qr_codes_team_id_fkey";

alter table "public"."qr_codes" add constraint "qr_codes_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."qr_codes" validate constraint "qr_codes_user_id_fkey";

alter table "public"."qr_scans" add constraint "qr_scans_qr_code_id_fkey" FOREIGN KEY (qr_code_id) REFERENCES public.qr_codes(id) ON DELETE CASCADE not valid;

alter table "public"."qr_scans" validate constraint "qr_scans_qr_code_id_fkey";

alter table "public"."usage_metrics" add constraint "usage_metrics_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."usage_metrics" validate constraint "usage_metrics_user_id_fkey";

alter table "public"."usage_metrics" add constraint "usage_metrics_user_id_month_year_key" UNIQUE using index "usage_metrics_user_id_month_year_key";

alter table "public"."user_sessions" add constraint "user_sessions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_sessions" validate constraint "user_sessions_user_id_fkey";

alter table "public"."vendors" add constraint "vendors_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."vendors" validate constraint "vendors_team_id_fkey";

alter table "public"."vendors" add constraint "vendors_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."vendors" validate constraint "vendors_user_id_fkey";

alter table "public"."clients" add constraint "clients_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."clients" validate constraint "clients_team_id_fkey";

alter table "public"."expenses" add constraint "expenses_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) not valid;

alter table "public"."expenses" validate constraint "expenses_team_id_fkey";

alter table "public"."fcm_tokens" add constraint "fcm_tokens_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."fcm_tokens" validate constraint "fcm_tokens_team_id_fkey";

alter table "public"."invoice_items" add constraint "invoice_items_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE not valid;

alter table "public"."invoice_items" validate constraint "invoice_items_invoice_id_fkey";

alter table "public"."invoice_items" add constraint "invoice_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL not valid;

alter table "public"."invoice_items" validate constraint "invoice_items_product_id_fkey";

alter table "public"."invoices" add constraint "invoices_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE SET NULL not valid;

alter table "public"."invoices" validate constraint "invoices_client_id_fkey";

alter table "public"."invoices" add constraint "invoices_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."invoices" validate constraint "invoices_team_id_fkey";

alter table "public"."product_categories" add constraint "product_categories_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."product_categories" validate constraint "product_categories_team_id_fkey";

alter table "public"."products" add constraint "products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL not valid;

alter table "public"."products" validate constraint "products_category_id_fkey";

alter table "public"."products" add constraint "products_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."products" validate constraint "products_team_id_fkey";

alter table "public"."recurring_invoices" add constraint "recurring_invoices_client_id_fkey" FOREIGN KEY (client_id) REFERENCES public.clients(id) ON DELETE SET NULL not valid;

alter table "public"."recurring_invoices" validate constraint "recurring_invoices_client_id_fkey";

alter table "public"."recurring_invoices" add constraint "recurring_invoices_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."recurring_invoices" validate constraint "recurring_invoices_team_id_fkey";

alter table "public"."stock_ledger" add constraint "stock_ledger_product_id_fkey" FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE not valid;

alter table "public"."stock_ledger" validate constraint "stock_ledger_product_id_fkey";

alter table "public"."stock_ledger" add constraint "stock_ledger_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) not valid;

alter table "public"."stock_ledger" validate constraint "stock_ledger_team_id_fkey";

alter table "public"."team_members" add constraint "team_members_team_id_fkey" FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE not valid;

alter table "public"."team_members" validate constraint "team_members_team_id_fkey";

alter table "public"."team_members" add constraint "team_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."team_members" validate constraint "team_members_user_id_fkey";

alter table "public"."teams" add constraint "teams_owner_id_fkey" FOREIGN KEY (owner_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."teams" validate constraint "teams_owner_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.check_is_member(t_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_members.team_id = t_id 
    AND team_members.user_id = auth.uid()
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_is_owner(t_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.teams 
    WHERE teams.id = t_id 
    AND teams.owner_id = auth.uid()
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_team_access(t_id uuid, required_roles public.team_role[] DEFAULT ARRAY['owner'::public.team_role, 'admin'::public.team_role, 'staff'::public.team_role, 'accountant'::public.team_role])
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_id = t_id 
    AND user_id = auth.uid() 
    AND role = ANY(required_roles)
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.check_team_membership(team_id uuid, user_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members 
    WHERE team_members.team_id = $1 
    AND team_members.user_id = $2
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_platform_stats()
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  merchant_count INT;
  total_volume NUMERIC(15,2);
  invoice_count INT;
  platform_revenue NUMERIC(15,2);
  result JSONB;
BEGIN
  -- 1. Total Merchants
  SELECT count(*) INTO merchant_count FROM public.profiles;

  -- 2. Total Transaction Volume (Paid Invoices)
  SELECT coalesce(sum(total_amount), 0) INTO total_volume 
  FROM public.invoices 
  WHERE status = 'paid';

  -- 3. Total Invoices Issued
  SELECT count(*) INTO invoice_count FROM public.invoices;

  -- 4. Platform Revenue (Mock 1% for now, or use real fee logic)
  platform_revenue := total_volume * 0.01;

  result := jsonb_build_object(
    'merchant_count', merchant_count,
    'total_volume', total_volume,
    'invoice_count', invoice_count,
    'platform_revenue', platform_revenue,
    'updated_at', now()
  );

  RETURN result;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_usage(u_id uuid, m_year text, col_name text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  -- Upsert the row first
  INSERT INTO public.usage_metrics (user_id, month_year)
  VALUES (u_id, m_year)
  ON CONFLICT (user_id, month_year) DO NOTHING;

  -- Increment the requested column safely
  EXECUTE format(
    'UPDATE public.usage_metrics SET %I = COALESCE(%I, 0) + 1
     WHERE user_id = $1 AND month_year = $2',
    col_name, col_name
  ) USING u_id, m_year;
END;
$function$
;

create or replace view "public"."invoice_tracking_stats" as  SELECT team_id,
    count(*) FILTER (WHERE (opened_at IS NOT NULL)) AS total_opened,
    count(*) FILTER (WHERE ((opened_at IS NULL) AND (due_date < now()))) AS total_ignored_overdue,
    (avg((EXTRACT(epoch FROM (opened_at - (issue_date)::timestamp with time zone)) / (3600)::numeric)))::numeric(10,2) AS avg_hours_to_open
   FROM public.invoices
  GROUP BY team_id;


CREATE OR REPLACE FUNCTION public.is_profile_owner(profile_id_to_check uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN profile_id_to_check = auth.uid();
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_team_member(team_id_to_check uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.team_members
    WHERE team_id = team_id_to_check
    AND user_id = auth.uid()
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_team_owner(team_id_to_check uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.teams
    WHERE id = team_id_to_check
    AND owner_id = auth.uid()
  );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_client_balance_tracker()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    adjustment NUMERIC;
BEGIN
    -- Determine adjustment
    IF (TG_OP = 'INSERT') THEN
        adjustment := NEW.amount;
    ELSIF (TG_OP = 'DELETE') THEN
        adjustment := -OLD.amount;
    ELSE
        adjustment := NEW.amount - OLD.amount;
    END IF;

    UPDATE clients 
    SET current_balance = COALESCE(current_balance, 0) + adjustment 
    WHERE id = COALESCE(NEW.client_id, OLD.client_id);
    
    RETURN NULL;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_product_stock()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE public.products
  SET stock_quantity = stock_quantity + NEW.change_amount
  WHERE id = NEW.product_id;
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.upgrade_user_subscription(target_user_id uuid, target_tier text, is_yearly boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
  expiry_interval INTERVAL;
BEGIN
  -- Validate tier
  IF target_tier NOT IN ('pulse', 'elite') THEN
    RAISE EXCEPTION 'Invalid subscription tier: %', target_tier;
  END IF;

  IF is_yearly THEN
    expiry_interval := INTERVAL '1 year';
  ELSE
    expiry_interval := INTERVAL '1 month';
  END IF;

  UPDATE public.profiles
  SET
    subscription_tier       = target_tier,
    subscription_expires_at = NOW() + expiry_interval,
    is_yearly_plan          = is_yearly,
    updated_at              = NOW()
  WHERE id = target_user_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'User not found: %', target_user_id;
  END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    new_team_id UUID;
BEGIN
    INSERT INTO public.profiles (id, email, display_name, onboarding_completed)
    VALUES (new.id, new.email, COALESCE(new.raw_user_meta_data->>'full_name', substring(new.email from '(.*)@')), FALSE)
    ON CONFLICT (id) DO NOTHING;

    INSERT INTO public.teams (owner_id, name)
    VALUES (new.id, 'My Business')
    RETURNING id INTO new_team_id;

    INSERT INTO public.team_members (team_id, user_id, role)
    VALUES (new_team_id, new.id, 'owner')
    ON CONFLICT DO NOTHING;

    RETURN new;
EXCEPTION WHEN others THEN
    RETURN new;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$function$
;

grant select on table "public"."billing_history" to "anon";

grant delete on table "public"."billing_history" to "authenticated";

grant insert on table "public"."billing_history" to "authenticated";

grant references on table "public"."billing_history" to "authenticated";

grant select on table "public"."billing_history" to "authenticated";

grant trigger on table "public"."billing_history" to "authenticated";

grant truncate on table "public"."billing_history" to "authenticated";

grant update on table "public"."billing_history" to "authenticated";

grant delete on table "public"."billing_history" to "service_role";

grant insert on table "public"."billing_history" to "service_role";

grant references on table "public"."billing_history" to "service_role";

grant select on table "public"."billing_history" to "service_role";

grant trigger on table "public"."billing_history" to "service_role";

grant truncate on table "public"."billing_history" to "service_role";

grant update on table "public"."billing_history" to "service_role";

grant select on table "public"."business_cards" to "anon";

grant delete on table "public"."business_cards" to "authenticated";

grant insert on table "public"."business_cards" to "authenticated";

grant references on table "public"."business_cards" to "authenticated";

grant select on table "public"."business_cards" to "authenticated";

grant trigger on table "public"."business_cards" to "authenticated";

grant truncate on table "public"."business_cards" to "authenticated";

grant update on table "public"."business_cards" to "authenticated";

grant delete on table "public"."business_cards" to "service_role";

grant insert on table "public"."business_cards" to "service_role";

grant references on table "public"."business_cards" to "service_role";

grant select on table "public"."business_cards" to "service_role";

grant trigger on table "public"."business_cards" to "service_role";

grant truncate on table "public"."business_cards" to "service_role";

grant update on table "public"."business_cards" to "service_role";

grant select on table "public"."client_communication_logs" to "anon";

grant delete on table "public"."client_communication_logs" to "authenticated";

grant insert on table "public"."client_communication_logs" to "authenticated";

grant references on table "public"."client_communication_logs" to "authenticated";

grant select on table "public"."client_communication_logs" to "authenticated";

grant trigger on table "public"."client_communication_logs" to "authenticated";

grant truncate on table "public"."client_communication_logs" to "authenticated";

grant update on table "public"."client_communication_logs" to "authenticated";

grant delete on table "public"."client_communication_logs" to "service_role";

grant insert on table "public"."client_communication_logs" to "service_role";

grant references on table "public"."client_communication_logs" to "service_role";

grant select on table "public"."client_communication_logs" to "service_role";

grant trigger on table "public"."client_communication_logs" to "service_role";

grant truncate on table "public"."client_communication_logs" to "service_role";

grant update on table "public"."client_communication_logs" to "service_role";

grant select on table "public"."client_documents" to "anon";

grant delete on table "public"."client_documents" to "authenticated";

grant insert on table "public"."client_documents" to "authenticated";

grant references on table "public"."client_documents" to "authenticated";

grant select on table "public"."client_documents" to "authenticated";

grant trigger on table "public"."client_documents" to "authenticated";

grant truncate on table "public"."client_documents" to "authenticated";

grant update on table "public"."client_documents" to "authenticated";

grant delete on table "public"."client_documents" to "service_role";

grant insert on table "public"."client_documents" to "service_role";

grant references on table "public"."client_documents" to "service_role";

grant select on table "public"."client_documents" to "service_role";

grant trigger on table "public"."client_documents" to "service_role";

grant truncate on table "public"."client_documents" to "service_role";

grant update on table "public"."client_documents" to "service_role";

grant select on table "public"."client_ledger" to "anon";

grant delete on table "public"."client_ledger" to "authenticated";

grant insert on table "public"."client_ledger" to "authenticated";

grant references on table "public"."client_ledger" to "authenticated";

grant select on table "public"."client_ledger" to "authenticated";

grant trigger on table "public"."client_ledger" to "authenticated";

grant truncate on table "public"."client_ledger" to "authenticated";

grant update on table "public"."client_ledger" to "authenticated";

grant delete on table "public"."client_ledger" to "service_role";

grant insert on table "public"."client_ledger" to "service_role";

grant references on table "public"."client_ledger" to "service_role";

grant select on table "public"."client_ledger" to "service_role";

grant trigger on table "public"."client_ledger" to "service_role";

grant truncate on table "public"."client_ledger" to "service_role";

grant update on table "public"."client_ledger" to "service_role";

grant select on table "public"."client_notes" to "anon";

grant delete on table "public"."client_notes" to "authenticated";

grant insert on table "public"."client_notes" to "authenticated";

grant references on table "public"."client_notes" to "authenticated";

grant select on table "public"."client_notes" to "authenticated";

grant trigger on table "public"."client_notes" to "authenticated";

grant truncate on table "public"."client_notes" to "authenticated";

grant update on table "public"."client_notes" to "authenticated";

grant delete on table "public"."client_notes" to "service_role";

grant insert on table "public"."client_notes" to "service_role";

grant references on table "public"."client_notes" to "service_role";

grant select on table "public"."client_notes" to "service_role";

grant trigger on table "public"."client_notes" to "service_role";

grant truncate on table "public"."client_notes" to "service_role";

grant update on table "public"."client_notes" to "service_role";

grant select on table "public"."expense_categories" to "anon";

grant delete on table "public"."expense_categories" to "authenticated";

grant insert on table "public"."expense_categories" to "authenticated";

grant references on table "public"."expense_categories" to "authenticated";

grant select on table "public"."expense_categories" to "authenticated";

grant trigger on table "public"."expense_categories" to "authenticated";

grant truncate on table "public"."expense_categories" to "authenticated";

grant update on table "public"."expense_categories" to "authenticated";

grant delete on table "public"."expense_categories" to "service_role";

grant insert on table "public"."expense_categories" to "service_role";

grant references on table "public"."expense_categories" to "service_role";

grant select on table "public"."expense_categories" to "service_role";

grant trigger on table "public"."expense_categories" to "service_role";

grant truncate on table "public"."expense_categories" to "service_role";

grant update on table "public"."expense_categories" to "service_role";

grant select on table "public"."folders" to "anon";

grant delete on table "public"."folders" to "authenticated";

grant insert on table "public"."folders" to "authenticated";

grant references on table "public"."folders" to "authenticated";

grant select on table "public"."folders" to "authenticated";

grant trigger on table "public"."folders" to "authenticated";

grant truncate on table "public"."folders" to "authenticated";

grant update on table "public"."folders" to "authenticated";

grant delete on table "public"."folders" to "service_role";

grant insert on table "public"."folders" to "service_role";

grant references on table "public"."folders" to "service_role";

grant select on table "public"."folders" to "service_role";

grant trigger on table "public"."folders" to "service_role";

grant truncate on table "public"."folders" to "service_role";

grant update on table "public"."folders" to "service_role";

grant select on table "public"."live_chat_messages" to "anon";

grant delete on table "public"."live_chat_messages" to "authenticated";

grant insert on table "public"."live_chat_messages" to "authenticated";

grant references on table "public"."live_chat_messages" to "authenticated";

grant select on table "public"."live_chat_messages" to "authenticated";

grant trigger on table "public"."live_chat_messages" to "authenticated";

grant truncate on table "public"."live_chat_messages" to "authenticated";

grant update on table "public"."live_chat_messages" to "authenticated";

grant delete on table "public"."live_chat_messages" to "service_role";

grant insert on table "public"."live_chat_messages" to "service_role";

grant references on table "public"."live_chat_messages" to "service_role";

grant select on table "public"."live_chat_messages" to "service_role";

grant trigger on table "public"."live_chat_messages" to "service_role";

grant truncate on table "public"."live_chat_messages" to "service_role";

grant update on table "public"."live_chat_messages" to "service_role";

grant select on table "public"."payment_methods" to "anon";

grant delete on table "public"."payment_methods" to "authenticated";

grant insert on table "public"."payment_methods" to "authenticated";

grant references on table "public"."payment_methods" to "authenticated";

grant select on table "public"."payment_methods" to "authenticated";

grant trigger on table "public"."payment_methods" to "authenticated";

grant truncate on table "public"."payment_methods" to "authenticated";

grant update on table "public"."payment_methods" to "authenticated";

grant delete on table "public"."payment_methods" to "service_role";

grant insert on table "public"."payment_methods" to "service_role";

grant references on table "public"."payment_methods" to "service_role";

grant select on table "public"."payment_methods" to "service_role";

grant trigger on table "public"."payment_methods" to "service_role";

grant truncate on table "public"."payment_methods" to "service_role";

grant update on table "public"."payment_methods" to "service_role";

grant delete on table "public"."pending_invitations" to "anon";

grant insert on table "public"."pending_invitations" to "anon";

grant references on table "public"."pending_invitations" to "anon";

grant select on table "public"."pending_invitations" to "anon";

grant trigger on table "public"."pending_invitations" to "anon";

grant truncate on table "public"."pending_invitations" to "anon";

grant update on table "public"."pending_invitations" to "anon";

grant delete on table "public"."pending_invitations" to "authenticated";

grant insert on table "public"."pending_invitations" to "authenticated";

grant references on table "public"."pending_invitations" to "authenticated";

grant select on table "public"."pending_invitations" to "authenticated";

grant trigger on table "public"."pending_invitations" to "authenticated";

grant truncate on table "public"."pending_invitations" to "authenticated";

grant update on table "public"."pending_invitations" to "authenticated";

grant delete on table "public"."pending_invitations" to "service_role";

grant insert on table "public"."pending_invitations" to "service_role";

grant references on table "public"."pending_invitations" to "service_role";

grant select on table "public"."pending_invitations" to "service_role";

grant trigger on table "public"."pending_invitations" to "service_role";

grant truncate on table "public"."pending_invitations" to "service_role";

grant update on table "public"."pending_invitations" to "service_role";

grant select on table "public"."qr_codes" to "anon";

grant delete on table "public"."qr_codes" to "authenticated";

grant insert on table "public"."qr_codes" to "authenticated";

grant references on table "public"."qr_codes" to "authenticated";

grant select on table "public"."qr_codes" to "authenticated";

grant trigger on table "public"."qr_codes" to "authenticated";

grant truncate on table "public"."qr_codes" to "authenticated";

grant update on table "public"."qr_codes" to "authenticated";

grant delete on table "public"."qr_codes" to "service_role";

grant insert on table "public"."qr_codes" to "service_role";

grant references on table "public"."qr_codes" to "service_role";

grant select on table "public"."qr_codes" to "service_role";

grant trigger on table "public"."qr_codes" to "service_role";

grant truncate on table "public"."qr_codes" to "service_role";

grant update on table "public"."qr_codes" to "service_role";

grant select on table "public"."qr_scans" to "anon";

grant delete on table "public"."qr_scans" to "authenticated";

grant insert on table "public"."qr_scans" to "authenticated";

grant references on table "public"."qr_scans" to "authenticated";

grant select on table "public"."qr_scans" to "authenticated";

grant trigger on table "public"."qr_scans" to "authenticated";

grant truncate on table "public"."qr_scans" to "authenticated";

grant update on table "public"."qr_scans" to "authenticated";

grant delete on table "public"."qr_scans" to "service_role";

grant insert on table "public"."qr_scans" to "service_role";

grant references on table "public"."qr_scans" to "service_role";

grant select on table "public"."qr_scans" to "service_role";

grant trigger on table "public"."qr_scans" to "service_role";

grant truncate on table "public"."qr_scans" to "service_role";

grant update on table "public"."qr_scans" to "service_role";

grant delete on table "public"."usage_metrics" to "anon";

grant insert on table "public"."usage_metrics" to "anon";

grant references on table "public"."usage_metrics" to "anon";

grant select on table "public"."usage_metrics" to "anon";

grant trigger on table "public"."usage_metrics" to "anon";

grant truncate on table "public"."usage_metrics" to "anon";

grant update on table "public"."usage_metrics" to "anon";

grant delete on table "public"."usage_metrics" to "authenticated";

grant insert on table "public"."usage_metrics" to "authenticated";

grant references on table "public"."usage_metrics" to "authenticated";

grant select on table "public"."usage_metrics" to "authenticated";

grant trigger on table "public"."usage_metrics" to "authenticated";

grant truncate on table "public"."usage_metrics" to "authenticated";

grant update on table "public"."usage_metrics" to "authenticated";

grant delete on table "public"."usage_metrics" to "service_role";

grant insert on table "public"."usage_metrics" to "service_role";

grant references on table "public"."usage_metrics" to "service_role";

grant select on table "public"."usage_metrics" to "service_role";

grant trigger on table "public"."usage_metrics" to "service_role";

grant truncate on table "public"."usage_metrics" to "service_role";

grant update on table "public"."usage_metrics" to "service_role";

grant select on table "public"."user_sessions" to "anon";

grant delete on table "public"."user_sessions" to "authenticated";

grant insert on table "public"."user_sessions" to "authenticated";

grant references on table "public"."user_sessions" to "authenticated";

grant select on table "public"."user_sessions" to "authenticated";

grant trigger on table "public"."user_sessions" to "authenticated";

grant truncate on table "public"."user_sessions" to "authenticated";

grant update on table "public"."user_sessions" to "authenticated";

grant delete on table "public"."user_sessions" to "service_role";

grant insert on table "public"."user_sessions" to "service_role";

grant references on table "public"."user_sessions" to "service_role";

grant select on table "public"."user_sessions" to "service_role";

grant trigger on table "public"."user_sessions" to "service_role";

grant truncate on table "public"."user_sessions" to "service_role";

grant update on table "public"."user_sessions" to "service_role";

grant select on table "public"."vendors" to "anon";

grant delete on table "public"."vendors" to "authenticated";

grant insert on table "public"."vendors" to "authenticated";

grant references on table "public"."vendors" to "authenticated";

grant select on table "public"."vendors" to "authenticated";

grant trigger on table "public"."vendors" to "authenticated";

grant truncate on table "public"."vendors" to "authenticated";

grant update on table "public"."vendors" to "authenticated";

grant delete on table "public"."vendors" to "service_role";

grant insert on table "public"."vendors" to "service_role";

grant references on table "public"."vendors" to "service_role";

grant select on table "public"."vendors" to "service_role";

grant trigger on table "public"."vendors" to "service_role";

grant truncate on table "public"."vendors" to "service_role";

grant update on table "public"."vendors" to "service_role";

grant delete on table "public"."webhook_logs" to "anon";

grant insert on table "public"."webhook_logs" to "anon";

grant references on table "public"."webhook_logs" to "anon";

grant select on table "public"."webhook_logs" to "anon";

grant trigger on table "public"."webhook_logs" to "anon";

grant truncate on table "public"."webhook_logs" to "anon";

grant update on table "public"."webhook_logs" to "anon";

grant delete on table "public"."webhook_logs" to "authenticated";

grant insert on table "public"."webhook_logs" to "authenticated";

grant references on table "public"."webhook_logs" to "authenticated";

grant select on table "public"."webhook_logs" to "authenticated";

grant trigger on table "public"."webhook_logs" to "authenticated";

grant truncate on table "public"."webhook_logs" to "authenticated";

grant update on table "public"."webhook_logs" to "authenticated";

grant delete on table "public"."webhook_logs" to "service_role";

grant insert on table "public"."webhook_logs" to "service_role";

grant references on table "public"."webhook_logs" to "service_role";

grant select on table "public"."webhook_logs" to "service_role";

grant trigger on table "public"."webhook_logs" to "service_role";

grant truncate on table "public"."webhook_logs" to "service_role";

grant update on table "public"."webhook_logs" to "service_role";


  create policy "Service role manages billing"
  on "public"."billing_history"
  as permissive
  for all
  to public
using ((auth.role() = 'service_role'::text))
with check ((auth.role() = 'service_role'::text));



  create policy "Users read own billing history"
  on "public"."billing_history"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Users see own billing"
  on "public"."billing_history"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Owners and Admins can manage business cards"
  on "public"."business_cards"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = business_cards.team_id) AND (team_members.user_id = auth.uid()) AND (team_members.role = ANY (ARRAY['owner'::text, 'admin'::text]))))));



  create policy "Team access for business_cards"
  on "public"."business_cards"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Team members can view business cards"
  on "public"."business_cards"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = business_cards.team_id) AND (team_members.user_id = auth.uid())))));



  create policy "Team members see logs"
  on "public"."client_communication_logs"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = client_communication_logs.team_id) AND (tm.user_id = auth.uid())))));



  create policy "Team access for client_ledger"
  on "public"."client_ledger"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Client management"
  on "public"."clients"
  as permissive
  for all
  to authenticated
using (public.is_team_member(team_id))
with check (public.is_team_member(team_id));



  create policy "Team access for clients"
  on "public"."clients"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Users can manage own categories"
  on "public"."expense_categories"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "Users can view system and own categories"
  on "public"."expense_categories"
  as permissive
  for select
  to public
using (((user_id IS NULL) OR (user_id = auth.uid())));



  create policy "Team access for expenses"
  on "public"."expenses"
  as permissive
  for all
  to authenticated
using (public.check_is_member(team_id))
with check (public.check_is_member(team_id));



  create policy "Team members can access expenses"
  on "public"."expenses"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = expenses.team_id) AND (team_members.user_id = auth.uid())))))
with check ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = expenses.team_id) AND (team_members.user_id = auth.uid())))));



  create policy "Users manage own fcm tokens"
  on "public"."fcm_tokens"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));



  create policy "Team access for folders"
  on "public"."folders"
  as permissive
  for all
  to authenticated
using (public.check_is_member(team_id))
with check (public.check_is_member(team_id));



  create policy "Invoice items management"
  on "public"."invoice_items"
  as permissive
  for all
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.invoices
  WHERE ((invoices.id = invoice_items.invoice_id) AND public.is_team_member(invoices.team_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.invoices
  WHERE ((invoices.id = invoice_items.invoice_id) AND public.is_team_member(invoices.team_id)))));



  create policy "Team access for invoice_items"
  on "public"."invoice_items"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.invoices
  WHERE ((invoices.id = invoice_items.invoice_id) AND public.is_team_member(invoices.team_id)))));



  create policy "Invoice management"
  on "public"."invoices"
  as permissive
  for all
  to authenticated
using (public.is_team_member(team_id))
with check (public.is_team_member(team_id));



  create policy "Invoices are manageable by team members"
  on "public"."invoices"
  as permissive
  for all
  to public
using (public.check_team_membership(team_id, auth.uid()));



  create policy "Invoices are viewable by team members"
  on "public"."invoices"
  as permissive
  for select
  to public
using (public.check_team_membership(team_id, auth.uid()));



  create policy "Team access for invoices"
  on "public"."invoices"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Users can manage own chat messages"
  on "public"."live_chat_messages"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Users can manage own messages"
  on "public"."live_chat_messages"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Users manage own messages"
  on "public"."live_chat_messages"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Users full access to own payment methods"
  on "public"."payment_methods"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Owners and admins can create invites"
  on "public"."pending_invitations"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = pending_invitations.team_id) AND (team_members.user_id = auth.uid()) AND (team_members.role = ANY (ARRAY['owner'::text, 'admin'::text]))))));



  create policy "Owners and admins can delete invites"
  on "public"."pending_invitations"
  as permissive
  for delete
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = pending_invitations.team_id) AND (team_members.user_id = auth.uid()) AND (team_members.role = ANY (ARRAY['owner'::text, 'admin'::text]))))));



  create policy "Team members can view pending invites"
  on "public"."pending_invitations"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.team_members
  WHERE ((team_members.team_id = pending_invitations.team_id) AND (team_members.user_id = auth.uid())))));



  create policy "Team members can manage product categories"
  on "public"."product_categories"
  as permissive
  for all
  to public
using (public.check_team_access(team_id, ARRAY['owner'::public.team_role, 'admin'::public.team_role, 'staff'::public.team_role]));



  create policy "Product management"
  on "public"."products"
  as permissive
  for all
  to authenticated
using (public.is_team_member(team_id))
with check (public.is_team_member(team_id));



  create policy "Team access for products"
  on "public"."products"
  as permissive
  for all
  to authenticated
using (public.check_is_member(team_id))
with check (public.check_is_member(team_id));



  create policy "Team members can manage products"
  on "public"."products"
  as permissive
  for all
  to public
using (public.check_team_access(team_id, ARRAY['owner'::public.team_role, 'admin'::public.team_role, 'staff'::public.team_role]));



  create policy "Profiles are updatable by owner"
  on "public"."profiles"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Profiles are viewable by owner"
  on "public"."profiles"
  as permissive
  for select
  to public
using ((auth.uid() = id));



  create policy "Profiles insert"
  on "public"."profiles"
  as permissive
  for insert
  to authenticated
with check ((id = auth.uid()));



  create policy "Profiles select"
  on "public"."profiles"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Profiles update"
  on "public"."profiles"
  as permissive
  for update
  to authenticated
using ((id = auth.uid()));



  create policy "Users can update own profile"
  on "public"."profiles"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can view own profile"
  on "public"."profiles"
  as permissive
  for select
  to public
using ((auth.uid() = id));



  create policy "Team access for qr_codes"
  on "public"."qr_codes"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Owners view scans"
  on "public"."qr_scans"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.qr_codes q
  WHERE ((q.id = qr_scans.qr_code_id) AND (q.user_id = auth.uid())))));



  create policy "Public insert qr scans"
  on "public"."qr_scans"
  as permissive
  for insert
  to public
with check (true);



  create policy "Public insert scans"
  on "public"."qr_scans"
  as permissive
  for insert
  to public
with check (true);



  create policy "Recurring invoice management"
  on "public"."recurring_invoices"
  as permissive
  for all
  to authenticated
using (public.is_team_member(team_id))
with check (public.is_team_member(team_id));



  create policy "Team access for recurring_invoices"
  on "public"."recurring_invoices"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Team access for stock_ledger"
  on "public"."stock_ledger"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Team members can manage stock ledger"
  on "public"."stock_ledger"
  as permissive
  for all
  to public
using (public.check_team_access(team_id, ARRAY['owner'::public.team_role, 'admin'::public.team_role, 'staff'::public.team_role]));



  create policy "Members insert"
  on "public"."team_members"
  as permissive
  for insert
  to authenticated
with check (((user_id = auth.uid()) OR public.check_is_owner(team_id)));



  create policy "Members select"
  on "public"."team_members"
  as permissive
  for select
  to authenticated
using (((user_id = auth.uid()) OR public.check_is_owner(team_id)));



  create policy "Memberships are viewable by members"
  on "public"."team_members"
  as permissive
  for select
  to public
using (public.check_team_membership(team_id, auth.uid()));



  create policy "Team members management"
  on "public"."team_members"
  as permissive
  for all
  to authenticated
using ((public.is_team_owner(team_id) OR (user_id = auth.uid())))
with check ((public.is_team_owner(team_id) OR (user_id = auth.uid())));



  create policy "Team members visibility"
  on "public"."team_members"
  as permissive
  for select
  to authenticated
using (((user_id = auth.uid()) OR public.is_team_member(team_id)));



  create policy "Teams are viewable by members"
  on "public"."teams"
  as permissive
  for select
  to public
using (public.check_team_membership(id, auth.uid()));



  create policy "Teams insert"
  on "public"."teams"
  as permissive
  for insert
  to authenticated
with check ((owner_id = auth.uid()));



  create policy "Teams management"
  on "public"."teams"
  as permissive
  for all
  to authenticated
using ((owner_id = auth.uid()))
with check ((owner_id = auth.uid()));



  create policy "Teams select"
  on "public"."teams"
  as permissive
  for select
  to authenticated
using (((owner_id = auth.uid()) OR public.check_is_member(id)));



  create policy "Teams update"
  on "public"."teams"
  as permissive
  for update
  to authenticated
using ((owner_id = auth.uid()));



  create policy "Teams visibility"
  on "public"."teams"
  as permissive
  for select
  to authenticated
using (((owner_id = auth.uid()) OR public.is_team_member(id)));



  create policy "Usage metrics are manageable by owner"
  on "public"."usage_metrics"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Usage metrics are viewable by owner"
  on "public"."usage_metrics"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Users manage own usage"
  on "public"."usage_metrics"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));



  create policy "Users full access to own sessions"
  on "public"."user_sessions"
  as permissive
  for all
  to public
using ((auth.uid() = user_id));



  create policy "Team access for vendors"
  on "public"."vendors"
  as permissive
  for all
  to public
using (public.is_team_member(team_id));



  create policy "Service role only"
  on "public"."webhook_logs"
  as permissive
  for all
  to public
using ((auth.role() = 'service_role'::text))
with check ((auth.role() = 'service_role'::text));



  create policy "System can write logs"
  on "public"."webhook_logs"
  as permissive
  for insert
  to public
with check (true);


CREATE TRIGGER trg_update_client_balance AFTER INSERT OR DELETE OR UPDATE ON public.client_ledger FOR EACH ROW EXECUTE FUNCTION public.update_client_balance_tracker();

CREATE TRIGGER set_qr_codes_updated_at BEFORE UPDATE ON public.qr_codes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER tr_update_stock_on_ledger AFTER INSERT ON public.stock_ledger FOR EACH ROW EXECUTE FUNCTION public.update_product_stock();

CREATE TRIGGER set_clients_updated_at BEFORE UPDATE ON public.clients FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_invoices_updated_at BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_teams_updated_at BEFORE UPDATE ON public.teams FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

drop trigger if exists "on_auth_user_created" on "auth"."users";

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


  create policy "Anyone can view brand assets"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'brand-assets'::text));



  create policy "Anyone can view qr assets"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'qr_assets'::text));



  create policy "Anyone can view receipts"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'receipts'::text));



  create policy "Authenticated users can upload logos"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check ((bucket_id = 'logos'::text));



  create policy "Public Access for Avatars"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'avatars'::text));



  create policy "Public Access to Logos"
  on "storage"."objects"
  as permissive
  for select
  to public
using ((bucket_id = 'logos'::text));



  create policy "User Delete Avatar"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));



  create policy "User Update Avatar"
  on "storage"."objects"
  as permissive
  for update
  to authenticated
using (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));



  create policy "User Upload Avatar"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));



  create policy "Users can delete own assets"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'qr_assets'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can delete own logos"
  on "storage"."objects"
  as permissive
  for delete
  to authenticated
using ((bucket_id = 'logos'::text));



  create policy "Users can delete own receipts"
  on "storage"."objects"
  as permissive
  for delete
  to public
using (((bucket_id = 'receipts'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can upload own brand assets"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'brand-assets'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can upload qr assets"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'qr_assets'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can upload receipts"
  on "storage"."objects"
  as permissive
  for insert
  to public
with check (((bucket_id = 'receipts'::text) AND ((auth.uid())::text = (storage.foldername(name))[1])));



  create policy "Users can upload their own logos"
  on "storage"."objects"
  as permissive
  for insert
  to authenticated
with check (((bucket_id = 'logos'::text) AND ((storage.foldername(name))[1] = 'logos'::text)));



