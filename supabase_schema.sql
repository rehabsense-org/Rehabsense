-- ============================================================================
-- REHABSENSE SUPABASE DATABASE SCHEMA
-- Single source of truth for tables, foreign keys, RLS policies, triggers,
-- and seed data for courses and exercises.
-- ============================================================================

-- ── 1. PROFILES (Extends auth.users) ────────────────────────────────────────
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text,
  email text,
  age_range text,
  goal text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table public.profiles enable row level security;

-- Policies for profiles
create policy "Users can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Users can insert their own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Trigger to automatically create a profile row when a new user signs up via auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, email, created_at, updated_at)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)),
    new.email,
    now(),
    now()
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- ── 2. PREFERENCES ──────────────────────────────────────────────────────────
create table if not exists public.preferences (
  user_id uuid references auth.users on delete cascade primary key,
  audio boolean default true not null,
  haptics boolean default true not null,
  show_skeleton boolean default true not null,
  reminders_enabled boolean default false not null,
  reminder_time text default '09:00',
  reminder_days integer[] default '{1, 3, 5}',
  weekly_summary boolean default true not null,
  tips boolean default true not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.preferences enable row level security;

create policy "Users can view their own preferences"
  on public.preferences for select
  using (auth.uid() = user_id);

create policy "Users can insert/update their own preferences"
  on public.preferences for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- ── 3. COURSES ──────────────────────────────────────────────────────────────
create table if not exists public.courses (
  id text primary key,
  name text not null,
  description text not null,
  level text default 'Beginner' not null,
  icon text default 'activity' not null,
  exercise_ids text[] default '{}' not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.courses enable row level security;

create policy "Courses are readable by all authenticated users"
  on public.courses for select
  to authenticated
  using (true);

create policy "Courses are readable by anon users"
  on public.courses for select
  to anon
  using (true);


-- ── 4. EXERCISES ────────────────────────────────────────────────────────────
create table if not exists public.exercises (
  id text primary key,
  course_id text references public.courses on delete cascade not null,
  order_num integer not null,
  name text not null,
  target_reps integer default 10 not null,
  target_sets integer default 2 not null,
  rest_seconds integer default 30 not null,
  joints text[] default '{}' not null,
  steps text[] default '{}' not null,
  watch_out_for text[] default '{}' not null,
  what_it_helps text not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.exercises enable row level security;

create policy "Exercises are readable by all users"
  on public.exercises for select
  to authenticated, anon
  using (true);


-- ── 5. SESSIONS ─────────────────────────────────────────────────────────────
create table if not exists public.sessions (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  exercise_id text references public.exercises not null,
  started_at timestamp with time zone default timezone('utc'::text, now()) not null,
  ended_at timestamp with time zone,
  status text default 'saved' not null, -- 'draft', 'saved', 'interrupted'
  score integer default 0 not null,
  duration_seconds integer default 0 not null,
  avg_rom double precision,
  tempo double precision,
  symmetry double precision,
  sync_state text default 'synced' not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.sessions enable row level security;

create policy "Users can manage their own sessions"
  on public.sessions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- ── 6. REPETITIONS ──────────────────────────────────────────────────────────
create table if not exists public.reps (
  id uuid default gen_random_uuid() primary key,
  session_id text references public.sessions on delete cascade not null,
  rep_index integer not null,
  outcome text not null, -- 'correct', 'incorrect', 'incomplete'
  peak_angle double precision,
  duration_ms integer not null,
  feedback_key text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.reps enable row level security;

create policy "Users can manage reps of their sessions"
  on public.reps for all
  using (
    exists (
      select 1 from public.sessions
      where sessions.id = reps.session_id
      and sessions.user_id = auth.uid()
    )
  );


-- ── 7. NOTIFICATIONS ────────────────────────────────────────────────────────
create table if not exists public.notifications (
  id text primary key,
  user_id uuid references auth.users on delete cascade not null,
  type text not null, -- 'reminder', 'milestone', 'tip'
  title text not null,
  body text not null,
  read boolean default false not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.notifications enable row level security;

create policy "Users can view and update their own notifications"
  on public.notifications for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);


-- ============================================================================
-- SEED DATA (Courses & Exercises)
-- ============================================================================

-- Courses
insert into public.courses (id, name, description, level, icon, exercise_ids)
values
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


-- Knee Exercises
insert into public.exercises (id, course_id, order_num, name, target_reps, target_sets, rest_seconds, joints, steps, watchOutFor, what_it_helps)
values
(
  'knee_mini_squat',
  'knee_rehab',
  1,
  'Mini Squat',
  10,
  2,
  30,
  array['left_knee', 'right_knee', 'left_hip', 'right_hip'],
  array[
    'Stand with feet shoulder-width apart, holding a stable support if needed.',
    'Slowly bend your knees to roughly 30–45 degrees as if sitting back.',
    'Keep your back straight and knees pointing over your toes.',
    'Hold for 2 seconds, then smoothly return to standing.'
  ],
  array[
    'Do not let your knees collapse inwards.',
    'Never bend so deeply that you feel sharp pain.'
  ],
  'Strengthens the quadriceps and gluteal muscles while protecting the patellofemoral joint.'
),
(
  'knee_straight_leg_raise',
  'knee_rehab',
  2,
  'Straight-Leg Raise',
  10,
  2,
  30,
  array['left_hip', 'right_hip', 'left_knee', 'right_knee'],
  array[
    'Lie flat on your back with one leg bent and one leg straight.',
    'Engage your quadriceps on the straight leg and flex your foot.',
    'Raise the leg smoothly to roughly 45 degrees, level with the opposite knee.',
    'Hold for 1–2 seconds, then lower under control.'
  ],
  array[
    'Keep the knee completely straight throughout the lift.',
    'Do not arch your lower back off the surface.'
  ],
  'Builds quadriceps strength without placing compressive stress on the knee joint.'
),
(
  'knee_seated_extension',
  'knee_rehab',
  3,
  'Seated Knee Extension',
  10,
  2,
  30,
  array['left_knee', 'right_knee'],
  array[
    'Sit tall in a firm chair with thighs supported and feet flat.',
    'Slowly straighten one knee until the leg is fully extended.',
    'Squeeze the quadriceps at the top of the movement for 2 seconds.',
    'Lower the foot smoothly back to the floor.'
  ],
  array[
    'Avoid swinging or using momentum to lift the leg.',
    'Keep your torso upright without leaning back.'
  ],
  'Targets terminal knee extension and activates the vastus medialis obliquus (VMO).'
),
(
  'knee_heel_slide',
  'knee_rehab',
  4,
  'Heel Slide',
  10,
  2,
  30,
  array['left_knee', 'right_knee', 'left_hip', 'right_hip'],
  array[
    'Lie on your back with both legs extended.',
    'Slowly slide one heel along the surface towards your buttocks.',
    'Bend the knee as far as comfortably possible without sharp pain.',
    'Hold for 3 seconds, then slide back out under control.'
  ],
  array[
    'Keep the movement slow and continuous.',
    'Stop at the point of firm resistance or discomfort.'
  ],
  'Restores knee flexion range of motion and mobility following surgery or prolonged rest.'
),
(
  'knee_step_up',
  'knee_rehab',
  5,
  'Step-Up',
  10,
  2,
  30,
  array['left_knee', 'right_knee', 'left_hip', 'right_hip'],
  array[
    'Stand facing a low, stable step or platform (10–15 cm).',
    'Step up with the target leg, placing the entire foot on the step.',
    'Straighten the knee to bring your body up; lightly tap the other foot.',
    'Step back down under control, leading with the non-target foot.'
  ],
  array[
    'Ensure the knee tracks directly over your second toe.',
    'Do not push off forcefully with the trailing foot.'
  ],
  'Develops functional lower-limb power, balance and eccentric control.'
)
on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps;


-- Shoulder Exercises
insert into public.exercises (id, course_id, order_num, name, target_reps, target_sets, rest_seconds, joints, steps, watchOutFor, what_it_helps)
values
(
  'shoulder_pendulum_swing',
  'shoulder_mobility',
  1,
  'Pendulum Swing',
  10,
  2,
  30,
  array['left_shoulder', 'right_shoulder'],
  array[
    'Lean forward from the waist, resting your unaffected arm on a table.',
    'Let the affected arm dangle freely toward the floor like a pendulum.',
    'Gently sway your body to initiate small circular motions of the arm.',
    'Allow gravity and body momentum to move the arm without active shoulder muscle effort.'
  ],
  array[
    'Do not actively swing using shoulder muscles; let momentum do the work.',
    'Keep your neck and back relaxed.'
  ],
  'Decompresses the glenohumeral joint and provides gentle passive range of motion.'
),
(
  'shoulder_flexion',
  'shoulder_mobility',
  2,
  'Shoulder Flexion',
  10,
  2,
  30,
  array['left_shoulder', 'right_shoulder', 'left_elbow', 'right_elbow'],
  array[
    'Stand upright with arms resting at your sides.',
    'Slowly raise the affected arm straight out in front of you and upward.',
    'Reach as high as comfortably possible without shrugging the shoulder.',
    'Pause briefly at the peak, then lower smoothly under control.'
  ],
  array[
    'Do not arch your back to gain extra height.',
    'Keep your shoulder blade down and relaxed.'
  ],
  'Restores forward overhead reach and mobilises the anterior shoulder capsule.'
),
(
  'shoulder_external_rotation',
  'shoulder_mobility',
  3,
  'External Rotation',
  10,
  2,
  30,
  array['left_shoulder', 'right_shoulder', 'left_elbow', 'right_elbow'],
  array[
    'Stand tall with your elbow bent at 90 degrees and tucked close to your side.',
    'Keep the elbow pinned to your ribcage.',
    'Slowly rotate the forearm outwards away from your body.',
    'Hold the end range for 2 seconds, then return to the starting position.'
  ],
  array[
    'Do not let your elbow drift away from your side.',
    'Avoid twisting your spine to achieve greater range.'
  ],
  'Strengthens the infraspinatus and teres minor to enhance rotator cuff stability.'
),
(
  'shoulder_wall_slide',
  'shoulder_mobility',
  4,
  'Wall Slide',
  10,
  2,
  30,
  array['left_shoulder', 'right_shoulder', 'left_elbow', 'right_elbow'],
  array[
    'Stand facing a wall with forearms resting vertically against it at shoulder height.',
    'Slowly slide your forearms upward along the wall.',
    'Ascend into a comfortable stretch without hiking your shoulders.',
    'Slide down under control back to the starting point.'
  ],
  array[
    'Maintain light forearm contact with the wall throughout.',
    'Stop before your shoulders shrug upwards towards your ears.'
  ],
  'Promotes healthy scapulothoracic upward rotation and serratus anterior activation.'
),
(
  'shoulder_scapular_squeeze',
  'shoulder_mobility',
  5,
  'Scapular Squeeze',
  10,
  2,
  30,
  array['left_shoulder', 'right_shoulder'],
  array[
    'Sit or stand tall with arms relaxed at your sides.',
    'Draw your shoulder blades backward and downward as if pinching a pencil.',
    'Hold the squeeze firmly for 5 seconds while breathing normally.',
    'Release smoothly to the neutral resting posture.'
  ],
  array[
    'Do not shrug your shoulders toward your ears during the squeeze.',
    'Keep your chin slightly tucked and head upright.'
  ],
  'Strengthens middle and lower trapezius, improving posture and reducing impingement.'
)
on conflict (id) do update set
  course_id = excluded.course_id,
  order_num = excluded.order_num,
  name = excluded.name,
  target_reps = excluded.target_reps,
  target_sets = excluded.target_sets,
  rest_seconds = excluded.rest_seconds,
  joints = excluded.joints,
  steps = excluded.steps,
  watch_out_for = excluded.watch_out_for,
  what_it_helps = excluded.what_it_helps;
