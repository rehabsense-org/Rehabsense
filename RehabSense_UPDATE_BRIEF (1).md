# RehabSense: UPDATE BRIEF v2 (Delta Document for AI Agents)

> **Read this first, before touching any code.**
> This file does NOT describe the whole project. It describes only **what is new or changed** on top of the work that already exists.
> Existing work: `PROJECT_HANDOFF.md`. New work: `SYSTEM_OVERVIEW.md`, `PATIENT_PORTAL.md`, `DOCTOR_PORTAL.md`, `ADMIN_PORTAL.md`.
> v2 completes v1: it fixes contradictions between the files, adds the missing data model and app-structure items, and lists the decisions still open (section 13). Full change list is in section 14.

---

## 0. The golden rules (never break these)

1. **Do not redo finished work.** Every item marked `DONE / KEEP` already exists. Do not rewrite, rename, move or "clean up" it.
2. **Verify before you build.** For every item in this brief, first search the repository and check if it already exists (file, route, widget, table, policy, function).
3. **Patch, do not replace.** `CHANGED` items get a minimal patch. Keep the public API of widgets, repositories and routes unless this brief says otherwise.
4. **Build only what is `NEW`** (or `MISSING` after your check).
5. **If this brief and the code disagree, the code wins for what exists today; this brief wins for what must exist after the update.** Report every disagreement; do not silently pick one.
6. **Never invent design values.** Colors, fonts, spacing, radius and component props come only from `PROJECT_HANDOFF.md` section 6 (`lib/core/tokens.dart`, `lib/core/widgets/`). No hardcoded hex outside `tokens.dart`.
7. **One email, one role.** Roles are never read from client-supplied metadata (`SYSTEM_OVERVIEW.md` section 7).
8. **Soft delete only.** Hard delete is manual SQL.
9. **Superseded handoff parts.** `PROJECT_HANDOFF.md` sections 9.2 and 13 were an early plan. Where they contradict `SYSTEM_OVERVIEW.md`, the overview wins. Section 1.1 lists every case.
10. **No video, no images stored, for anyone** (patient or doctor). Product Rule 4 stays. The doctor demo video idea in handoff 13.4 is dropped.

---

## 1. Source-of-truth order

| Priority | File | Use it for |
|---|---|---|
| 1 | The actual repository code | What really exists right now |
| 2 | `PROJECT_HANDOFF.md` (except the parts in 1.1) | Baseline: stack, tokens, widgets, existing screens, existing data layer |
| 3 | `SYSTEM_OVERVIEW.md` | Final decisions, status model, state machines, data model, security, phases, tests |
| 4 | `PATIENT_PORTAL.md`, `DOCTOR_PORTAL.md`, `ADMIN_PORTAL.md` | Screen lists, flows, failure paths per portal |
| 5 | This brief | The delta, status labels, checking protocol, open decisions |

### 1.1 Parts of PROJECT_HANDOFF that are superseded

| Handoff item | Old plan | Now (use this) |
|---|---|---|
| 9.2, 13.5: `handle_new_user()` records role from signup metadata | Role from `raw_user_meta_data` | Trigger always inserts `patient`. Doctor role is set only by Edge Function `register-doctor`. Admin by SQL |
| 13.2: router redirect to `/doctor/dashboard` | Simple role redirect | Route is `/doctor/home`. Redirect is the **Login Gate** (`SYSTEM_OVERVIEW.md` section 3) |
| 13.2: `RSExercise.videoUrl`, `jointThresholds` | Video and thresholds fields | Not used. Use `tracking_config` + `camera_view`. No video |
| 13.3: doctor module with `courses/` editor and `recording/` | Doctor records exercises on camera, builds courses | Replaced by Exercise Builder (4 steps) + Test on camera. No recording, no course editor |
| 13.5: `course_assignments` | Doctor assigns courses | Replaced by `assignments` (doctor assigns exercises) |
| 13.5: `doctor_patients` with composite primary key, no status | Simple link | `id` primary key, `status` (`active`, `ended`), `ended_at`, and a unique index that allows only one `active` row per patient |
| 13.5: doctor policies on `sessions` and `reps` check only that a `doctor_patients` row exists | Link exists | Use `is_linked_doctor()` (link is `active` and doctor is approved and active) |
| 8.2: `courses` and `exercises` readable by everyone (`using (true)`) | Public read | `exercises` read becomes visibility-based: private exercises are visible only to the author, admins, and patients who have an assignment for it |
| 8.2: `exercises.course_id`, `order_num` | Every exercise belongs to a course | Make both nullable (doctor-private exercises have no course) |
| 9.1 and screen 37 (Delete Account dialog) | `deleteAccount()` hard-deletes the `profiles` row | Soft only (decision D-04) |
| `SYSTEM_OVERVIEW.md` decision 7: "same OTP-code flow the app already uses" | Says OTP exists | **No OTP flow exists.** Handoff screen 31 is a mock link-style screen ("I've verified my email" with an 800 ms fake delay). OTP is `NEW` for patient and doctor |
| `SYSTEM_OVERVIEW.md` section 4.1 diagram: `approved -> suspended` | Suspension as an application status | Suspension is `profiles.account_status = disabled` (+ auth ban). `doctor_applications.status` stays `approved`. The status table in section 4 is correct |

