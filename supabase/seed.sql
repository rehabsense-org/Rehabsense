-- ============================================================================
-- REHABSENSE v2 COMPLETE SEED SCRIPT
-- Safely creates Auth users, profiles, doctor profiles, courses, exercises,
-- and audit logs without foreign key constraint violations.
-- ============================================================================

-- Ensure pgcrypto extension is available for password encryption
create extension if not exists pgcrypto with schema extensions;


-- ── 1. COURSES (Prerequisite for exercises foreign key) ──────────────────────

insert into public.courses (id, name, description, level, icon, exercise_ids)
values
(
  'course_knee_rehab',
  'Knee Rehabilitation',
  'A progressive programme to rebuild knee strength, stability and range of motion after injury or surgery.',
  'Beginner',
  'activity',
  array['ex_mini_squat', 'ex_straight_leg_raise', 'ex_wall_sit_hold']
),
(
  'course_wellness_yoga',
  'Wellness Yoga & Balance',
  'Functional balance and mobility routine for core and lower extremity stability.',
  'Beginner',
  'stretch_horizontal',
  array['ex_warrior_2']
),
(
  'knee_rehab',
  'Knee Rehabilitation',
  'A progressive programme to rebuild knee strength, stability and range of motion after injury or surgery.',
  'Beginner',
  'activity',
  array['knee_mini_squat', 'knee_straight_leg_raise', 'knee_seated_extension', 'knee_heel_slide', 'knee_step_up']
),
(
  'shoulder_mobility',
  'Shoulder Mobility',
  'Gentle exercises designed to restore shoulder range of motion, reduce stiffness and improve daily function.',
  'Beginner',
  'stretch_horizontal',
  array['shoulder_pendulum_swing', 'shoulder_flexion', 'shoulder_external_rotation', 'shoulder_wall_slide', 'shoulder_scapular_squeeze']
)
on conflict (id) do update set
  name = excluded.name,
  description = excluded.description,
  level = excluded.level,
  icon = excluded.icon,
  exercise_ids = excluded.exercise_ids;


-- ── 2. AUTH USERS (Creates authentication accounts with password: Password123!) ──

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) values 
-- Admin User
(
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000001',
  'authenticated',
  'authenticated',
  'admin@rehabsense.test',
  extensions.crypt('Password123!', extensions.gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"name":"System Admin"}'::jsonb,
  now(),
  now(),
  '',
  '',
  '',
  ''
),
-- Doctor Sara Khan
(
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000002',
  'authenticated',
  'authenticated',
  'sara.khan@clinic.test',
  extensions.crypt('Password123!', extensions.gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"name":"Dr. Sara Khan"}'::jsonb,
  now(),
  now(),
  '',
  '',
  '',
  ''
),
-- Doctor Omar Sheikh
(
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000003',
  'authenticated',
  'authenticated',
  'omar.sheikh@sports.test',
  extensions.crypt('Password123!', extensions.gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"name":"Dr. Omar Sheikh"}'::jsonb,
  now(),
  now(),
  '',
  '',
  '',
  ''
),
-- Patient Alex Morgan
(
  '00000000-0000-0000-0000-000000000000',
  '00000000-0000-0000-0000-000000000010',
  'authenticated',
  'authenticated',
  'alex@rehab.test',
  extensions.crypt('Password123!', extensions.gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{"name":"Alex Morgan","goal":"Knee recovery","age_range":"30-44"}'::jsonb,
  now(),
  now(),
  '',
  '',
  '',
  ''
)
on conflict (id) do update set
  encrypted_password = excluded.encrypted_password,
  email_confirmed_at = excluded.email_confirmed_at,
  raw_app_meta_data = excluded.raw_app_meta_data,
  raw_user_meta_data = excluded.raw_user_meta_data,
  updated_at = now();


-- ── 3. AUTH IDENTITIES (Enables password sign-in in Supabase GoTrue) ────────

do $$
declare
  v_has_provider_id boolean;
begin
  select exists (
    select 1 from information_schema.columns 
    where table_schema = 'auth' and table_name = 'identities' and column_name = 'provider_id'
  ) into v_has_provider_id;

  if v_has_provider_id then
    insert into auth.identities (id, provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    values
      ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000001', 'email', 'admin@rehabsense.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000002', 'email', 'sara.khan@clinic.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000003', 'email', 'omar.sheikh@sports.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000010', 'email', 'alex@rehab.test'), 'email', now(), now(), now())
    on conflict (provider, provider_id) do update set
      identity_data = excluded.identity_data,
      updated_at = now();
  else
    insert into auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    values
      ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000001', 'email', 'admin@rehabsense.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000002', 'email', 'sara.khan@clinic.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000003', 'email', 'omar.sheikh@sports.test'), 'email', now(), now(), now()),
      ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000010', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000010', 'email', 'alex@rehab.test'), 'email', now(), now(), now())
    on conflict (id, provider) do update set
      identity_data = excluded.identity_data,
      updated_at = now();
  end if;
