-- ============================================================================
-- REHABSENSE v2 CORE MIGRATION
-- Adds Doctor and Admin Portals, Clinical Guardrails, Auditing, and RLS
-- ============================================================================

-- ── 1. ENUMS ─────────────────────────────────────────────────────────────────

do $$ begin
  create type public.user_role as enum ('patient', 'doctor', 'admin');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.account_status as enum ('active', 'disabled', 'pending_verification');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.doctor_application_status as enum ('draft', 'pending', 'approved', 'rejected', 'permanently_rejected');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.connection_status as enum ('pending', 'accepted', 'declined', 'expired', 'disconnected');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.assignment_status as enum ('active', 'completed', 'cancelled');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.tracking_type as enum ('rep', 'hold');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.camera_view as enum ('side', 'front');
exception
  when duplicate_object then null;
end $$;

do $$ begin
  create type public.joint_type as enum ('knee', 'shoulder', 'elbow', 'hip', 'ankle', 'spine');
exception
  when duplicate_object then null;
end $$;


-- ── 2. PROFILES ADAPTATION ───────────────────────────────────────────────────

-- Add role, account_status, archived_at if missing
alter table public.profiles
  add column if not exists role public.user_role not null default 'patient',
  add column if not exists account_status public.account_status not null default 'active',
  add column if not exists archived_at timestamp with time zone;

-- Index for role lookup
create index if not exists idx_profiles_role on public.profiles(role);
create index if not exists idx_profiles_account_status on public.profiles(account_status);


-- ── 3. HELPER FUNCTIONS FOR SECURITY (SECURITY DEFINER) ─────────────────────

create or replace function public.is_admin()
returns boolean as $$
begin
  return exists (
    select 1 from public.profiles
    where id = auth.uid()
      and role = 'admin'
      and account_status = 'active'
  );
end;
$$ language plpgsql security definer;

create or replace function public.is_doctor()
returns boolean as $$
begin
  return exists (
    select 1 from public.profiles
    where id = auth.uid()
      and role = 'doctor'
      and account_status = 'active'
  );
end;
$$ language plpgsql security definer;

create or replace function public.handle_new_user()
returns trigger as $$
begin
  -- Always insert as patient, ignore any role specified in client metadata
  insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.email,
    'patient',
    'active',
    now(),
    now()
  )
  on conflict (id) do update set
    email = excluded.email,
    updated_at = now();

  return new;
end;
$$ language plpgsql security definer;


-- ── 4. DOCTOR PROFILES & APPLICATIONS ───────────────────────────────────────