---

## 2. Mandatory pre-check protocol (do this BEFORE writing code)

Run these steps and **output a Reconciliation Table first**. Only then start implementing.

1. List the repo: `lib/features/*`, `lib/app/router.dart`, `lib/app/shell_scaffold.dart`, `lib/core/tokens.dart`, `lib/core/widgets/*`, `lib/domain/*`, `lib/data/repositories/*`, `supabase_schema.sql`, `supabase/functions/*`, `pubspec.yaml`, `android/app/build.gradle.kts` (applicationId).
2. For each row in sections 4 to 8, search for the screen file, route, repository method, table, policy, function or widget.
3. IDs: screens use `P-`, `D-`, `A-` IDs from the portal files. Backend rows use `B-` IDs (section 7). App-structure rows use `S-` IDs (section 8).
4. Assign one status per row:

| Status | Meaning | Action |
|---|---|---|
| `DONE / KEEP` | Exists and works as the handoff says | Do nothing |
| `PARTIAL` | Exists but is a stub or uses mock data | Finish only the missing part |
| `CHANGED` | Exists, and this brief asks for a specific change | Minimal patch, keep API |
| `NEW` | Does not exist | Build it |
| `CONFLICT` | Code and docs disagree | Do not change; list it in the report and ask |

5. Output format of the Reconciliation Table:

```
| ID | Item | Found at (path or "not found") | Status | Planned action |
```

6. Wait for confirmation if there is any `CONFLICT` or any open decision (section 13) that blocks the current phase. Otherwise continue with the stated default, one phase at a time (section 10).
7. After each phase run `flutter analyze` and `flutter test`. Existing tests must still pass. If a test breaks, the change was wrong: fix the change, not the test. (The repo currently has only 1 widget test, so add tests for new logic: Login Gate, tracking config, status routing.)

---

## 3. What already exists (summary, do not rebuild)

From `PROJECT_HANDOFF.md`:

- Flutter app, `go_router` with `StatefulShellRoute.indexedStack` (4 tabs: Home, Courses, Progress, Profile).
- Supabase auth (sign up, sign in, sign out, password recovery). No roles, no doctor flows.
- Design system in `lib/core/tokens.dart` (`RSColors`, `RSText`, `RSSpacing`, `RSRadius`, `RSSizes`) and 15 widgets in `lib/core/widgets/`: `RSButton`, `RSIconButton`, `RSCard`, `RSInput`, `RSStatusChip`, `RSScoreRing`, `RSProgressBar`, `RSSegmentedControl`, `RSStatTile`, `RSMenuCard`, `RSDialog`, `RSEmptyState`, `RSSkeletonBlock`, `RSBanner`, `RSLogo`.
- Inter via `google_fonts`. Icons: `lucide_icons`. Baseline frame 360 x 800. `shared_preferences` is already a dependency.
- On-device pose tracking (MediaPipe), 8 joint angles, knee-angle rep state machine, rep outcomes (Correct, Incorrect, Incomplete), session saving.
- In-memory repositories (`CourseRepository`, `SessionRepository`, `UserRepository`, `NotificationRepository`) with seed data (2 courses, 10 exercises, 4 sessions, 6 notifications). `AuthRepository` is the only one wired to Supabase.
- `supabase_schema.sql` has 7 tables (`profiles`, `preferences`, `courses`, `exercises`, `sessions`, `reps`, `notifications`) with RLS, not wired to the client. No storage buckets.
- Known debt that this update must handle: Supabase URL and key are hardcoded in `lib/core/supabase_config.dart`; live tracking hardcodes the knee joint (index 25/26).
- 44 patient screens (handoff section 4), including dialogs and sheets (18, 36, 37, 42, 43), skeleton 39b and empty state 39a.