end $$;


-- ── 4. PROFILES UPSERT (Assigned roles & active status) ─────────────────────

-- Admin User
insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000001',
  'System Admin',
  'admin@rehabsense.test',
  'admin',
  'active',
  now(),
  now()
) on conflict (id) do update set
  name = excluded.name,
  email = excluded.email,
  role = 'admin',
  account_status = 'active',
  updated_at = now();

-- Doctor 1: Dr. Sara Khan
insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000002',
  'Dr. Sara Khan',
  'sara.khan@clinic.test',
  'doctor',
  'active',
  now(),
  now()
) on conflict (id) do update set
  name = excluded.name,
  email = excluded.email,
  role = 'doctor',
  account_status = 'active',
  updated_at = now();

insert into public.doctor_profiles (
  id, title, clinic, phone, city, languages, expertise_tags, bio, approach,
  is_accepting_patients, max_patients, working_days, is_verified, is_listed, created_at, updated_at
) values (
  '00000000-0000-0000-0000-000000000002',
  'Physiotherapist',
  'City Rehab Clinic',
  '+92 300 0000000',
  'Karachi',
  '{"English", "Urdu"}',
  '{"Knee", "Post-surgery", "Sports injury"}',
  'I help patients return to daily life after knee surgery with clear, gradual plans.',
  'Small steps, honest feedback and regular check-ins.',
  true,
  30,
  '{"Mon", "Tue", "Wed", "Thu", "Fri"}',
  true,
  true,
  now(),
  now()
) on conflict (id) do update set
  title = excluded.title,
  clinic = excluded.clinic,
  phone = excluded.phone,
  city = excluded.city,
  languages = excluded.languages,
  expertise_tags = excluded.expertise_tags,
  bio = excluded.bio,
  approach = excluded.approach,
  is_accepting_patients = excluded.is_accepting_patients,
  max_patients = excluded.max_patients,
  working_days = excluded.working_days,
  is_verified = true,
  is_listed = true,
  updated_at = now();

-- Doctor 2: Dr. Omar Sheikh
insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000003',
  'Dr. Omar Sheikh',
  'omar.sheikh@sports.test',
  'doctor',
  'active',
  now(),
  now()
) on conflict (id) do update set
  name = excluded.name,
  email = excluded.email,
  role = 'doctor',
  account_status = 'active',
  updated_at = now();

insert into public.doctor_profiles (
  id, title, clinic, phone, city, languages, expertise_tags, bio, approach,
  is_accepting_patients, max_patients, working_days, is_verified, is_listed, created_at, updated_at
) values (
  '00000000-0000-0000-0000-000000000003',
  'Sports Physiotherapist',
  'Metro Sports Clinic',
  '+92 301 1111111',
  'Lahore',
  '{"English", "Urdu", "Punjabi"}',
  '{"Knee", "Sports injury", "Ankle"}',
  'Specialist in return-to-sport rehabilitation and biomechanical assessment.',
  'Targeted progression, objective movement metrics and strength building.',
  true,
  25,
  '{"Mon", "Wed", "Fri", "Sat"}',
  true,
  true,
  now(),
  now()
) on conflict (id) do update set
  title = excluded.title,
  clinic = excluded.clinic,
  phone = excluded.phone,
  city = excluded.city,
  languages = excluded.languages,
  expertise_tags = excluded.expertise_tags,
  bio = excluded.bio,
  approach = excluded.approach,
  is_accepting_patients = excluded.is_accepting_patients,
  max_patients = excluded.max_patients,
  working_days = excluded.working_days,
  is_verified = true,
  is_listed = true,
  updated_at = now();

-- Patient User: Alex Morgan
insert into public.profiles (id, name, email, role, account_status, age_range, goal, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000010',
  'Alex Morgan',
  'alex@rehab.test',
  'patient',
  'active',
  '30-44',
  'Knee recovery',
  now(),
  now()
) on conflict (id) do update set
  name = excluded.name,
  email = excluded.email,
  role = 'patient',
  account_status = 'active',
  age_range = '30-44',
  goal = 'Knee recovery',
  updated_at = now();


-- ── 5. PUBLIC EXERCISES WITH TRACKING_CONFIG ────────────────────────────────

-- Mini Squat
insert into public.exercises (
  id, course_id, order_num, name, target_reps, target_sets, rest_seconds,
  joints, steps, watch_out_for, what_it_helps,
  tracking_type, camera_view, tracking_config, is_public, is_tested, created_at
) values (
  'ex_mini_squat',
  'course_knee_rehab',
  1,
  'Mini Squat',
  10,
  3,
  45,
  '{"Knee"}',
  '{"Stand with feet shoulder-width apart", "Bend knees slowly to about 30-45 degrees", "Pause for a second", "Rise slowly to standing position"}',
  '{"Do not let your knees cave inwards", "Keep your back straight and chest lifted"}',
  'Strengthens quadriceps, hamstrings, and gluteal muscles supporting the knee joint.',
  'rep',
  'side',
  '{"joint": "knee", "type": "rep", "start_angle": 170.0, "target_angle": 135.0, "tolerance": 15.0, "landmarks": {"left": [23, 25, 27], "right": [24, 26, 28]}}'::jsonb,
  true,
  true,
  now()
) on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps,
  tracking_type = excluded.tracking_type,
  camera_view = excluded.camera_view,
  tracking_config = excluded.tracking_config,
  is_public = excluded.is_public,
  is_tested = excluded.is_tested;