create table if not exists public.doctor_profiles (
  id uuid references public.profiles(id) on delete cascade primary key,
  title text not null default 'Physiotherapist',
  clinic text,
  phone text,
  city text,
  languages text[] default '{"English"}' not null,
  expertise_tags text[] default '{}' not null,
  bio text,
  approach text,
  is_accepting_patients boolean default true not null,
  max_patients integer default 30 not null,
  working_days text[] default '{"Mon", "Tue", "Wed", "Thu", "Fri"}' not null,
  is_verified boolean default false not null,
  is_listed boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.doctor_profiles enable row level security;

create table if not exists public.doctor_applications (
  id uuid default gen_random_uuid() primary key,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  attempt_number integer default 1 not null check (attempt_number between 1 and 3),
  license_number text not null,
  degree text not null,
  status public.doctor_application_status default 'pending' not null,
  reject_reason text,
  reject_notes text,
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamp with time zone,
  submitted_at timestamp with time zone default timezone('utc'::text, now()) not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_doctor_apps_status on public.doctor_applications(status);
create index if not exists idx_doctor_apps_doctor on public.doctor_applications(doctor_id);

alter table public.doctor_applications enable row level security;

create table if not exists public.doctor_documents (
  id uuid default gen_random_uuid() primary key,
  application_id uuid references public.doctor_applications(id) on delete cascade not null,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  document_type text not null, -- 'license', 'degree', 'id_card', etc.
  file_path text not null,
  file_name text not null,
  file_size integer,
  mime_type text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.doctor_documents enable row level security;


-- ── 5. PATIENT CONDITIONS & DOCTOR CONNECTIONS ──────────────────────────────

create table if not exists public.patient_conditions (
  id uuid default gen_random_uuid() primary key,
  patient_id uuid references public.profiles(id) on delete cascade not null,
  body_area text not null, -- 'Knee', 'Shoulder', etc.
  duration text not null,
  diagnosis text,
  baseline_pain integer not null check (baseline_pain between 0 and 10),
  red_flags text[] default '{}' not null,
  goals text[] default '{}' not null,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_conditions_patient on public.patient_conditions(patient_id);
alter table public.patient_conditions enable row level security;

create table if not exists public.doctor_requests (
  id uuid default gen_random_uuid() primary key,
  patient_id uuid references public.profiles(id) on delete cascade not null,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  condition_id uuid references public.patient_conditions(id) on delete set null,
  message text,
  status public.connection_status default 'pending' not null,
  decline_reason text,
  decline_notes text,
  expires_at timestamp with time zone not null default (now() + interval '7 days'),
  responded_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_doc_reqs_doctor on public.doctor_requests(doctor_id, status);
create index if not exists idx_doc_reqs_patient on public.doctor_requests(patient_id, status);
alter table public.doctor_requests enable row level security;

create table if not exists public.doctor_patients (
  id uuid default gen_random_uuid() primary key,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  patient_id uuid references public.profiles(id) on delete cascade not null,
  status public.connection_status default 'accepted' not null,
  connected_at timestamp with time zone default timezone('utc'::text, now()) not null,
  disconnected_at timestamp with time zone,
  disconnected_by uuid references public.profiles(id),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(doctor_id, patient_id)
);

create index if not exists idx_doc_pat_doctor on public.doctor_patients(doctor_id);
create index if not exists idx_doc_pat_patient on public.doctor_patients(patient_id);
alter table public.doctor_patients enable row level security;


-- ── 6. EXERCISES EXTENSIONS & ASSIGNMENTS ───────────────────────────────────

alter table public.exercises
  add column if not exists tracking_type public.tracking_type default 'rep' not null,
  add column if not exists camera_view public.camera_view default 'side' not null,
  add column if not exists tracking_config jsonb default '{}'::jsonb not null,
  add column if not exists is_public boolean default true not null,
  add column if not exists created_by uuid references public.profiles(id),
  add column if not exists is_tested boolean default false not null,
  add column if not exists archived_at timestamp with time zone;

create table if not exists public.assignments (
  id uuid default gen_random_uuid() primary key,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  patient_id uuid references public.profiles(id) on delete cascade not null,
  exercise_id text references public.exercises(id) on delete cascade not null,
  sets integer default 3 not null,
  reps integer default 10,
  hold_seconds integer default 0,
  rest_seconds integer default 45 not null,
  days_of_week text[] default '{"Mon", "Wed", "Fri"}' not null,
  start_date date default current_date not null,
  end_date date not null,
  doctor_notes text,
  status public.assignment_status default 'active' not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_assignments_patient on public.assignments(patient_id, status);
create index if not exists idx_assignments_doctor on public.assignments(doctor_id, status);
alter table public.assignments enable row level security;


-- ── 7. PAIN LOGS, SESSION EXTENSIONS & FEEDBACK ─────────────────────────────

alter table public.sessions
  add column if not exists rep_data jsonb default '[]'::jsonb not null;

create table if not exists public.pain_logs (
  id uuid default gen_random_uuid() primary key,
  patient_id uuid references public.profiles(id) on delete cascade not null,
  session_id text references public.sessions(id) on delete set null,
  pain_level integer not null check (pain_level between 0 and 10),
  notes text,
  triggered_alert boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_pain_logs_patient on public.pain_logs(patient_id);
create index if not exists idx_pain_logs_alert on public.pain_logs(triggered_alert) where triggered_alert = true;
alter table public.pain_logs enable row level security;

create table if not exists public.exercise_feedback (
  id uuid default gen_random_uuid() primary key,
  session_id text references public.sessions(id) on delete cascade not null,
  doctor_id uuid references public.profiles(id) on delete cascade not null,
  feedback text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

create index if not exists idx_feedback_session on public.exercise_feedback(session_id);
alter table public.exercise_feedback enable row level security;


-- ── 8. AUDIT LOG (APPEND ONLY) ──────────────────────────────────────────────

create table if not exists public.audit_log (
  id uuid default gen_random_uuid() primary key,
  actor_id uuid references public.profiles(id),
  action text not null, -- 'approve_doctor', 'reject_doctor', 'suspend_user', etc.
  target_type text not null, -- 'doctor_application', 'profile', 'exercise'
  target_id text not null,
  details jsonb default '{}'::jsonb,
  ip_address text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.audit_log enable row level security;

create or replace function public.prevent_audit_log_modification()
returns trigger as $$
begin
  raise exception 'The audit_log table is append-only. Modification or deletion is strictly forbidden.';
end;
$$ language plpgsql;

drop trigger if exists trg_audit_log_immutable on public.audit_log;
create trigger trg_audit_log_immutable
  before update or delete on public.audit_log
  for each row execute procedure public.prevent_audit_log_modification();


-- ── 9. ROW-LEVEL SECURITY (RLS) POLICIES ─────────────────────────────────────

-- PROFILES
drop policy if exists "Admins can view all profiles" on public.profiles;
create policy "Admins can view all profiles"
  on public.profiles for select
  using (public.is_admin());

drop policy if exists "Doctors can view connected or requesting patients" on public.profiles;
create policy "Doctors can view connected or requesting patients"
  on public.profiles for select
  using (
    auth.uid() = id
    or exists (
      select 1 from public.doctor_patients
      where doctor_patients.doctor_id = auth.uid()
        and doctor_patients.patient_id = profiles.id
        and doctor_patients.status = 'accepted'
    )
    or exists (
      select 1 from public.doctor_requests
      where doctor_requests.doctor_id = auth.uid()
        and doctor_requests.patient_id = profiles.id
        and doctor_requests.status = 'pending'
    )
  );

-- DOCTOR PROFILES
drop policy if exists "Public can view listed verified doctors" on public.doctor_profiles;
create policy "Public can view listed verified doctors"
  on public.doctor_profiles for select
  using (is_listed = true and is_verified = true);

drop policy if exists "Doctors can view and manage their own doctor profile" on public.doctor_profiles;
create policy "Doctors can view and manage their own doctor profile"
  on public.doctor_profiles for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "Admins can view and manage all doctor profiles" on public.doctor_profiles;
create policy "Admins can view and manage all doctor profiles"
  on public.doctor_profiles for all
  using (public.is_admin());

-- DOCTOR APPLICATIONS
drop policy if exists "Doctors can view their own applications" on public.doctor_applications;
create policy "Doctors can view their own applications"
  on public.doctor_applications for select
  using (auth.uid() = doctor_id);

drop policy if exists "Admins can manage all doctor applications" on public.doctor_applications;
create policy "Admins can manage all doctor applications"
  on public.doctor_applications for all
  using (public.is_admin());

-- DOCTOR DOCUMENTS
drop policy if exists "Doctors can manage their own documents" on public.doctor_documents;
create policy "Doctors can manage their own documents"
  on public.doctor_documents for all
  using (auth.uid() = doctor_id)
  with check (auth.uid() = doctor_id);

drop policy if exists "Admins can view all doctor documents" on public.doctor_documents;
create policy "Admins can view all doctor documents"
  on public.doctor_documents for select
  using (public.is_admin());

-- PATIENT CONDITIONS (STRICT: ADMIN FORBIDDEN)
drop policy if exists "Patients can manage their own conditions" on public.patient_conditions;
create policy "Patients can manage their own conditions"
  on public.patient_conditions for all
  using (auth.uid() = patient_id)
  with check (auth.uid() = patient_id);

drop policy if exists "Connected or requested doctors can view patient conditions" on public.patient_conditions;
create policy "Connected or requested doctors can view patient conditions"
  on public.patient_conditions for select
  using (
    exists (
      select 1 from public.doctor_patients
      where doctor_patients.doctor_id = auth.uid()
        and doctor_patients.patient_id = patient_conditions.patient_id
        and doctor_patients.status = 'accepted'
    )
    or exists (
      select 1 from public.doctor_requests
      where doctor_requests.doctor_id = auth.uid()
        and doctor_requests.patient_id = patient_conditions.patient_id
        and doctor_requests.status = 'pending'
    )
  );

-- DOCTOR REQUESTS
drop policy if exists "Patients can manage their own requests" on public.doctor_requests;
create policy "Patients can manage their own requests"
  on public.doctor_requests for all
  using (auth.uid() = patient_id)
  with check (auth.uid() = patient_id);

drop policy if exists "Doctors can view and update requests sent to them" on public.doctor_requests;
create policy "Doctors can view and update requests sent to them"
  on public.doctor_requests for all
  using (auth.uid() = doctor_id)
  with check (auth.uid() = doctor_id);

-- DOCTOR PATIENTS
drop policy if exists "Patients and doctors can view their connections" on public.doctor_patients;
create policy "Patients and doctors can view their connections"
  on public.doctor_patients for select
  using (auth.uid() = patient_id or auth.uid() = doctor_id);

drop policy if exists "Doctors and patients can update their connections" on public.doctor_patients;
create policy "Doctors and patients can update their connections"
  on public.doctor_patients for update
  using (auth.uid() = patient_id or auth.uid() = doctor_id);

-- ASSIGNMENTS
drop policy if exists "Patients can view their assigned exercises" on public.assignments;
create policy "Patients can view their assigned exercises"
  on public.assignments for select
  using (auth.uid() = patient_id);

drop policy if exists "Doctors can manage their patient assignments" on public.assignments;
create policy "Doctors can manage their patient assignments"
  on public.assignments for all
  using (auth.uid() = doctor_id)
  with check (auth.uid() = doctor_id);

-- EXERCISES RLS UPDATE
drop policy if exists "Exercises viewable by patients and creators" on public.exercises;
create policy "Exercises viewable by patients and creators"
  on public.exercises for select
  using (
    is_public = true
    or auth.uid() = created_by
    or exists (
      select 1 from public.assignments
      where assignments.exercise_id = exercises.id
        and assignments.patient_id = auth.uid()
    )
    or public.is_admin()
  );

drop policy if exists "Doctors and Admins can create exercises" on public.exercises;
create policy "Doctors and Admins can create exercises"
  on public.exercises for insert
  with check (public.is_doctor() or public.is_admin());

drop policy if exists "Creators and Admins can update exercises" on public.exercises;
create policy "Creators and Admins can update exercises"
  on public.exercises for update
  using (auth.uid() = created_by or public.is_admin());

-- SESSIONS RLS UPDATE (STRICT: ADMIN CANNOT READ)
drop policy if exists "Connected doctors can view patient sessions" on public.sessions;
create policy "Connected doctors can view patient sessions"
  on public.sessions for select
  using (
    auth.uid() = user_id
    or (
      not public.is_admin()
      and exists (
        select 1 from public.doctor_patients
        where doctor_patients.doctor_id = auth.uid()
          and doctor_patients.patient_id = sessions.user_id
          and doctor_patients.status = 'accepted'
      )
    )
  );

-- PAIN LOGS (STRICT: ADMIN CANNOT READ)
drop policy if exists "Patients can manage their own pain logs" on public.pain_logs;
create policy "Patients can manage their own pain logs"
  on public.pain_logs for all
  using (auth.uid() = patient_id)
  with check (auth.uid() = patient_id);

drop policy if exists "Connected doctors can view patient pain logs" on public.pain_logs;
create policy "Connected doctors can view patient pain logs"
  on public.pain_logs for select
  using (
    not public.is_admin()
    and exists (
      select 1 from public.doctor_patients
      where doctor_patients.doctor_id = auth.uid()
        and doctor_patients.patient_id = pain_logs.patient_id
        and doctor_patients.status = 'accepted'
    )
  );

-- EXERCISE FEEDBACK
drop policy if exists "Patients and Doctors can view feedback" on public.exercise_feedback;
create policy "Patients and Doctors can view feedback"
  on public.exercise_feedback for select
  using (
    auth.uid() = doctor_id
    or exists (
      select 1 from public.sessions
      where sessions.id = exercise_feedback.session_id
        and sessions.user_id = auth.uid()
    )
  );

drop policy if exists "Doctors can insert feedback" on public.exercise_feedback;
create policy "Doctors can insert feedback"
  on public.exercise_feedback for insert
  with check (auth.uid() = doctor_id);

-- AUDIT LOG RLS
drop policy if exists "Admins can view audit logs" on public.audit_log;
create policy "Admins can view audit logs"
  on public.audit_log for select
  using (public.is_admin());

drop policy if exists "System can insert audit logs" on public.audit_log;
create policy "System can insert audit logs"
  on public.audit_log for insert
  with check (true);