**All of the above is `DONE / KEEP` unless a row below says `CHANGED`.**

---

## 4. PATIENT portal delta

Mapping: new ID (`PATIENT_PORTAL.md`) to handoff screen code (`PROJECT_HANDOFF.md`).

### 4.1 Existing screens

| New ID | Screen | Handoff code | Status | What to do |
|---|---|---|---|---|
| P-01 | Splash | 01 | `CHANGED` | Run the Login Gate (session check, role, status) instead of the hardcoded redirect to `/welcome` |
| P-02 | Welcome | 02 | `CHANGED` | Add a small "I am a Doctor" link and a tiny "Staff login" link. Patient buttons stay |
| P-03 | Login | 03 | `CHANGED` (logic only) | After auth, run the Login Gate: role mismatch signs out; the Supabase "user is banned" error maps to the P-52 inactive-account message. UI unchanged |
| P-04 | Register | 04 | `DONE / KEEP` | Patient only. Reject emails already used as doctor (see D-06 for how) |
| P-05 | Verify Email | 31 | `CHANGED` | Handoff shows a mock link-style screen. Replace with a real 6-digit OTP entry (`verifyOtp`), 60 s resend cooldown, expired/wrong code errors, "Change email". Needs `RSOtpField` and the Supabase email template with the code. If the code already contains a real OTP flow, keep it and report it |
| P-06 / P-07 | Forgot / Reset password | 05 / 06 | `DONE / KEEP` | Reset is `PARTIAL` (mock). Finish only if not wired |
| P-08 | Profile Setup | 07 | `DONE / KEEP` | Mock-data part stays until phase 1. Completion is stored in `profiles.onboarded_at` (not on device) |
| P-09 | Safety Consent | 08 | `DONE / KEEP` | Keep the code's route (`/setup/safety`) |
| P-10 | Camera Help | 32 | `DONE / KEEP` | |
| P-11 | Home | 09 | `CHANGED` | Add the **Prescribed container** with 6 states (locked, request pending, connected-empty, connected-assigned, doctor inactive, loading/error). Rest of Home stays |
| P-12 | Courses | 10 | `CHANGED` | **3 segments**: Wellness and Yoga, Rehab, Prescribed (locked until doctor connected) |
| P-13 | Course Detail | 11 | `DONE / KEEP` | |
| P-14 | Exercise Detail | 13 | `DONE / KEEP` | |
| P-15 | Checklist | 14 | `DONE / KEEP` | |
| P-16 | Camera Setup | 15 | `CHANGED` (small) | Show the exercise camera view instruction: **Side** or **Front** |
| P-17 | Live Tracking | 16 | `CHANGED` (big) | **Config-based** tracking from `exercises.tracking_config`: types **rep** and **hold**, 2D angles only. The current knee squat behaviour becomes the first config and must keep working. Invalid config shows "This exercise is not ready for tracking". No video stored |
| P-18 | Pause | 17 | `DONE / KEEP` | |
| P-19 | Summary | 19 | `CHANGED` | For prescribed sessions add pain slider (0 to 10) and optional comment (stored in `sessions.pain_level`, `sessions.pain_comment`). Pain 8 or more shows the safety message (D-01) |
| P-20 / P-21 / P-22 | Saved / Camera Error / Sync Error | 35 / 33 / 34 | `DONE / KEEP` | |
| P-23 / P-24 / P-25 | Progress / Exercise Progress / History | 20 / 21 / 22 | `DONE / KEEP` | Dashboard still has stub data: finish in phase 1 migration |
| P-26 | Session Details | 23 | `CHANGED` | Add the **Doctor feedback card** (only if feedback exists) |
| P-27 | Notification Inbox | 41 | `CHANGED` | Add new notification types and deep links (4.3). Keep the code's route (`/home/notifications`) |
| P-28 | Profile | 24 | `CHANGED` | Add **My Doctor** row (or "Connect with Doctor") and **My Condition** row |
| P-29 to P-35 | Edit Profile, Settings, Change Password, Notification Prefs, Help, Privacy, About | 25, 26, 44, 27, 28, 29, 30 | `DONE / KEEP` | Change Password is `PARTIAL` (mock) |
| P-36 | Logout confirm | 36 | `DONE / KEEP` | Unsynced sessions stay queued (D-09, S-05) |
| (none) | Delete Account dialog | 37 | `CHANGED` | Must become a soft delete (D-04). Today it hard-deletes the profile row |