-- Straight-Leg Raise
insert into public.exercises (
  id, course_id, order_num, name, target_reps, target_sets, rest_seconds,
  joints, steps, watch_out_for, what_it_helps,
  tracking_type, camera_view, tracking_config, is_public, is_tested, created_at
) values (
  'ex_straight_leg_raise',
  'course_knee_rehab',
  2,
  'Straight-Leg Raise',
  12,
  2,
  30,
  '{"Hip", "Knee"}',
  '{"Lie on your back with one leg bent and one leg straight", "Tighten the thigh muscle of the straight leg", "Slowly lift the leg about 12 inches off the floor", "Hold for 2 seconds and slowly lower"}',
  '{"Keep the knee completely straight", "Do not arch your lower back"}',
  'Improves quadriceps strength without putting pressure on the knee joint.',
  'rep',
  'side',
  '{"joint": "hip", "type": "rep", "start_angle": 180.0, "target_angle": 140.0, "tolerance": 10.0, "landmarks": {"left": [11, 23, 25], "right": [12, 24, 26]}}'::jsonb,
  true,
  true,
  now()
) on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps,
  tracking_type = excluded.tracking_type,
  camera_view = excluded.camera_view,
  tracking_config = excluded.tracking_config,
  is_public = excluded.is_public,
  is_tested = excluded.is_tested;

-- Wall Sit Hold
insert into public.exercises (
  id, course_id, order_num, name, target_reps, target_sets, rest_seconds,
  joints, steps, watch_out_for, what_it_helps,
  tracking_type, camera_view, tracking_config, is_public, is_tested, created_at
) values (
  'ex_wall_sit_hold',
  'course_knee_rehab',
  3,
  'Wall Sit hold',
  3,
  1,
  60,
  '{"Knee", "Hip"}',
  '{"Lean your back flat against a wall", "Slide down until knees are bent to approximately 90 degrees", "Hold position steadily", "Slide back up slowly"}',
  '{"Do not slide down past 90 degrees", "Knees should remain over ankles, not past toes"}',
  'Isometric quadriceps endurance and stability.',
  'hold',
  'side',
  '{"joint": "knee", "type": "hold", "min_angle": 80.0, "max_angle": 100.0, "hold_seconds": 30, "grace_seconds": 2, "landmarks": {"left": [23, 25, 27], "right": [24, 26, 28]}}'::jsonb,
  true,
  true,
  now()
) on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps,
  tracking_type = excluded.tracking_type,
  camera_view = excluded.camera_view,
  tracking_config = excluded.tracking_config,
  is_public = excluded.is_public,
  is_tested = excluded.is_tested;

-- Warrior II Hold (Yoga)
insert into public.exercises (
  id, course_id, order_num, name, target_reps, target_sets, rest_seconds,
  joints, steps, watch_out_for, what_it_helps,
  tracking_type, camera_view, tracking_config, is_public, is_tested, created_at
) values (
  'ex_warrior_2',
  'course_wellness_yoga',
  1,
  'Warrior II hold',
  3,
  1,
  45,
  '{"Knee", "Shoulder"}',
  '{"Step feet wide apart", "Turn right foot out 90 degrees and bend right knee", "Extend arms parallel to floor", "Hold steadily"}',
  '{"Keep torso upright, not leaning forward", "Front knee stays aligned over ankle"}',
  'Builds leg strength, hip flexibility and upper body alignment.',
  'hold',
  'front',
  '{"joint": "knee", "type": "hold", "min_angle": 85.0, "max_angle": 105.0, "hold_seconds": 20, "grace_seconds": 2, "landmarks": {"left": [23, 25, 27], "right": [24, 26, 28]}}'::jsonb,
  true,
  true,
  now()
) on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps,
  tracking_type = excluded.tracking_type,
  camera_view = excluded.camera_view,
  tracking_config = excluded.tracking_config,
  is_public = excluded.is_public,
  is_tested = excluded.is_tested;


-- ── 6. SAMPLE AUDIT ENTRIES ─────────────────────────────────────────────────

insert into public.audit_log (id, actor_id, action, target_type, target_id, details, created_at)
values (
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000001',
  'approve_doctor',
  'doctor_application',
  '00000000-0000-0000-0000-000000000002',
  '{"doctor_name": "Dr. Sara Khan", "license": "PMDC-48213", "decision": "approved"}'::jsonb,
  now() - interval '2 days'
) on conflict (id) do nothing;
