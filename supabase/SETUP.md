# RehabSense v2 — Supabase Backend Setup & Deployment Guide

This guide details how to configure, migrate, seed, and test the Supabase backend for RehabSense v2 across local development and production Supabase environments.

---

## 1. Prerequisites
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed (`npm install -g supabase` or `brew install supabase/tap/supabase`).
- [Docker](https://www.docker.com/) running locally (if using local Supabase).
- Flutter 3.41+ and Dart 3.11+.

---

## 2. Local Development Setup

### 2.1 Start Local Supabase
From the project root:
```bash
supabase start
```
This boots up PostgreSQL, Auth, Storage, and Edge Functions on `http://127.0.0.1:54321`.

### 2.2 Run Migrations
Apply the baseline schema followed by the v2 core migration:
```bash
# 1. Apply baseline tables
supabase db execute --file ./supabase_schema.sql

# 2. Apply v2 migration (enums, doctor/admin tables, RLS, triggers)
supabase db execute --file ./supabase/migrations/20261103000000_rehabsense_v2_core.sql
```

### 2.3 Apply Seed Data
Seed test users, demo doctors, and exercises with complete `tracking_config`:
```bash
supabase db execute --file ./supabase/seed.sql
```

### 2.4 Initialize Storage Buckets
Ensure the private `doctor-documents` bucket exists:
```bash
supabase storage create-bucket doctor-documents --public false
```

### 2.5 Run Edge Functions Locally
Run Edge Functions locally with Deno:
```bash
supabase functions serve --env-file ./supabase/.env.local
```

---

## 3. Creating Staff / Admin Accounts

By system design, **admin accounts have no public self-signup**. To grant staff access:
1. In the Supabase Dashboard, navigate to **Authentication > Users** and click **Add user** (or allow the staff member to sign up once as a standard user).
2. In the **SQL Editor**, elevate the user's role:
```sql
update public.profiles
set role = 'admin',
    account_status = 'active'
where email = 'staff@rehabsense.test';
```
3. The user can now sign in through the **Staff login** link on the Welcome screen.

---

## 4. Production Deployment

### 4.1 Push Database Migrations
Link to your remote project and push migrations:
```bash
supabase link --project-ref your-project-ref
supabase db push
```

### 4.2 Deploy Edge Functions
Deploy each Edge Function individually:
```bash
supabase functions deploy register-doctor
supabase functions deploy admin-review-doctor
supabase functions deploy admin-set-account-status
supabase functions deploy get-document-url
supabase functions deploy send-feedback-notification
```

### 4.3 Configure Secrets in Supabase Cloud
Set required secrets for Edge Functions:
```bash
supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

---

## 5. Flutter App Configuration (`--dart-define`)

To run the Flutter app against local or production environments without hardcoded secrets:

### Local Development
```bash
flutter run \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_ANON_KEY=your_local_anon_key
```

### Production Build
```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_production_anon_key
```

---

## 6. Security & Clinical Guardrails Checklist
- [x] `handle_new_user()` trigger strictly assigns role `'patient'`.
- [x] Admin users are blocked at the RLS level from selecting `sessions`, `pain_logs`, and `patient_conditions`.
- [x] Doctor documents are private and only readable via 60-second signed URLs.
- [x] All clinical exercises use objective terminology ("Movement score").
- [x] Zero camera frames, video files, or photos are uploaded or stored.