Not touched: dialogs 18, 42, 43, skeleton 39b, empty 39a. Handoff screens 38 (Interrupted Session) and 40 (Safety Alert Overlay on live tracking) were `NOT IMPLEMENTED` and stay out of scope unless asked. **P-39 Safety Alert (new) is a different screen** (red-flag symptoms in the condition form).

### 4.2 New patient screens

| ID | Screen | Route | Status |
|---|---|---|---|
| P-37 | Connect Hub | `/connect` | `NEW` |
| P-38 | Condition Form (3 steps) | `/connect/condition` | `NEW` |
| P-39 | Safety Alert (sheet) | sheet | `NEW` |
| P-40 | Find Doctors (matched list) | `/connect/doctors` | `NEW` |
| P-41 | Doctor Public Profile | `/connect/doctors/:id` | `NEW` |
| P-42 | Send Request (with consent) | `/connect/doctors/:id/request` | `NEW` |
| P-43 | Request Status | `/connect/status/:rid` | `NEW` |
| P-44 | Connected (celebration) | `/connect/connected` | `NEW` |
| P-45 | Request Declined or Expired | `/connect/result/:rid` | `NEW` |
| P-46 | My Doctor | `/profile/doctor` | `NEW` |
| P-47 | Disconnect Confirm | dialog | `NEW` |
| P-48 | Prescribed List | `/courses/prescribed` | `NEW` |
| P-49 | Prescribed Exercise Detail | `/prescribed/:assignmentId` | `NEW` |
| P-50 | Enter Doctor Code | `/connect/code` | `NEW`, optional (D-07) |
| P-51 | My Condition (view and edit) | `/profile/condition` | `NEW` |
| P-52 | Inactive Account | `/account-inactive` | `NEW` |

Placement: `/connect/*`, `/prescribed/:assignmentId`, `/account-inactive` are root-navigator routes (no bottom bar, like onboarding). `/courses/prescribed` lives in the Courses branch, `/profile/doctor` and `/profile/condition` in the Profile branch.

### 4.3 Notification types to add (P-27)

Request accepted (to P-44), declined or expired (to P-45), new exercise or plan updated (to P-48), doctor feedback (to P-26), doctor not available (to P-37), reminder (to Home). If the target no longer exists show the snackbar "This is no longer available". Each notification stores its target in `notifications.data` (B-04).

### 4.4 Route reconciliation (portal docs vs real code)

The portal files list cleaner routes than the code uses. **Keep the code's routes** (golden rule 3) and use the portal route only for NEW screens.

| Screen | Code route (handoff) | Portal doc route | Use |
|---|---|---|---|
| Safety Consent | `/setup/safety` | `/setup/consent` | code |
| Notification Inbox | `/home/notifications` | `/notifications` | code |
| Checklist, Camera Setup, Live, Pause, Summary, Saved, errors | `/session/:eid/...` | `/session/...` | code. Prescribed sessions add `?assignment=<assignmentId>` |
| Change Password | `/profile/settings/password` | `/profile/change-password` | code |
| Doctor home | `/doctor/dashboard` (handoff 13.2) | `/doctor/home` | portal doc |

go_router note: declare `/courses/prescribed` **before** `/courses/:cid`, or `prescribed` is captured as a course id.

---

## 5. DOCTOR portal delta (everything is `NEW`)

Check first that nothing like it exists (`lib/features/doctor/*`). Handoff section 10.1 says the doctor module is 0% done.

