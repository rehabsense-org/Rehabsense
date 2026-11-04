-- ============================================================================
-- REHABSENSE v2 SEED DATA
-- Test users, initial public exercises with tracking_config, and demo doctor
-- ============================================================================

-- ── 1. TEST USERS IN PROFILES ───────────────────────────────────────────────

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
) on conflict (id) do nothing;

-- Verified Doctor User: Dr. Sara Khan
insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000002',
  'Dr. Sara Khan',
  'sara.khan@clinic.test',
  'doctor',
  'active',
  now(),
  now()
) on conflict (id) do nothing;

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
) on conflict (id) do nothing;

-- Second Verified Doctor: Dr. Omar Sheikh
insert into public.profiles (id, name, email, role, account_status, created_at, updated_at)
values (
  '00000000-0000-0000-0000-000000000003',
  'Dr. Omar Sheikh',
  'omar.sheikh@sports.test',
  'doctor',
  'active',
  now(),
  now()
) on conflict (id) do nothing;

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
) on conflict (id) do nothing;

-- Sample Patient User: Alex Morgan
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
) on conflict (id) do nothing;


-- ── 2. PUBLIC EXERCISES WITH TRACKING_CONFIG ────────────────────────────────

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
  tracking_type = excluded.tracking_type,
  camera_view = excluded.camera_view,
  tracking_config = excluded.tracking_config,
  is_public = excluded.is_public,
  is_tested = excluded.is_tested;


-- ── 3. SAMPLE AUDIT ENTRIES ─────────────────────────────────────────────────

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