| Group | Screens |
|---|---|
| Gate and onboarding | D-01 Login, D-02 Register Account, D-03 Verify Email (OTP), D-04 Documents, D-05 Review and Submit, D-06 Submitted, D-07 Resume Application, D-08 Rejected, D-09 Inactive, D-10 Forgot, D-11 Reset |
| Profile setup | D-12 Setup wizard (4 steps: Basics, Expertise, About, Availability; draft saved), D-13 Preview and Go Live |
| Main | D-14 Home, D-15 Requests, D-16 Request Detail, D-17 My Patients, D-18 Patient Detail (Overview, Plan, Sessions, Condition), D-19 Assign Exercise (3 steps), D-20 Exercise Library, D-21 Exercise Builder (4 steps), D-22 Test Exercise, D-23 Session Review and Feedback |
| Common | D-25 Notifications, D-26 Profile, D-27 Edit Profile and Expertise, D-28 Update Credentials, D-29 Settings, D-30 Logout |
| Optional (D-07 decision) | D-24 Invite Code |

Bottom nav (own shell, S-02): Home, Patients (Requests badge), Exercises, Profile.

Reuse (from handoff 13.1): `SessionDetailsScreen`, `ExerciseProgressScreen`, `SessionHistoryScreen` widgets and the pose engine (`JointAngleCalculator`, `PostureChecker`, `SkeletonPainter`) for D-18, D-23 and D-22. Extend, do not copy.

Key rules: pending doctor cannot log in (auth ban); doctor exercises are always Private; listed rule = approved + at least 1 expertise tag + bio 30+ characters + clinic + accepting patients; max 3 submissions (D-02); documents PDF/JPG/PNG up to 5 MB; doctor gets an alert when a prescribed session reports pain 7 or more (D-01).

---

## 6. ADMIN portal delta (everything is `NEW`)

| Group | Screens |
|---|---|
| Auth | A-01 Login (no signup; entered from the small "Staff login" link), A-02 Forgot, A-03 Reset |
| Dashboard | A-04 Dashboard |
| Applications | A-05 List (Pending, Rejected, Approved), A-06 Detail, A-07 Document Viewer (60 s signed URL), A-08 Approve dialog, A-09 Reject sheet |
| Doctors | A-10 List, A-11 Detail, A-12 Edit, A-13 Suspend or Reactivate, A-14 Add Doctor (optional) |
| Patients | A-15 List, A-16 Detail (account info only, no health data) |
| Exercises | A-17 Library, A-18 Builder (4 steps, visibility), A-19 Test on camera |
| Common | A-20 Notifications, A-21 Audit Log, A-22 Profile, A-23 Change Password, A-24 Logout, A-25 Blocked or wrong portal |

Bottom nav (own shell, S-02): Dashboard, Doctors, Patients, Exercises, More. Admin accounts are created manually in Supabase (`role = admin` by SQL). Admin must never read patient sessions, pain or condition.

---

## 7. BACKEND delta

Check `supabase_schema.sql` first. Do not duplicate what exists. Use `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` and `CREATE TABLE IF NOT EXISTS`. `SYSTEM_OVERVIEW.md` sections 4, 6, 8, 10 give the diagram-level model only (no SQL). **Phase 1 must start by writing one migration file (`supabase/migrations/..._portals.sql`) from this table**, and report it before running it.

| ID | Area | Items |
|---|---|---|
| B-01 | `profiles` columns | `role`, `account_status`, `onboarded_at`, `archived_at` (soft delete), `last_active_at` (admin A-16). `email` already exists |
| B-02 | `exercises` columns | `author_id`, `category` (rehab, yoga, general), `kind` (rep, hold), `camera_view` (side, front), `tracking_config` (jsonb), `visibility` (public, private), `is_active`, `is_tested` (Tested/Untested badge). Make `course_id`, `order_num` nullable. Existing 10 seed exercises are inserted into the table with a `tracking_config` that reproduces today's behaviour |
| B-03 | `sessions`, `reps` columns | `sessions.assignment_id`, `sessions.pain_level` (0 to 10), `sessions.pain_comment`. Hold exercises: add `reps.hold_seconds` (nullable) so one row can describe one hold attempt (D-12) |
| B-04 | Tables | `doctor_applications` (status, license_number, degree, attempt_count, reject_reason, reviewed_by, reviewed_at, submitted_at, credentials re-review flag for D-28; unique license among non-rejected), `application_documents`, `doctor_profiles` (title, clinic, phone, city, languages, expertise_tags, bio, years_experience, approach, accepting_patients, max_patients default 30, listed), `connection_requests` (condition_snapshot, status, expires_at, decline reason), `doctor_patients` (reshaped, 1.1), `assignments` (exercise_id, sets, reps or hold_seconds, rest, days_of_week, start_date, end_date, note, status), `session_feedback` (text max 500), **`patient_conditions`** (one current row per patient, editable from P-51; D-03), `notifications` (extend: `data` jsonb with target type and id for deep links, `created_at`), `audit_log` (admin, action, target type, target id, before/after summary, time; read-only), optional `invite_codes` (D-07) |
| B-05 | Views | **`doctor_directory`**: approved + listed + accepting doctors only, hides email and phone, supports sort by expertise match. Patients query this view, never `doctor_profiles` |
| B-06 | Security | RLS on every table. Helpers `is_admin()`, `is_approved_doctor()`, `is_linked_doctor()`. Trigger `guard_profile_protected_cols`. `handle_new_user()` always inserts `patient`. Replace the public `exercises` read policy (1.1). Doctor read policies on `sessions`/`reps` use `is_linked_doctor()`. Condition data visible only to the receiving doctor while the request is `pending` or `accepted`, and to the linked doctor for `patient_conditions`. Admin has **no** policy on sessions, reps, conditions, pain. Index `doctor_patients(doctor_id, patient_id)` (handoff 13.6) |
| B-07 | Edge Functions | `register-doctor`, `submit-doctor-application`, `admin-review-doctor`, `admin-set-account-status` (actions: suspend, reactivate, archive; cannot target self), `admin-add-doctor` (optional), `get-document-url`, **`admin-save-exercise`** (create, update, publish, archive, writes audit log), **`admin-edit-doctor`** (A-12 limited fields and listed toggle, writes audit log). The admin checklist says every admin action goes through a function that re-checks `is_admin()`, so these two are required |
| B-08 | RPC | `send_connection_request`, `respond_connection_request`, **`cancel_connection_request`** (patient cancel, needed by P-43), `end_connection`, `create_assignment`. Optional: `generate_invite_code`, `redeem_invite_code` |
| B-09 | Scheduled jobs | `expire_requests` (hourly), `purge_rejected_documents` (daily), **`remind_expiring_requests`** (doctor notified 24 h before expiry), **`flag_inactive_patients`** (no session for 3 days, doctor notification). Use `pg_cron` or scheduled Edge Functions |
| B-10 | Notification events | Full table in `SYSTEM_OVERVIEW.md` section 9. Pain alert to doctor is created by a database trigger on `sessions` insert when `assignment_id` is set and `pain_level >= 7` |
| B-11 | Storage | `doctor-documents` private bucket, signed URLs 60 s, 5 MB, PDF/JPG/PNG, real file-type check on the server. Doctor can write only while `incomplete` or `rejected` |
| B-12 | Auth settings | Custom SMTP; email templates that send the OTP code (`{{ .Token }}`), 6 digits; deep links and redirect URLs; status-based ban and unban of users (service key only inside Edge Functions) |
| B-13 | Live updates | Supabase Realtime on `notifications` and `connection_requests` for status auto-refresh, with a 30 s polling fallback (D-09) |
| B-14 | Backend tests | The 15 mandatory cases (`SYSTEM_OVERVIEW.md` section 13) live as SQL/pgTAP scripts and Edge Function tests under `supabase/tests/`. They are separate from `flutter test`. Phase mapping is in section 10 |

---

## 8. APP STRUCTURE delta

| ID | Item | Status | What to do |
|---|---|---|---|
| S-01 | Folders and models | `NEW` | `lib/features/connect/`, `lib/features/prescribed/`, `lib/features/doctor/`, `lib/features/admin/`. Models: `UserRole`, `AccountStatus`, `DoctorApplication`, `DoctorProfile`, `ConnectionRequest`, `Assignment`, `ConditionForm`, `SessionFeedback`, `TrackingConfig`. Add `role` and `status` to `RSUser` (handoff 13.2) |
| S-02 | Router and shells | `CHANGED` | Add a top-level `redirect` (Login Gate). Keep the patient `ShellScaffold` as is. Add a separate shell for doctor (4 tabs) and admin (5 tabs). Guard `/doctor/*` and `/admin/*` by role |
| S-03 | Repositories | `CHANGED` | Keep method signatures. Add Supabase-backed implementations behind the same interfaces. Add new repositories for connections, assignments, doctor profile, applications, admin |
| S-04 | Tracking engine | `CHANGED` | `TrackingConfig` drives `live_tracking_screen.dart`. Reuse `JointDef` and the angle calculator. Rep state machine from config (start angle, target angle, tolerance). New hold state machine (angle range, hold seconds, grace period). 2D only |
| S-05 | Local drafts and offline queue | `NEW` | Doctor wizard drafts, exercise builder drafts, condition form, and unsynced sessions are kept locally. `shared_preferences` (already installed) is enough for small JSON. Do not add a new database dependency without asking |
| S-06 | Config and package id | `CHANGED` | Move Supabase URL and key to `--dart-define` (handoff 10.5). Fix the final Android `applicationId` before configuring deep links (handoff open question 4) |
| S-07 | New widgets | `NEW` | `RSDoctorCard`, `RSDocumentTile`, `RSStepHeader`, `RSTimeline`, `RSSlider` (pain), `RSOtpField` (OTP does not exist today, so this is needed), and a selectable chip (`RSChoiceChip`) for expertise tags and body areas if `RSStatusChip` cannot be selected. All under `lib/core/widgets/`, tokens only |

---

## 9. Do-not-break list

- `lib/core/tokens.dart` values and names (only add new tokens, never change existing ones).
- Public props of the 15 existing `RS*` widgets.
- Existing route paths (add new ones; do not rename old ones).
- Existing repository method signatures. Add methods and Supabase implementations behind the same interface.
- Camera and pose pipeline: extend through config, do not rewrite.
- Passing tests.

---

## 10. Build phases (one at a time, verify after each)

| Phase | Work | Done when | Backend tests that must pass |
|---|---|---|---|
| 0 | Custom SMTP, OTP email template, final `applicationId`, deep links, `--dart-define` config, storage bucket | Emails (with code) and uploads work | none |
| 1 | Migration file from section 7 (B-01 to B-06, B-12), roles, statuses, guard trigger, RLS helpers, Login Gate, real OTP for patient (P-05), seed exercises and courses into Supabase with `tracking_config`, move patient repositories from seed to Supabase | Foundation; old patient flows still work | 7, 9, 10 |
| 2 | Admin account (SQL), Admin Login, Dashboard shell, admin shell | Admin can enter | none |
| 3 | Doctor register, OTP, documents, submit, ban, admin review (approve, reject) | Doctor onboarding end to end | 1, 2, 3, 4, 5, 6, 8, 11, 14, 15 |
| 4 | Doctor profile setup, `doctor_directory` | Doctors visible to patients | none |
| 5 | Patient condition form, `patient_conditions`, request flow, accept, decline, cancel, expiry | Connection works | 13 |
| 6 | Assign exercise, Prescribed container, pain report, feedback, pain trigger | Core clinical loop | none |
| 7 | Config-based tracking (rep and hold), exercise builder (doctor and admin), `admin-save-exercise`, yoga poses | Doctors and admin can create exercises | none |
| 8 | Admin management screens, suspend and archive flows, audit log | Admin complete | 12 |
| 9 | Polish, empty and error states, offline queue, optional invite codes (if approved), full test pass | Demo ready | all 15 |

---

## 11. Report format (what the AI must send back)

1. The Reconciliation Table (section 2) before any code.
2. A list of `CONFLICT` items with a recommendation, and any open decision (section 13) that blocks the phase.
3. After each phase: files created, files patched, files untouched (confirm that `DONE / KEEP` files were not edited), `flutter analyze` result, `flutter test` result, and the backend tests run (B-14).

---

## 12. Design source for the UI work

- All design values: `PROJECT_HANDOFF.md` section 6 (colors, Inter type scale, spacing, radius, sizes, component catalog).
- Screen designs may be generated with the **RehabSense Figma plugin** (`rehabsense-figma-plugin/`), which marks frames `NEW`, `CHANGED` or `EXISTING`. If that folder is not in the repository, ignore this reference and design from the portal files and tokens (D-10).

---

## 13. Decisions and open questions

Status `OPEN` means the owner has not confirmed yet. Until then, the agent uses the stated default and lists it in its report.

| ID | Topic | Default used | Status |
|---|---|---|---|
| D-01 | Pain thresholds. Patient flow says "pain 8 or more" shows the safety message and alerts the doctor; doctor docs and overview say the doctor is alerted at 7 or more | Patient safety message at 8+. Doctor alert at 7+ | OPEN |
| D-02 | Resubmission count. "3 attempts" and test 4 ("resubmits 4 times, 4th refused") can be read two ways | `attempt_count` counts every submission including the first. Max 3. Test 4 becomes: "the 4th submission is refused" | OPEN |
| D-03 | Where the patient's current condition lives. P-51 lets the patient edit it, but the data model only has `condition_snapshot` on requests | New table `patient_conditions` (one row per patient). The request keeps a snapshot | OPEN |
| D-04 | Patient "Delete account" (screen 37) hard-deletes today, but the rule is soft delete only | Soft: `account_status = disabled`, `archived_at` set, auth ban. Hard delete stays manual SQL | OPEN |
| D-05 | How admin-created public exercises reach patients. Current exercises belong to courses; the builders have no course field | Courses stay as seeded (no course editor). Public exercises appear in the Wellness and Yoga or Rehab segment by `category`, without a course | OPEN |
| D-06 | Email checks at patient signup. Supabase can hide "already registered" (email-enumeration protection), and showing "this email is a doctor account" reveals which emails exist | Show the doc messages only if the project setting allows it; otherwise show a generic message ("check your email") | OPEN |
| D-07 | Doctor invite codes (D-24, P-50) | Out of scope until after phase 9. Hide the "Enter code" buttons until built | OPEN |
| D-08 | Wellness and Yoga content. Today there are only 2 rehab courses and 10 exercises | Segment shows an empty state until phase 7 seeds at least 3 yoga hold poses | OPEN |
| D-09 | Notification delivery | In-app plus email only (no push). Status refresh by Realtime with polling fallback. Sessions queue locally when offline | OPEN |
| D-10 | Does `rehabsense-figma-plugin/` exist? | Treated as absent | OPEN |
| D-11 | Dashboard "failed emails" alert and A-06 "Resend" (no email log table exists) | Resend simply calls the function again. The failed-email alert is deferred | OPEN |
| D-12 | Hold exercise storage | `reps.hold_seconds` (B-03) | OPEN |
| D-13 | Suspension status model | `account_status`, see 1.1 | RESOLVED |
| D-14 | Email OTP exists? | No, it is `NEW` for patient and doctor, see 1.1 | RESOLVED |

---

## 14. Changes from v1

1. Added section 1.1 (handoff parts that are superseded) and golden rules 9 and 10.
2. Resolved the P-05 conflict: no OTP flow exists, it is a mock link screen. `RSOtpField` is now required.
3. Added the route reconciliation table (4.4) and the `/courses/prescribed` ordering note.
4. Added the Delete Account row (screen 37) that conflicted with soft delete.
5. Added missing data model items: `patient_conditions`, `doctor_directory` view, `profiles.archived_at`, `last_active_at`, `exercises.is_tested`, nullable `course_id`, `sessions.pain_comment`, `reps.hold_seconds`, `notifications.data`, re-review flag, exercises read policy.
6. Added missing functions and jobs: `cancel_connection_request`, `admin-save-exercise`, `admin-edit-doctor`, `remind_expiring_requests`, `flag_inactive_patients`, pain trigger.
7. Added section 8 (app structure): separate doctor and admin shells, tracking engine, local drafts, config and package id.
8. Added IDs for backend and app-structure rows so the Reconciliation Table can cover them.
9. Mapped the 15 backend tests to build phases and said where they live.
10. Added section 13 with defaults for every open question.
