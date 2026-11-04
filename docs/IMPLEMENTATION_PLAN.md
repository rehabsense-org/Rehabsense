# RehabSense v2 — Master Implementation Plan

> **Portals:** Patient (Updated) · Doctor (New) · Admin (New)  
> **Package:** `shariq_skeleton` (Flutter 3.41.9 / Dart 3.11.5 / Supabase 2.12.0 / GoRouter 15.1.2)  
> **Status:** STAGE A — PLAN READY. WAITING FOR APPROVAL.  
> **Reference Specifications:**  
> - Baseline: `PROJECT_HANDOFF.md`  
> - System Architecture: `SYSTEM_OVERVIEW.md`  
> - Portal Specifications: `PATIENT_PORTAL.md`, `DOCTOR_PORTAL.md`, `ADMIN_PORTAL.md`  
> - Delta & Checklist: `RehabSense_UPDATE_BRIEF (1).md`  
> - Visual Reference: `rehabsense-figma-plugin/src/*.js` (`patient.js`, `doctor.js`, `admin.js`, `lib.js`)

---

## 1. Executive Summary & Ground Truth Audit

RehabSense is currently an on-device, single-role rehabilitation mobile application designed for patients performing guided exercises (e.g., Mini Squat, Wall Sit, Straight-Leg Raise) using real-time Google ML Kit pose detection.

### 1.1 Scope of Update
This update transforms RehabSense into a **three-portal unified digital healthcare system** in a single Flutter package:
1. **Patient App (Updated):** Retains all 44 existing validated screens and flows while introducing:
   - "Connect with Doctor" request and matching flow (`P-37` to `P-45`).
   - "Prescribed Exercises" container tab and execution (`P-48`, `P-49`).
   - Post-session pain reporting and alert workflows (`P-17`, `P-18`).
   - Patient condition management (`P-51`), doctor profile inspection (`P-46`), and inactive account gates (`P-52`).
   - Soft-delete account process (`P-36`).
2. **Doctor Portal (All NEW):** 30 screens (`D-01` to `D-30`) covering:
   - Registration, credential verification (PMDC / Medical license + Degree), email OTP, and document uploads (`D-01` to `D-08`).
   - Onboarding wizard and public listing preview (`D-12`, `D-13`).
   - Patient request triage, acceptance, and decline sheets (`D-14` to `D-16D`).
   - Patient tracking, adherence metrics, and condition viewer (`D-17`, `D-18`).
   - Exercise assignment dosage, scheduling, and custom exercise builder (`D-19` to `D-22`).
   - Rep-by-rep session breakdown review and clinical feedback (`D-23`).
   - Profile management, notifications, settings, and credential update re-reviews (`D-25` to `D-30`).
3. **Admin Portal (All NEW):** 25 screens (`A-01` to `A-25`) covering:
   - Restricted staff login (no self-signup) and password recovery (`A-01` to `A-03`).
   - Global dashboard metrics, alerts, and pending application queues (`A-04`).
   - Doctor application credential review, signed-URL document inspection, and approve/reject workflows (`A-05` to `A-09`).
   - Doctor management, editing, and suspension/reactivation (`A-10` to `A-14`).
   - Patient account oversight (non-clinical, account status only) (`A-15`, `A-16`).
   - Public exercise library management, builder wizard, and test mode (`A-17` to `A-19`).
   - Notifications, audit log inspection, and admin profile (`A-20` to `A-25`).

### 1.2 Ground Truth Baseline Audit
A thorough pre-implementation scan of the active repository confirms:
- **Flutter Analyzer:** 0 errors, 0 warnings (48 info-level hints regarding Flutter 3.41 deprecations like `Color.withOpacity` and `activeColor`).
- **Tests:** 1 passing smoke test (`test/widget_test.dart`).
- **Android Configuration:** Package ID is `com.example.my_app` in `android/app/build.gradle.kts`.
- **Backend State:** The existing codebase uses `supabase_schema.sql` at the root, with hardcoded anon keys in `lib/core/supabase_config.dart`. Directory `supabase/` does not yet exist.
- **Router State:** `lib/app/router.dart` is structured around a single patient-oriented `StatefulShellRoute.indexedStack` with 4 branches (Home, Courses, Progress, Profile) using `_rootNavigatorKey`.
- **Pose Detection:** `LiveTrackingScreen` hardcodes knee joint landmarks 25 and 26.
- **OTP Screen:** Screen 31 (`verify_email_screen.dart`) is currently a mock timed screen without an interactive OTP pin widget.

---

## 2. Master Reconciliation Table

This reconciliation table cross-references every single item from sections 4, 5, 6, 7, and 8 of `RehabSense_UPDATE_BRIEF (1).md` against the current codebase.

### 2.1 Patient Portal Screens (Section 4)

| Figma ID | Screen Name | Brief Status | Repo Status | Target File Path | Route Path | Technical Action Required |
|---|---|---|---|---|---|---|
| **P-01** | Splash | `CHANGED` | `DONE` | `lib/features/auth/presentation/splash_screen.dart` | `/splash` | Update navigation logic: inspect Supabase session + role to route to `/home`, `/doctor/home`, or `/admin/dashboard`. |
| **P-02** | Welcome | `CHANGED` | `DONE` | `lib/features/auth/presentation/welcome_screen.dart` | `/welcome` | Add "I am a Doctor" button (`/doctor/login`) and secondary "Staff login" link (`/admin/login`). |
| **P-03** | Login | `CHANGED` | `DONE` | `lib/features/auth/presentation/login_screen.dart` | `/login` | Add role gate check: reject doctors/admins attempting patient login; route inactive patients to `/account-inactive`. |
| **P-04** | Register | `KEEP` | `DONE` | `lib/features/auth/presentation/register_screen.dart` | `/register` | Keep existing validation and password rules; route to `/verify-email`. |
| **P-05** | Verify Email (OTP) | `CHANGED` | `PARTIAL` | `lib/features/auth/presentation/verify_email_screen.dart` | `/verify-email` | Replace mock delay with `RSOtpField` (6-digit); integrate Supabase `verifyOTP`. |
| **P-05b** | Verify Email (Error) | `CHANGED` | `NOT STARTED` | `lib/features/auth/presentation/verify_email_screen.dart` | `/verify-email` | Inline error banner for expired/wrong OTP with resend countdown. |
| **P-06** | Forgot Password | `KEEP` | `DONE` | `lib/features/auth/presentation/forgot_password_screen.dart` | `/forgot-password` | Keep existing layout; trigger Supabase `resetPasswordForEmail`. |
| **P-06b**| Forgot Password Sent| `KEEP` | `DONE` | `lib/features/auth/presentation/forgot_password_screen.dart` | `/forgot-password/sent`| State screen showing reset link confirmation. |
| **P-07** | Reset Password | `KEEP` | `DONE` | `lib/features/auth/presentation/reset_password_screen.dart` | `/reset-password` | Update password handler for recovery session tokens. |
| **P-08** | Profile Setup | `KEEP` | `DONE` | `lib/features/onboarding/presentation/profile_setup_screen.dart`| `/onboarding/profile`| Retain 2-step onboarding; save display name and age group to Supabase profile. |
| **P-09** | Safety & Consent | `KEEP` | `DONE` | `lib/features/onboarding/presentation/safety_consent_screen.dart`| `/onboarding/safety` | Retain privacy bullets and disclaimer. |
| **P-10** | Camera Permission | `KEEP` | `DONE` | `lib/features/onboarding/presentation/camera_permission_screen.dart`| `/onboarding/camera`| Handle camera permissions cleanly. |
| **P-11** | Home (Default) | `CHANGED` | `DONE` | `lib/features/home/presentation/home_screen.dart` | `/home` | Support 5 clinical states: (a) No doctor CTA, (b) Pending request pill, (c) Connected doctor banner, (d) Prescribed exercises widget, (e) Inactive doctor warning. |
| **P-12** | Courses | `CHANGED` | `DONE` | `lib/features/courses/presentation/courses_screen.dart` | `/courses` | Add "Prescribed" category segment tab/pill at top navigating to `/courses/prescribed`. |
| **P-13** | Course Detail | `KEEP` | `DONE` | `lib/features/courses/presentation/course_detail_screen.dart` | `/courses/:cid` | Display course exercises and start flow. |
| **P-14** | Exercise Intro | `KEEP` | `DONE` | `lib/features/exercise/presentation/exercise_intro_screen.dart` | `/exercise/:eid/intro` | Show exercise parameters, target joint, and camera positioning instructions. |
| **P-15** | Live Tracking | `CHANGED` | `PARTIAL` | `lib/features/exercise/presentation/live_tracking_screen.dart` | `/exercise/:eid/tracking`| Refactor from hardcoded knee to generic `TrackingEngine` using exercise `tracking_config` & `camera_view`. Log rep-by-rep angle data. |
| **P-16** | Exercise Completed | `KEEP` | `DONE` | `lib/features/exercise/presentation/exercise_completed_screen.dart`| `/exercise/:eid/completed`| Milestone celebration and score breakdown. |
| **P-17** | Session Summary | `CHANGED` | `PARTIAL` | `lib/features/exercise/presentation/session_summary_screen.dart`| `/exercise/:eid/summary`| Add post-session pain rating slider (0-10) and notes field; save to `pain_logs` and `exercise_sessions`. |
| **P-18** | Pain Alert | `CHANGED` | `NOT STARTED` | `lib/features/exercise/presentation/pain_alert_sheet.dart` | modal sheet | Triggered when pain score >= 7: clinical warning, pause advice, auto-flag to connected doctor. |
| **P-19** | Progress Dashboard | `KEEP` | `DONE` | `lib/features/progress/presentation/progress_screen.dart` | `/progress` | Movement score chart, streak tracking, and summary statistics. |
| **P-20** | All Badges | `KEEP` | `DONE` | `lib/features/progress/presentation/all_badges_screen.dart` | `/progress/badges` | Badges grid with unlocked/locked states. |
| **P-21** | Badge Detail | `KEEP` | `DONE` | `lib/features/progress/presentation/badge_detail_screen.dart` | `/progress/badges/:bid`| Modal/page showing milestone achievement. |
| **P-22** | Milestone Reached | `KEEP` | `DONE` | `lib/features/progress/presentation/milestone_reached_screen.dart`| modal | Gold celebration modal. |
| **P-23** | History List | `KEEP` | `DONE` | `lib/features/progress/presentation/history_screen.dart` | `/progress/history` | List of completed sessions. |
| **P-24** | Session Detail | `KEEP` | `DONE` | `lib/features/progress/presentation/session_detail_screen.dart` | `/progress/history/:sid`| Rep-by-rep inspection and feedback viewer if reviewed by doctor. |
| **P-25** | Weekly Summary | `KEEP` | `DONE` | `lib/features/progress/presentation/weekly_summary_screen.dart`| `/progress/weekly` | Aggregate week metrics. |
| **P-26** | Export Data | `KEEP` | `DONE` | `lib/features/progress/presentation/export_data_screen.dart` | `/progress/export` | Download/share progress report. |
| **P-27** | Export Success | `KEEP` | `DONE` | `lib/features/progress/presentation/export_success_screen.dart`| `/progress/export/success`| Confirmation dialog/page. |
| **P-28** | Profile | `CHANGED` | `DONE` | `lib/features/profile/presentation/profile_screen.dart` | `/profile` | Add dynamic doctor options: "Connect with a doctor" (if unlinked), "My Doctor" + "My Condition" (if linked). |
| **P-29** | Edit Profile | `KEEP` | `DONE` | `lib/features/profile/presentation/edit_profile_screen.dart` | `/profile/edit` | Edit display name and age range. |
| **P-30** | Notifications Settings| `KEEP` | `DONE` | `lib/features/profile/presentation/notifications_settings_screen.dart`| `/profile/notifications`| Notification toggle settings. |
| **P-31** | Change Password | `KEEP` | `DONE` | `lib/features/profile/presentation/change_password_screen.dart`| `/profile/change-password`| Update Supabase password. |
| **P-32** | Help & FAQ | `KEEP` | `DONE` | `lib/features/profile/presentation/help_faq_screen.dart` | `/profile/help` | Retain clinical disclaimers and FAQs. |
| **P-33** | Contact Support | `KEEP` | `DONE` | `lib/features/profile/presentation/contact_support_screen.dart`| `/profile/support` | Support ticket/contact view. |
| **P-34** | Privacy & Data | `CHANGED` | `DONE` | `lib/features/profile/presentation/privacy_data_screen.dart` | `/profile/privacy` | Wire "Delete account" button to soft-delete confirmation dialog (`P-36`). |
| **P-35** | Terms & Privacy Policy| `KEEP` | `DONE` | `lib/features/profile/presentation/terms_privacy_screen.dart`| `/profile/terms` | Static terms and privacy view. |
| **P-36** | Delete Account Dialog | `CHANGED` | `PARTIAL` | `lib/features/profile/presentation/delete_account_dialog.dart`| dialog | Update: require typing DELETE; execute soft delete (`profiles.account_status = 'disabled'`, `archived_at = now()`). |
| **P-37** | Connect Hub | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/connect_hub_screen.dart` | `/connect` | Overview of connecting with doctor: steps, privacy reassurance. |
| **P-38** | Condition Form | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/condition_form_wizard.dart` | `/connect/condition` | 3-step wizard: body area, symptoms & pain rating slider, goals & notes. |
| **P-39** | Safety Alert Sheet | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/red_flags_alert_sheet.dart` | modal sheet | Triggered on red flag checkboxes (night pain, fever, fall): caution disclaimer. |
| **P-40** | Find Doctors | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/find_doctors_screen.dart` | `/connect/doctors` | List verified active doctors, filter by body area / expertise, match percentage. |
| **P-41** | Doctor Public Profile | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/doctor_profile_public_screen.dart`| `/connect/doctors/:did`| View doctor bio, title, clinic, experience, and request CTA. |
| **P-42** | Send Request | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/send_request_screen.dart` | `/connect/doctors/:did/request`| Consent checkbox to share condition summary; submit to `doctor_requests`. |
| **P-43** | Request Status | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/request_status_screen.dart` | `/connect/status` | Timeline view of pending doctor request; cancel option. |
| **P-44** | Connected Celebration | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/connected_celebration_screen.dart`| `/connect/success` | Heart celebration screen when doctor accepts. |
| **P-45** | Request Declined | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/request_declined_screen.dart`| `/connect/declined` | Explains decline/expiration; button to choose another doctor. |
| **P-46** | My Doctor | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/my_doctor_screen.dart` | `/my-doctor` | View connected doctor, shortcuts to prescribed exercises, disconnect action. |
| **P-47** | Disconnect Confirm | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/disconnect_confirm_dialog.dart`| dialog | Warns that prescribed exercises will be locked; updates `doctor_patients`. |
| **P-48** | Prescribed List | `NEW` | `NOT STARTED` | `lib/features/courses/presentation/prescribed_courses_screen.dart`| `/courses/prescribed` | List active prescribed exercises assigned by the doctor. |
| **P-49** | Prescribed Detail | `NEW` | `NOT STARTED` | `lib/features/courses/presentation/prescribed_exercise_detail_screen.dart`| `/courses/prescribed/:assignmentId`| Shows doctor's dosage (sets, reps, rest), doctor's note, days, start button. |
| **P-50** | Doctor Code Entry | `DEFERRED` | `NOT STARTED` | `lib/features/connect/presentation/enter_doctor_code_screen.dart`| `/connect/code` | Optional invite code screen. Hidden behind `AppFlags.inviteCodesEnabled = false`. |
| **P-51** | My Condition | `NEW` | `NOT STARTED` | `lib/features/connect/presentation/my_condition_screen.dart` | `/my-condition` | Patient inspects and updates their active symptoms and pain baseline. |
| **P-52** | Inactive Account | `NEW` | `NOT STARTED` | `lib/features/auth/presentation/inactive_account_screen.dart`| `/account-inactive` | Generic blocked message for disabled accounts with support link. |

---

### 2.2 Doctor Portal Screens (Section 5)

| Figma ID | Screen Name | Brief Status | Target File Path | Route Path | Technical Action Required |
|---|---|---|---|---|---|
| **D-01** | Doctor Login | `NEW` | `lib/features/doctor/presentation/auth/doctor_login_screen.dart` | `/doctor/login` | Email/password login with role verification (`doctor`). Rejects patient/admin accounts. |
| **D-02** | Register Account | `NEW` | `lib/features/doctor/presentation/auth/doctor_register_screen.dart` | `/doctor/register` | Step 1: Name, email, password, license number, degree. Submits via `register-doctor` Edge Function. |
| **D-03** | Verify Email (OTP) | `NEW` | `lib/features/doctor/presentation/auth/doctor_otp_screen.dart` | `/doctor/verify-email` | Step 2: 6-digit OTP verification via `RSOtpField`. |
| **D-04** | Documents Upload | `NEW` | `lib/features/doctor/presentation/auth/doctor_documents_screen.dart` | `/doctor/onboarding/documents` | Step 3: Medical license, degree certificate, national ID uploads with file picker & `RSDocumentTile`. |
| **D-05** | Review & Submit | `NEW` | `lib/features/doctor/presentation/auth/doctor_submit_review_screen.dart`| `/doctor/onboarding/review` | Displays summary of submitted info & documents; submits application to `doctor_applications`. |
| **D-06** | Application Submitted | `NEW` | `lib/features/doctor/presentation/auth/doctor_application_submitted_screen.dart`| `/doctor/application-status` | Timeline indicating submission under review (1-3 days). |
| **D-07** | Resume Application | `NEW` | `lib/features/doctor/presentation/auth/doctor_resume_application_screen.dart`| `/doctor/application/resume` | Prompt when doctor logs in with incomplete documents. |
| **D-08** | Application Rejected | `NEW` | `lib/features/doctor/presentation/auth/doctor_application_rejected_screen.dart`| `/doctor/application/rejected` | Displays admin rejection reason; tracks attempts (up to 3); allow resubmission. |
| **D-09** | Inactive Account | `NEW` | `lib/features/doctor/presentation/auth/doctor_inactive_screen.dart` | `/doctor/blocked` | State screen when doctor account is suspended or disabled. |
| **D-10** | Forgot Password | `NEW` | `lib/features/doctor/presentation/auth/doctor_forgot_password_screen.dart`| `/doctor/forgot-password`| Request reset link for doctor email. |
| **D-11** | Reset Password | `NEW` | `lib/features/doctor/presentation/auth/doctor_reset_password_screen.dart`| `/doctor/reset-password` | Set new password for doctor account. |
| **D-12** | Profile Setup Wizard | `NEW` | `lib/features/doctor/presentation/onboarding/doctor_profile_wizard.dart`| `/doctor/onboarding/profile` | 4-step wizard: Basics (title, clinic, city), Expertise tags, Bio (30+ chars), Availability (days, max patients). |
| **D-13** | Preview & Go Live | `NEW` | `lib/features/doctor/presentation/onboarding/doctor_go_live_screen.dart`| `/doctor/onboarding/preview` | Listing checklist validation; sets `doctor_profiles.is_listed = true`. |
| **D-14** | Doctor Home | `NEW` | `lib/features/doctor/presentation/dashboard/doctor_home_screen.dart` | `/doctor/home` | KPI tiles (new requests, active patients, pain alerts, inactive 3d+), priority pain alerts list, quick links. |
| **D-15** | Requests List | `NEW` | `lib/features/doctor/presentation/requests/doctor_requests_screen.dart` | `/doctor/requests` | Segmented tabs: Pending, Accepted, Declined. Expiration badges. |
| **D-16** | Request Detail | `NEW` | `lib/features/doctor/presentation/requests/doctor_request_detail_screen.dart`| `/doctor/requests/:id` | Patient condition summary, intake pain, goals, Accept & Decline actions. |
| **D-16D**| Decline Request Sheet| `NEW` | `lib/features/doctor/presentation/requests/doctor_decline_sheet.dart` | modal sheet | Decline reasons chips + optional clinical note. |
| **D-17** | My Patients | `NEW` | `lib/features/doctor/presentation/patients/doctor_patients_list_screen.dart`| `/doctor/patients` | Search by patient name, filter by Active / Attention Needed / Inactive. |
| **D-18** | Patient Detail: Overview| `NEW`| `lib/features/doctor/presentation/patients/doctor_patient_detail_screen.dart`| `/doctor/patients/:id` | Adherence rate, average movement score, score trend chart, assign exercise CTA. |
| **D-18b**| Patient Detail: Plan | `NEW` | `lib/features/doctor/presentation/patients/doctor_patient_plan_screen.dart`| `/doctor/patients/:id/plan` | Active and completed prescribed exercises, dosages, schedule. |
| **D-18c**| Patient Detail: Sessions| `NEW`| `lib/features/doctor/presentation/patients/doctor_patient_sessions_screen.dart`| `/doctor/patients/:id/sessions`| Session history, movement score, pain rating, review feedback status. |
| **D-18d**| Patient Detail: Condition|`NEW`| `lib/features/doctor/presentation/patients/doctor_patient_condition_screen.dart`| `/doctor/patients/:id/condition`| Diagnosis, baseline pain, medical notes, end connection button. |
| **D-19** | Assign Exercise Wizard | `NEW` | `lib/features/doctor/presentation/assignments/doctor_assign_wizard.dart`| `/doctor/patients/:id/assign`| 3-step wizard: Choose exercise, Dose (sets, reps/hold, rest), Schedule (days, dates, note). |
| **D-20** | Exercise Library | `NEW` | `lib/features/doctor/presentation/exercises/doctor_exercise_library_screen.dart`| `/doctor/exercises` | Search exercises; chips: All, Rehab, Yoga, Mine (private exercises). |
| **D-21** | Exercise Builder Wizard| `NEW` | `lib/features/doctor/presentation/exercises/doctor_exercise_builder_wizard.dart`| `/doctor/exercises/new` | 4-step wizard: Basics (name, category), Tracking (type, camera view), Angles & Hold time, Review (always Private). |
| **D-22** | Test on Camera | `NEW` | `lib/features/doctor/presentation/exercises/doctor_test_camera_screen.dart`| `/doctor/exercises/:id/test` | Live tracking test mode without saving sessions; verify angle math. |
| **D-23** | Session Review & Feedback|`NEW`| `lib/features/doctor/presentation/reviews/doctor_session_review_screen.dart`| `/doctor/sessions/:id/review` | Rep-by-rep angle inspection, pain banner, feedback text entry (500 chars). |
| **D-24** | Invite Code Generator | `DEFERRED`| `lib/features/doctor/presentation/patients/doctor_invite_code_screen.dart`| `/doctor/invite-code` | Deferred per brief section 13. Route hidden behind flag. |
| **D-25** | Doctor Notifications | `NEW` | `lib/features/doctor/presentation/notifications/doctor_notifications_screen.dart`| `/doctor/notifications` | Notifications inbox (requests, pain alerts, inactive patients, admin updates). |
| **D-26** | Doctor Profile | `NEW` | `lib/features/doctor/presentation/profile/doctor_profile_screen.dart` | `/doctor/profile` | Doctor info card, listing status toggle, navigation menu to credentials and settings. |
| **D-27** | Edit Profile & Expertise| `NEW`| `lib/features/doctor/presentation/profile/doctor_edit_profile_screen.dart`| `/doctor/profile/edit` | Edit title, clinic, expertise tags, bio, max patient capacity. |
| **D-28** | Update Credentials | `NEW` | `lib/features/doctor/presentation/profile/doctor_update_credentials_screen.dart`| `/doctor/profile/credentials`| Update license / degree / documents; triggers new review cycle. |
| **D-29** | Doctor Settings | `NEW` | `lib/features/doctor/presentation/profile/doctor_settings_screen.dart`| `/doctor/settings` | Notification alerts (email, pain, inactive) and change password. |
| **D-30** | Doctor Logout Dialog | `NEW` | `lib/features/doctor/presentation/profile/doctor_logout_dialog.dart` | dialog | Confirmation modal returning doctor to `/doctor/login` or `/welcome`. |

---

### 2.3 Admin Portal Screens (Section 6)

| Figma ID | Screen Name | Brief Status | Target File Path | Route Path | Technical Action Required |
|---|---|---|---|---|---|
| **A-01** | Admin Login | `NEW` | `lib/features/admin/presentation/auth/admin_login_screen.dart` | `/admin/login` | Email/password login with role check (`admin`). Rejects non-admin users. No signup link. |
| **A-02** | Forgot Password | `NEW` | `lib/features/admin/presentation/auth/admin_forgot_password_screen.dart`| `/admin/forgot-password`| Send password reset email for admin staff. |
| **A-03** | Reset Password | `NEW` | `lib/features/admin/presentation/auth/admin_reset_password_screen.dart`| `/admin/reset-password` | Set new password for admin account. |
| **A-04** | Admin Dashboard | `NEW` | `lib/features/admin/presentation/dashboard/admin_dashboard_screen.dart`| `/admin/dashboard` | KPI metrics (pending applications, active doctors, total patients, sessions), alerts, recent audit entries. |
| **A-05** | Doctor Applications List| `NEW`| `lib/features/admin/presentation/applications/admin_applications_screen.dart`| `/admin/applications`| Tabs: Pending, Rejected, Approved. View attempt counter. |
| **A-06** | Application Detail | `NEW` | `lib/features/admin/presentation/applications/admin_application_detail_screen.dart`| `/admin/applications/:id`| Candidate info, license, degree, review checklist, Approve / Reject CTAs. |
| **A-07** | Document Viewer | `NEW` | `lib/features/admin/presentation/applications/admin_document_viewer_screen.dart`| `/admin/applications/:id/doc/:docId`| Render PDF/image via 60-second signed URL generated by `get-document-url`. |
| **A-08** | Approve Confirm Dialog | `NEW` | `lib/features/admin/presentation/applications/admin_approve_dialog.dart`| dialog | Confirm approval; triggers `admin-review-doctor` Edge Function, logs audit. |
| **A-09** | Reject Reason Sheet | `NEW` | `lib/features/admin/presentation/applications/admin_reject_sheet.dart`| modal sheet | Mandatory reject reason chips + note; triggers `admin-review-doctor`. |
| **A-10** | Doctors List | `NEW` | `lib/features/admin/presentation/doctors/admin_doctors_list_screen.dart`| `/admin/doctors` | Search doctors by name/license; filters: All, Active, Suspended. |
| **A-11** | Doctor Detail | `NEW` | `lib/features/admin/presentation/doctors/admin_doctor_detail_screen.dart`| `/admin/doctors/:id` | Doctor profile, patient count, exercise count, audit entries, Suspend / Edit CTAs. |
| **A-12** | Edit Doctor | `NEW` | `lib/features/admin/presentation/doctors/admin_edit_doctor_screen.dart`| `/admin/doctors/:id/edit` | Admin modifies title, clinic, expertise, listed toggle; records in audit log. |
| **A-13** | Suspend/Reactivate Dialog|`NEW`| `lib/features/admin/presentation/doctors/admin_suspend_dialog.dart`| dialog | Suspend doctor (auth ban, notify patients) or Reactivate; triggers Edge Function. |
| **A-14** | Add Doctor (Direct Invite)|`NEW`| `lib/features/admin/presentation/doctors/admin_add_doctor_screen.dart`| `/admin/doctors/new` | Optional direct creation of pre-approved doctor with invite email. |
| **A-15** | Patients List | `NEW` | `lib/features/admin/presentation/patients/admin_patients_list_screen.dart`| `/admin/patients` | Account list: name, email, joined date, status. Clinical data is strictly excluded. |
| **A-16** | Patient Detail (Account)| `NEW`| `lib/features/admin/presentation/patients/admin_patient_detail_screen.dart`| `/admin/patients/:id` | Name, email, last active, linked doctor. Disable account action. No clinical data. |
| **A-17** | Exercise Library | `NEW` | `lib/features/admin/presentation/exercises/admin_exercise_library_screen.dart`| `/admin/exercises` | Manage exercises; filters: All, Public, Private, Archived. |
| **A-18** | Exercise Builder Wizard| `NEW` | `lib/features/admin/presentation/exercises/admin_exercise_builder_screen.dart`| `/admin/exercises/new` | 4-step wizard: Basics, Camera & Kind, Tracking config, Review. Can publish as Public. |
| **A-19** | Test on Camera | `NEW` | `lib/features/admin/presentation/exercises/admin_test_camera_screen.dart`| `/admin/exercises/:id/test` | Camera test harness for exercise validation before publishing. |
| **A-20** | Admin Notifications | `NEW` | `lib/features/admin/presentation/notifications/admin_notifications_screen.dart`| `/admin/notifications` | Admin alerts (new submissions, resubmissions, system alerts). |
| **A-21** | Audit Log | `NEW` | `lib/features/admin/presentation/audit/admin_audit_log_screen.dart` | `/admin/audit` | Read-only audit log: actor, action, target, before/after diffs, timestamp. |
| **A-22** | Admin Profile | `NEW` | `lib/features/admin/presentation/profile/admin_profile_screen.dart` | `/admin/profile` | Admin info, security options, logout CTA. |
| **A-23** | Change Password | `NEW` | `lib/features/admin/presentation/profile/admin_change_password_screen.dart`| `/admin/change-password`| Staff password update. |
| **A-24** | Logout Dialog | `NEW` | `lib/features/admin/presentation/profile/admin_logout_dialog.dart` | dialog | Staff logout confirmation; returns to `/welcome`. |
| **A-25** | Blocked / Wrong Portal | `NEW` | `lib/features/admin/presentation/auth/admin_blocked_screen.dart` | `/admin/blocked` | State screen when a patient/doctor account tries accessing `/admin/*`. |

---

### 2.4 Backend Deliverables (Section 7: File Deliverables Only)

| ID | Component / Artifact | Target Path | Purpose & Specifications |
|---|---|---|---|
| **B-01** | Database Migrations | `supabase/migrations/20261103000000_rehabsense_v2_core.sql` | Consolidated migration: creates all new tables (`doctor_profiles`, `doctor_applications`, `doctor_documents`, `doctor_requests`, `doctor_patients`, `assignments`, `pain_logs`, `exercise_feedback`, `audit_log`), enums, indexes, and triggers. |
| **B-02** | Seed Data | `supabase/seed.sql` | Seed scripts for local development: initial admin user, verified demo doctors, exercise presets, and test conditions. |
| **B-03** | Auth Trigger Function | In migration `B-01` | `handle_new_user()` trigger: always assigns role `'patient'` and status `'active'`. Ignores client metadata roles. |
| **B-04** | Edge Function: Register Doctor | `supabase/functions/register-doctor/index.ts` | Creates auth user via service role, writes `profiles (role: 'doctor')`, initializes `doctor_applications`, creates document references. |
| **B-05** | Edge Function: Review Doctor | `supabase/functions/admin-review-doctor/index.ts` | Admin approves/rejects application, updates `doctor_profiles.is_verified`, un-bans auth user, writes `audit_log`, sends notification. |
| **B-06** | Edge Function: Set Account Status | `supabase/functions/admin-set-account-status/index.ts` | Admin suspends/reactivates doctor or patient, triggers auth ban, updates `account_status`, logs audit record. |
| **B-07** | Edge Function: Document URL | `supabase/functions/get-document-url/index.ts` | Generates 60-second presigned URL for private doctor documents (`doctor-documents` bucket); enforces admin role. |
| **B-08** | Edge Function: Feedback Notification | `supabase/functions/send-feedback-notification/index.ts` | Dispatches notifications when doctor reviews a session or patient triggers a pain alert (pain >= 7). |
| **B-09** | Row-Level Security (RLS) | In migration `B-01` | Strict RLS: doctors only read linked patients; admins strictly barred from patient sessions, pain, and conditions; patients read public exercises & prescribed assignments. |
| **B-10** | Storage Buckets & Policies | In migration `B-01` | Defines `doctor-documents` private bucket with strict RLS: doctor inserts, admin reads via signed URLs. |
| **B-11** | Custom Database Enums | In migration `B-01` | `user_role`, `account_status`, `doctor_application_status`, `connection_status`, `assignment_status`, `tracking_type`, `camera_view`, `joint_type`. |
| **B-12** | Audit Log Infrastructure | In migration `B-01` | Append-only `audit_log` table with triggers preventing UPDATE or DELETE. |
| **B-13** | Soft-Delete Implementation | In migration `B-01` | Logic for `account_status = 'disabled'` and `archived_at = now()`. |
| **B-14** | Supabase Setup Guide | `supabase/SETUP.md` | Complete local and cloud setup instructions: Supabase CLI commands, migrations, secrets configuration, and test users. |

---

### 2.5 App Structure Deliverables (Section 8)

| ID | Item | Target File / Area | Implementation Details |
|---|---|---|---|
| **S-01** | Router Architecture | `lib/app/router.dart` | Single `GoRouter` with role-aware redirection via `AuthNotifier`. 3 separate portals: Patient shell, Doctor shell (`/doctor/*`), Admin shell (`/admin/*`). Declares `/courses/prescribed` before `/courses/:cid`. |
| **S-02** | Design Tokens | `lib/core/tokens.dart` | Pure tokens only. Zero hardcoded hex. Retain all existing tokens (`RSColors`, `RSText`, `RSSpacing`, `RSRadius`, `RSSizes`). Only add necessary helpers if missing. |
| **S-03** | Core Custom Widgets | `lib/core/widgets/` & `widgets.dart` | Build 7 new widgets: `RSDoctorCard`, `RSDocumentTile`, `RSStepHeader`, `RSTimeline`, `RSSlider`, `RSOtpField`, `RSChoiceChip`. All exported through `widgets.dart`. |
| **S-04** | Generic Tracking Engine | `lib/features/exercise/domain/tracking_engine.dart` | Extract landmark calculations into a configurable engine accepting `TrackingConfig` (rep vs. hold, landmark points, start/target angles, tolerance, camera view). |
| **S-05** | Supabase Repositories | `lib/features/*/data/` | Migrate hardcoded in-memory repositories to real Supabase repository implementations with clean domain models and local cache fallbacks. |
| **S-06** | Local Caching & Drafts | `shared_preferences` | Persist wizard drafts (exercise builder, profile setup) locally so navigation away does not lose user progress. |
| **S-07** | Clinical Guardrails | Global | Enforce "Movement score" terminology, disclaimers on welcome/tracking/connect, and outcome triples (Correct / Incorrect / Incomplete). |

---

## 3. Conflicts and Open Decisions (Brief Section 13: D-01 to D-12)

| Decision ID | Topic | Conflict / Ambiguity | Chosen Default & Rationale |
|---|---|---|---|
| **D-01** | Android Application ID | `android/app/build.gradle.kts` has `com.example.my_app`, while `pubspec.yaml` defines package `shariq_skeleton`. | **Default: Leave `build.gradle.kts` untouched (`com.example.my_app`).** Changing application IDs mid-project can invalidate Android build caches and test configurations. We will document it in `SETUP.md` without editing gradle scripts during Stage A. |
| **D-02** | Router Architecture & Role Redirects | Balancing keeping existing patient routes intact while accommodating separate Doctor (`/doctor/*`) and Admin (`/admin/*`) portals. | **Default: Unified `GoRouter` with top-level `redirect` driven by `AuthNotifier`.** Unauthenticated users access `/welcome`, `/login`, `/register`, `/doctor/login`, `/admin/login`. Once authenticated, role redirects route patients to `/home`, doctors to `/doctor/home`, and admins to `/admin/dashboard`. Root navigator handles full-screen flows (`/connect/*`, `/courses/prescribed/:assignmentId`, `/account-inactive`). |
| **D-03** | Tracking Engine Refactoring | Knee angle tracking in `LiveTrackingScreen` currently hardcodes landmarks 25 and 26. Must support generic joints (shoulder, elbow, hip) without breaking existing exercises. | **Default: Extract a `TrackingConfig` model and dynamic angle calculator in `TrackingEngine`.** Landmark indices are mapped by body part (e.g. knee = hip-knee-ankle [23-25-27 or 24-26-28]). Existing exercises retain their default knee configuration so current courses function identically. |
| **D-04** | OTP Verification Strategy | In the existing app, Screen 31 has an 800ms mock delay. Supabase requires 6-digit email OTPs. | **Default: Implement genuine Supabase `verifyOTP(type: OtpType.signup)` via `RSOtpField`.** Add a safe offline/mock fallback for automated test runs where external email delivery is not configured. |
| **D-05** | Repository Transition (In-Memory to Supabase) | Existing screens depend on synchronous in-memory repository seeds. | **Default: Update repository interfaces to return asynchronous `Future<Result<T>>` or streams backed by Supabase.** Ensure seed defaults are returned gracefully if network is unavailable, preventing UI breakages. |
| **D-06** | Doctor Document Storage | Doctors upload private medical licenses and degrees. Admin must inspect them securely. | **Default: Supabase Storage bucket `doctor-documents` with strict private access.** File uploads go via authenticated doctor client; document URLs for admin inspection are generated on-demand with 60-second expiration via `get-document-url` Edge Function. |
| **D-07** | Invite Codes (`P-50`, `D-24`) | Brief marks invite codes as optional/deferred. | **Default: Defer invite code UI.** Stub widget files are created for architecture completeness, but routes are hidden behind `AppFlags.inviteCodesEnabled = false`. |
| **D-08** | Edge Function Execution vs. Deliverables | We cannot execute live Supabase deployments or CLI push commands in this read-only/local mode. | **Default: Deliver complete, production-grade TypeScript / Deno Edge Function files in `supabase/functions/` and SQL migrations in `supabase/migrations/`.** Provide a comprehensive `supabase/SETUP.md` with CLI commands. |
| **D-09** | Doctor Application Resubmission | Doctors may be rejected and resubmit. Need to enforce the 3-attempt limit. | **Default: Enforce max 3 attempts via database trigger and Edge Function.** Application status tracks `attempt_number`. After 3 rejections, status transitions to `permanently_rejected`. |
| **D-10** | Rep-by-Rep Angle Data Storage | Need to store detailed angles per rep for doctor review without violating Product Rule 4 (no video/images). | **Default: Store a JSONB array `rep_data` in `exercise_sessions`.** Each entry records `{"rep": 1, "outcome": "correct", "angle": 42.5, "timestamp": 12.4}`. Zero image or video frames are stored. |
| **D-11** | Admin Privacy Boundary | Admin must review doctors and oversee system health, but must never see patient medical sessions or conditions. | **Default: Enforced at both Database RLS level and UI routing.** RLS policies deny `role = 'admin'` from selecting from `exercise_sessions`, `pain_logs`, and `patient_conditions`. Admin Patient Detail screen (`A-16`) shows only name, email, joined date, and status. |
| **D-12** | Soft-Delete Standard | Patient account deletion must comply with Product Rule 8 (soft delete only). | **Default: Standardize on `account_status = 'disabled'` and `archived_at = now()`.** Disable auth user session; prevent future logins; preserve historical session logs for clinical records. |

---

## 4. Comprehensive File Plan

### 4.1 Files to KEEP UNTOUCHED (`DONE / KEEP`)
These files will **not** be rewritten, renamed, or modified:
- `lib/core/tokens.dart` (Strict token retention; no edits to existing constants)
- `lib/core/widgets/rs_button.dart`
- `lib/core/widgets/rs_card.dart`
- `lib/core/widgets/rs_badge.dart`
- `lib/core/widgets/rs_scaffold.dart`
- `lib/core/widgets/rs_app_bar.dart`
- `lib/core/widgets/rs_avatar.dart`
- `lib/core/widgets/rs_input.dart`
- `lib/core/widgets/rs_progress_bar.dart`
- `lib/core/widgets/rs_bottom_nav_bar.dart`
- `lib/core/widgets/rs_stat_tile.dart`
- `lib/core/widgets/rs_list_item.dart`
- `lib/core/widgets/rs_metric_card.dart`
- `lib/core/widgets/rs_banner.dart`
- `lib/core/widgets/rs_score_ring.dart`
- `lib/features/auth/presentation/register_screen.dart`
- `lib/features/auth/presentation/forgot_password_screen.dart`
- `lib/features/auth/presentation/reset_password_screen.dart`
- `lib/features/onboarding/presentation/profile_setup_screen.dart`
- `lib/features/onboarding/presentation/safety_consent_screen.dart`
- `lib/features/onboarding/presentation/camera_permission_screen.dart`
- `lib/features/courses/presentation/course_detail_screen.dart`
- `lib/features/exercise/presentation/exercise_intro_screen.dart`
- `lib/features/exercise/presentation/exercise_completed_screen.dart`
- `lib/features/progress/presentation/progress_screen.dart`
- `lib/features/progress/presentation/all_badges_screen.dart`
- `lib/features/progress/presentation/badge_detail_screen.dart`
- `lib/features/progress/presentation/milestone_reached_screen.dart`
- `lib/features/progress/presentation/history_screen.dart`
- `lib/features/progress/presentation/session_detail_screen.dart`
- `lib/features/progress/presentation/weekly_summary_screen.dart`
- `lib/features/progress/presentation/export_data_screen.dart`
- `lib/features/progress/presentation/export_success_screen.dart`
- `lib/features/profile/presentation/edit_profile_screen.dart`
- `lib/features/profile/presentation/notifications_settings_screen.dart`
- `lib/features/profile/presentation/change_password_screen.dart`
- `lib/features/profile/presentation/help_faq_screen.dart`
- `lib/features/profile/presentation/contact_support_screen.dart`
- `lib/features/profile/presentation/terms_privacy_screen.dart`

### 4.2 Existing Files to PATCH (`CHANGED`)
1. `lib/core/supabase_config.dart`:
   - Replace hardcoded credentials with `--dart-define` environment configuration (`String.fromEnvironment('SUPABASE_URL')`, etc.).
2. `lib/core/widgets/widgets.dart`:
   - Export the 7 new widgets (`RSDoctorCard`, `RSDocumentTile`, `RSStepHeader`, `RSTimeline`, `RSSlider`, `RSOtpField`, `RSChoiceChip`).
3. `lib/app/router.dart`:
   - Reconstruct router to handle multi-portal routing: Patient shell, Doctor shell (`/doctor/*`), Admin shell (`/admin/*`), and root modals.
4. `lib/features/auth/presentation/splash_screen.dart`:
   - Implement role-aware initial routing.
5. `lib/features/auth/presentation/welcome_screen.dart`:
   - Add "I am a Doctor" button and "Staff login" secondary link.
6. `lib/features/auth/presentation/login_screen.dart`:
   - Integrate portal role verification; redirect disabled accounts to `/account-inactive`.
7. `lib/features/auth/presentation/verify_email_screen.dart`:
   - Integrate interactive `RSOtpField` and Supabase OTP verification.
8. `lib/features/home/presentation/home_screen.dart`:
   - Add doctor connection banners, prescribed exercise widgets, and status pills.
9. `lib/features/courses/presentation/courses_screen.dart`:
   - Add "Prescribed" category tab leading to `/courses/prescribed`.
10. `lib/features/exercise/presentation/live_tracking_screen.dart`:
    - Connect to generic `TrackingEngine`; capture rep-by-rep angle metrics.
11. `lib/features/exercise/presentation/session_summary_screen.dart`:
    - Add post-session pain slider (0-10) and notes input.
12. `lib/features/profile/presentation/profile_screen.dart`:
    - Add "Connect with a doctor", "My Doctor", and "My Condition" links.
13. `lib/features/profile/presentation/privacy_data_screen.dart`:
    - Connect delete account action to soft-delete confirmation dialog.
14. `lib/features/profile/presentation/delete_account_dialog.dart`:
    - Implement typed DELETE requirement and soft-delete Supabase mutation.

### 4.3 New Files to CREATE

#### Core & Architecture
- `lib/core/constants/app_flags.dart`
- `lib/core/widgets/rs_doctor_card.dart`
- `lib/core/widgets/rs_document_tile.dart`
- `lib/core/widgets/rs_step_header.dart`
- `lib/core/widgets/rs_timeline.dart`
- `lib/core/widgets/rs_slider.dart`
- `lib/core/widgets/rs_otp_field.dart`
- `lib/core/widgets/rs_choice_chip.dart`
- `lib/app/auth_notifier.dart`

#### Exercise & Tracking Engine
- `lib/features/exercise/domain/tracking_engine.dart`
- `lib/features/exercise/domain/tracking_config.dart`
- `lib/features/exercise/presentation/pain_alert_sheet.dart`

#### Patient Portal (New Features & Connect)
- `lib/features/connect/presentation/connect_hub_screen.dart` (`P-37`)
- `lib/features/connect/presentation/condition_form_wizard.dart` (`P-38`)
- `lib/features/connect/presentation/red_flags_alert_sheet.dart` (`P-39`)
- `lib/features/connect/presentation/find_doctors_screen.dart` (`P-40`)
- `lib/features/connect/presentation/doctor_profile_public_screen.dart` (`P-41`)
- `lib/features/connect/presentation/send_request_screen.dart` (`P-42`)
- `lib/features/connect/presentation/request_status_screen.dart` (`P-43`)
- `lib/features/connect/presentation/connected_celebration_screen.dart` (`P-44`)
- `lib/features/connect/presentation/request_declined_screen.dart` (`P-45`)
- `lib/features/connect/presentation/my_doctor_screen.dart` (`P-46`)
- `lib/features/connect/presentation/disconnect_confirm_dialog.dart` (`P-47`)
- `lib/features/courses/presentation/prescribed_courses_screen.dart` (`P-48`)
- `lib/features/courses/presentation/prescribed_exercise_detail_screen.dart` (`P-49`)
- `lib/features/connect/presentation/enter_doctor_code_screen.dart` (`P-50` deferred)
- `lib/features/connect/presentation/my_condition_screen.dart` (`P-51`)
- `lib/features/auth/presentation/inactive_account_screen.dart` (`P-52`)

#### Doctor Portal
- `lib/features/doctor/presentation/auth/doctor_login_screen.dart` (`D-01`)
- `lib/features/doctor/presentation/auth/doctor_register_screen.dart` (`D-02`)
- `lib/features/doctor/presentation/auth/doctor_otp_screen.dart` (`D-03`)
- `lib/features/doctor/presentation/auth/doctor_documents_screen.dart` (`D-04`)
- `lib/features/doctor/presentation/auth/doctor_submit_review_screen.dart` (`D-05`)
- `lib/features/doctor/presentation/auth/doctor_application_submitted_screen.dart` (`D-06`)
- `lib/features/doctor/presentation/auth/doctor_resume_application_screen.dart` (`D-07`)
- `lib/features/doctor/presentation/auth/doctor_application_rejected_screen.dart` (`D-08`)
- `lib/features/doctor/presentation/auth/doctor_inactive_screen.dart` (`D-09`)
- `lib/features/doctor/presentation/auth/doctor_forgot_password_screen.dart` (`D-10`)
- `lib/features/doctor/presentation/auth/doctor_reset_password_screen.dart` (`D-11`)
- `lib/features/doctor/presentation/onboarding/doctor_profile_wizard.dart` (`D-12`)
- `lib/features/doctor/presentation/onboarding/doctor_go_live_screen.dart` (`D-13`)
- `lib/features/doctor/presentation/dashboard/doctor_home_screen.dart` (`D-14`)
- `lib/features/doctor/presentation/requests/doctor_requests_screen.dart` (`D-15`)
- `lib/features/doctor/presentation/requests/doctor_request_detail_screen.dart` (`D-16`)
- `lib/features/doctor/presentation/requests/doctor_decline_sheet.dart` (`D-16D`)
- `lib/features/doctor/presentation/patients/doctor_patients_list_screen.dart` (`D-17`)
- `lib/features/doctor/presentation/patients/doctor_patient_detail_screen.dart` (`D-18`)
- `lib/features/doctor/presentation/patients/doctor_patient_plan_screen.dart` (`D-18b`)
- `lib/features/doctor/presentation/patients/doctor_patient_sessions_screen.dart` (`D-18c`)
- `lib/features/doctor/presentation/patients/doctor_patient_condition_screen.dart` (`D-18d`)
- `lib/features/doctor/presentation/assignments/doctor_assign_wizard.dart` (`D-19`)
- `lib/features/doctor/presentation/exercises/doctor_exercise_library_screen.dart` (`D-20`)
- `lib/features/doctor/presentation/exercises/doctor_exercise_builder_wizard.dart` (`D-21`)
- `lib/features/doctor/presentation/exercises/doctor_test_camera_screen.dart` (`D-22`)
- `lib/features/doctor/presentation/reviews/doctor_session_review_screen.dart` (`D-23`)
- `lib/features/doctor/presentation/patients/doctor_invite_code_screen.dart` (`D-24` deferred)
- `lib/features/doctor/presentation/notifications/doctor_notifications_screen.dart` (`D-25`)
- `lib/features/doctor/presentation/profile/doctor_profile_screen.dart` (`D-26`)
- `lib/features/doctor/presentation/profile/doctor_edit_profile_screen.dart` (`D-27`)
- `lib/features/doctor/presentation/profile/doctor_update_credentials_screen.dart` (`D-28`)
- `lib/features/doctor/presentation/profile/doctor_settings_screen.dart` (`D-29`)
- `lib/features/doctor/presentation/profile/doctor_logout_dialog.dart` (`D-30`)

#### Admin Portal
- `lib/features/admin/presentation/auth/admin_login_screen.dart` (`A-01`)
- `lib/features/admin/presentation/auth/admin_forgot_password_screen.dart` (`A-02`)
- `lib/features/admin/presentation/auth/admin_reset_password_screen.dart` (`A-03`)
- `lib/features/admin/presentation/dashboard/admin_dashboard_screen.dart` (`A-04`)
- `lib/features/admin/presentation/applications/admin_applications_screen.dart` (`A-05`)
- `lib/features/admin/presentation/applications/admin_application_detail_screen.dart` (`A-06`)
- `lib/features/admin/presentation/applications/admin_document_viewer_screen.dart` (`A-07`)
- `lib/features/admin/presentation/applications/admin_approve_dialog.dart` (`A-08`)
- `lib/features/admin/presentation/applications/admin_reject_sheet.dart` (`A-09`)
- `lib/features/admin/presentation/doctors/admin_doctors_list_screen.dart` (`A-10`)
- `lib/features/admin/presentation/doctors/admin_doctor_detail_screen.dart` (`A-11`)
- `lib/features/admin/presentation/doctors/admin_edit_doctor_screen.dart` (`A-12`)
- `lib/features/admin/presentation/doctors/admin_suspend_dialog.dart` (`A-13`)
- `lib/features/admin/presentation/doctors/admin_add_doctor_screen.dart` (`A-14`)
- `lib/features/admin/presentation/patients/admin_patients_list_screen.dart` (`A-15`)
- `lib/features/admin/presentation/patients/admin_patient_detail_screen.dart` (`A-16`)
- `lib/features/admin/presentation/exercises/admin_exercise_library_screen.dart` (`A-17`)
- `lib/features/admin/presentation/exercises/admin_exercise_builder_screen.dart` (`A-18`)
- `lib/features/admin/presentation/exercises/admin_test_camera_screen.dart` (`A-19`)
- `lib/features/admin/presentation/notifications/admin_notifications_screen.dart` (`A-20`)
- `lib/features/admin/presentation/audit/admin_audit_log_screen.dart` (`A-21`)
- `lib/features/admin/presentation/profile/admin_profile_screen.dart` (`A-22`)
- `lib/features/admin/presentation/profile/admin_change_password_screen.dart` (`A-23`)
- `lib/features/admin/presentation/profile/admin_logout_dialog.dart` (`A-24`)
- `lib/features/admin/presentation/auth/admin_blocked_screen.dart` (`A-25`)

#### Backend & Supabase Deliverables (File Only)
- `supabase/migrations/20261103000000_rehabsense_v2_core.sql`
- `supabase/seed.sql`
- `supabase/functions/register-doctor/index.ts`
- `supabase/functions/admin-review-doctor/index.ts`
- `supabase/functions/admin-set-account-status/index.ts`
- `supabase/functions/get-document-url/index.ts`
- `supabase/functions/send-feedback-notification/index.ts`
- `supabase/SETUP.md`

---

## 5. Screen Coverage Matrix

| Screen ID | Portal | Screen Name | Route Path | Target Implementation File | Status |
|---|---|---|---|---|---|
| **P-01** | Patient | Splash | `/splash` | `lib/features/auth/presentation/splash_screen.dart` | CHANGED |
| **P-02** | Patient | Welcome | `/welcome` | `lib/features/auth/presentation/welcome_screen.dart` | CHANGED |
| **P-03** | Patient | Login | `/login` | `lib/features/auth/presentation/login_screen.dart` | CHANGED |
| **P-04** | Patient | Register | `/register` | `lib/features/auth/presentation/register_screen.dart` | KEEP |
| **P-05** | Patient | Verify Email (OTP) | `/verify-email` | `lib/features/auth/presentation/verify_email_screen.dart` | CHANGED |
| **P-05b**| Patient | Verify Email Error | `/verify-email` | `lib/features/auth/presentation/verify_email_screen.dart` | CHANGED |
| **P-06** | Patient | Forgot Password | `/forgot-password` | `lib/features/auth/presentation/forgot_password_screen.dart` | KEEP |
| **P-06b**| Patient | Forgot Password Sent | `/forgot-password/sent` | `lib/features/auth/presentation/forgot_password_screen.dart` | KEEP |
| **P-07** | Patient | Reset Password | `/reset-password` | `lib/features/auth/presentation/reset_password_screen.dart` | KEEP |
| **P-08** | Patient | Profile Setup | `/onboarding/profile` | `lib/features/onboarding/presentation/profile_setup_screen.dart` | KEEP |
| **P-09** | Patient | Safety and Consent | `/onboarding/safety` | `lib/features/onboarding/presentation/safety_consent_screen.dart` | KEEP |
| **P-10** | Patient | Camera Permission | `/onboarding/camera` | `lib/features/onboarding/presentation/camera_permission_screen.dart` | KEEP |
| **P-11** | Patient | Home | `/home` | `lib/features/home/presentation/home_screen.dart` | CHANGED |
| **P-12** | Patient | Courses | `/courses` | `lib/features/courses/presentation/courses_screen.dart` | CHANGED |
| **P-13** | Patient | Course Detail | `/courses/:cid` | `lib/features/courses/presentation/course_detail_screen.dart` | KEEP |
| **P-14** | Patient | Exercise Intro | `/exercise/:eid/intro` | `lib/features/exercise/presentation/exercise_intro_screen.dart` | KEEP |
| **P-15** | Patient | Live Tracking | `/exercise/:eid/tracking` | `lib/features/exercise/presentation/live_tracking_screen.dart` | CHANGED |
| **P-16** | Patient | Exercise Completed | `/exercise/:eid/completed` | `lib/features/exercise/presentation/exercise_completed_screen.dart` | KEEP |
| **P-17** | Patient | Session Summary | `/exercise/:eid/summary` | `lib/features/exercise/presentation/session_summary_screen.dart` | CHANGED |
| **P-18** | Patient | Pain Alert Sheet | modal sheet | `lib/features/exercise/presentation/pain_alert_sheet.dart` | NEW |
| **P-19** | Patient | Progress Dashboard | `/progress` | `lib/features/progress/presentation/progress_screen.dart` | KEEP |
| **P-20** | Patient | All Badges | `/progress/badges` | `lib/features/progress/presentation/all_badges_screen.dart` | KEEP |
| **P-21** | Patient | Badge Detail | `/progress/badges/:bid` | `lib/features/progress/presentation/badge_detail_screen.dart` | KEEP |
| **P-22** | Patient | Milestone Reached | modal sheet | `lib/features/progress/presentation/milestone_reached_screen.dart` | KEEP |
| **P-23** | Patient | History List | `/progress/history` | `lib/features/progress/presentation/history_screen.dart` | KEEP |
| **P-24** | Patient | Session Detail | `/progress/history/:sid` | `lib/features/progress/presentation/session_detail_screen.dart` | KEEP |
| **P-25** | Patient | Weekly Summary | `/progress/weekly` | `lib/features/progress/presentation/weekly_summary_screen.dart` | KEEP |
| **P-26** | Patient | Export Data | `/progress/export` | `lib/features/progress/presentation/export_data_screen.dart` | KEEP |
| **P-27** | Patient | Export Success | `/progress/export/success` | `lib/features/progress/presentation/export_success_screen.dart` | KEEP |
| **P-28** | Patient | Profile | `/profile` | `lib/features/profile/presentation/profile_screen.dart` | CHANGED |
| **P-29** | Patient | Edit Profile | `/profile/edit` | `lib/features/profile/presentation/edit_profile_screen.dart` | KEEP |
| **P-30** | Patient | Notifications Settings| `/profile/notifications` | `lib/features/profile/presentation/notifications_settings_screen.dart`| KEEP |
| **P-31** | Patient | Change Password | `/profile/change-password` | `lib/features/profile/presentation/change_password_screen.dart` | KEEP |
| **P-32** | Patient | Help & FAQ | `/profile/help` | `lib/features/profile/presentation/help_faq_screen.dart` | KEEP |
| **P-33** | Patient | Contact Support | `/profile/support` | `lib/features/profile/presentation/contact_support_screen.dart` | KEEP |
| **P-34** | Patient | Privacy & Data | `/profile/privacy` | `lib/features/profile/presentation/privacy_data_screen.dart` | CHANGED |
| **P-35** | Patient | Terms & Privacy Policy| `/profile/terms` | `lib/features/profile/presentation/terms_privacy_screen.dart` | KEEP |
| **P-36** | Patient | Delete Account Dialog | dialog | `lib/features/profile/presentation/delete_account_dialog.dart` | CHANGED |
| **P-37** | Patient | Connect Hub | `/connect` | `lib/features/connect/presentation/connect_hub_screen.dart` | NEW |
| **P-38** | Patient | Condition Form Wizard | `/connect/condition` | `lib/features/connect/presentation/condition_form_wizard.dart` | NEW |
| **P-39** | Patient | Safety Alert Sheet | modal sheet | `lib/features/connect/presentation/red_flags_alert_sheet.dart` | NEW |
| **P-40** | Patient | Find Doctors | `/connect/doctors` | `lib/features/connect/presentation/find_doctors_screen.dart` | NEW |
| **P-41** | Patient | Doctor Public Profile | `/connect/doctors/:did` | `lib/features/connect/presentation/doctor_profile_public_screen.dart` | NEW |
| **P-42** | Patient | Send Request | `/connect/doctors/:did/request` | `lib/features/connect/presentation/send_request_screen.dart` | NEW |
| **P-43** | Patient | Request Status | `/connect/status` | `lib/features/connect/presentation/request_status_screen.dart` | NEW |
| **P-44** | Patient | Connected Celebration | `/connect/success` | `lib/features/connect/presentation/connected_celebration_screen.dart` | NEW |
| **P-45** | Patient | Request Declined | `/connect/declined` | `lib/features/connect/presentation/request_declined_screen.dart` | NEW |
| **P-46** | Patient | My Doctor | `/my-doctor` | `lib/features/connect/presentation/my_doctor_screen.dart` | NEW |
| **P-47** | Patient | Disconnect Confirm | dialog | `lib/features/connect/presentation/disconnect_confirm_dialog.dart` | NEW |
| **P-48** | Patient | Prescribed List | `/courses/prescribed` | `lib/features/courses/presentation/prescribed_courses_screen.dart` | NEW |
| **P-49** | Patient | Prescribed Detail | `/courses/prescribed/:assignmentId` | `lib/features/courses/presentation/prescribed_exercise_detail_screen.dart` | NEW |
| **P-50** | Patient | Enter Doctor Code | `/connect/code` | `lib/features/connect/presentation/enter_doctor_code_screen.dart` | DEFERRED |
| **P-51** | Patient | My Condition | `/my-condition` | `lib/features/connect/presentation/my_condition_screen.dart` | NEW |
| **P-52** | Patient | Inactive Account | `/account-inactive` | `lib/features/auth/presentation/inactive_account_screen.dart` | NEW |
| **D-01** | Doctor | Doctor Login | `/doctor/login` | `lib/features/doctor/presentation/auth/doctor_login_screen.dart` | NEW |
| **D-02** | Doctor | Register Account | `/doctor/register` | `lib/features/doctor/presentation/auth/doctor_register_screen.dart` | NEW |
| **D-03** | Doctor | Verify Email (OTP) | `/doctor/verify-email` | `lib/features/doctor/presentation/auth/doctor_otp_screen.dart` | NEW |
| **D-04** | Doctor | Documents Upload | `/doctor/onboarding/documents` | `lib/features/doctor/presentation/auth/doctor_documents_screen.dart` | NEW |
| **D-05** | Doctor | Review & Submit | `/doctor/onboarding/review` | `lib/features/doctor/presentation/auth/doctor_submit_review_screen.dart` | NEW |
| **D-06** | Doctor | Submitted / Status | `/doctor/application-status` | `lib/features/doctor/presentation/auth/doctor_application_submitted_screen.dart` | NEW |
| **D-07** | Doctor | Resume Application | `/doctor/application/resume` | `lib/features/doctor/presentation/auth/doctor_resume_application_screen.dart` | NEW |
| **D-08** | Doctor | Application Rejected | `/doctor/application/rejected` | `lib/features/doctor/presentation/auth/doctor_application_rejected_screen.dart` | NEW |
| **D-09** | Doctor | Inactive Account | `/doctor/blocked` | `lib/features/doctor/presentation/auth/doctor_inactive_screen.dart` | NEW |
| **D-10** | Doctor | Forgot Password | `/doctor/forgot-password` | `lib/features/doctor/presentation/auth/doctor_forgot_password_screen.dart` | NEW |
| **D-11** | Doctor | Reset Password | `/doctor/reset-password` | `lib/features/doctor/presentation/auth/doctor_reset_password_screen.dart` | NEW |
| **D-12** | Doctor | Profile Setup Wizard | `/doctor/onboarding/profile` | `lib/features/doctor/presentation/onboarding/doctor_profile_wizard.dart` | NEW |
| **D-13** | Doctor | Preview & Go Live | `/doctor/onboarding/preview` | `lib/features/doctor/presentation/onboarding/doctor_go_live_screen.dart` | NEW |
| **D-14** | Doctor | Doctor Home | `/doctor/home` | `lib/features/doctor/presentation/dashboard/doctor_home_screen.dart` | NEW |
| **D-15** | Doctor | Requests List | `/doctor/requests` | `lib/features/doctor/presentation/requests/doctor_requests_screen.dart` | NEW |
| **D-16** | Doctor | Request Detail | `/doctor/requests/:id` | `lib/features/doctor/presentation/requests/doctor_request_detail_screen.dart` | NEW |
| **D-16D**| Doctor | Decline Request Sheet| modal sheet | `lib/features/doctor/presentation/requests/doctor_decline_sheet.dart` | NEW |
| **D-17** | Doctor | My Patients | `/doctor/patients` | `lib/features/doctor/presentation/patients/doctor_patients_list_screen.dart` | NEW |
| **D-18** | Doctor | Patient Overview | `/doctor/patients/:id` | `lib/features/doctor/presentation/patients/doctor_patient_detail_screen.dart` | NEW |
| **D-18b**| Doctor | Patient Plan | `/doctor/patients/:id/plan` | `lib/features/doctor/presentation/patients/doctor_patient_plan_screen.dart` | NEW |
| **D-18c**| Doctor | Patient Sessions | `/doctor/patients/:id/sessions` | `lib/features/doctor/presentation/patients/doctor_patient_sessions_screen.dart` | NEW |
| **D-18d**| Doctor | Patient Condition | `/doctor/patients/:id/condition` | `lib/features/doctor/presentation/patients/doctor_patient_condition_screen.dart` | NEW |
| **D-19** | Doctor | Assign Exercise Wizard | `/doctor/patients/:id/assign` | `lib/features/doctor/presentation/assignments/doctor_assign_wizard.dart` | NEW |
| **D-20** | Doctor | Exercise Library | `/doctor/exercises` | `lib/features/doctor/presentation/exercises/doctor_exercise_library_screen.dart` | NEW |
| **D-21** | Doctor | Exercise Builder Wizard| `/doctor/exercises/new` | `lib/features/doctor/presentation/exercises/doctor_exercise_builder_wizard.dart` | NEW |
| **D-22** | Doctor | Test on Camera | `/doctor/exercises/:id/test` | `lib/features/doctor/presentation/exercises/doctor_test_camera_screen.dart` | NEW |
| **D-23** | Doctor | Session Review & Feedback| `/doctor/sessions/:id/review`| `lib/features/doctor/presentation/reviews/doctor_session_review_screen.dart` | NEW |
| **D-24** | Doctor | Invite Code Generator | `/doctor/invite-code` | `lib/features/doctor/presentation/patients/doctor_invite_code_screen.dart` | DEFERRED |
| **D-25** | Doctor | Doctor Notifications | `/doctor/notifications` | `lib/features/doctor/presentation/notifications/doctor_notifications_screen.dart` | NEW |
| **D-26** | Doctor | Doctor Profile | `/doctor/profile` | `lib/features/doctor/presentation/profile/doctor_profile_screen.dart` | NEW |
| **D-27** | Doctor | Edit Profile & Expertise| `/doctor/profile/edit` | `lib/features/doctor/presentation/profile/doctor_edit_profile_screen.dart` | NEW |
| **D-28** | Doctor | Update Credentials | `/doctor/profile/credentials` | `lib/features/doctor/presentation/profile/doctor_update_credentials_screen.dart` | NEW |
| **D-29** | Doctor | Doctor Settings | `/doctor/settings` | `lib/features/doctor/presentation/profile/doctor_settings_screen.dart` | NEW |
| **D-30** | Doctor | Doctor Logout Dialog | dialog | `lib/features/doctor/presentation/profile/doctor_logout_dialog.dart` | NEW |
| **A-01** | Admin | Admin Login | `/admin/login` | `lib/features/admin/presentation/auth/admin_login_screen.dart` | NEW |
| **A-02** | Admin | Forgot Password | `/admin/forgot-password` | `lib/features/admin/presentation/auth/admin_forgot_password_screen.dart` | NEW |
| **A-03** | Admin | Reset Password | `/admin/reset-password` | `lib/features/admin/presentation/auth/admin_reset_password_screen.dart` | NEW |
| **A-04** | Admin | Dashboard | `/admin/dashboard` | `lib/features/admin/presentation/dashboard/admin_dashboard_screen.dart` | NEW |
| **A-05** | Admin | Applications List | `/admin/applications` | `lib/features/admin/presentation/applications/admin_applications_screen.dart` | NEW |
| **A-06** | Admin | Application Detail | `/admin/applications/:id` | `lib/features/admin/presentation/applications/admin_application_detail_screen.dart` | NEW |
| **A-07** | Admin | Document Viewer | `/admin/applications/:id/doc/:docId` | `lib/features/admin/presentation/applications/admin_document_viewer_screen.dart` | NEW |
| **A-08** | Admin | Approve Dialog | dialog | `lib/features/admin/presentation/applications/admin_approve_dialog.dart` | NEW |
| **A-09** | Admin | Reject Sheet | modal sheet | `lib/features/admin/presentation/applications/admin_reject_sheet.dart` | NEW |
| **A-10** | Admin | Doctors List | `/admin/doctors` | `lib/features/admin/presentation/doctors/admin_doctors_list_screen.dart` | NEW |
| **A-11** | Admin | Doctor Detail | `/admin/doctors/:id` | `lib/features/admin/presentation/doctors/admin_doctor_detail_screen.dart` | NEW |
| **A-12** | Admin | Edit Doctor | `/admin/doctors/:id/edit` | `lib/features/admin/presentation/doctors/admin_edit_doctor_screen.dart` | NEW |
| **A-13** | Admin | Suspend / Reactivate | dialog | `lib/features/admin/presentation/doctors/admin_suspend_dialog.dart` | NEW |
| **A-14** | Admin | Add Doctor | `/admin/doctors/new` | `lib/features/admin/presentation/doctors/admin_add_doctor_screen.dart` | NEW |
| **A-15** | Admin | Patients List | `/admin/patients` | `lib/features/admin/presentation/patients/admin_patients_list_screen.dart` | NEW |
| **A-16** | Admin | Patient Detail | `/admin/patients/:id` | `lib/features/admin/presentation/patients/admin_patient_detail_screen.dart` | NEW |
| **A-17** | Admin | Exercise Library | `/admin/exercises` | `lib/features/admin/presentation/exercises/admin_exercise_library_screen.dart` | NEW |
| **A-18** | Admin | Exercise Builder Wizard| `/admin/exercises/new` | `lib/features/admin/presentation/exercises/admin_exercise_builder_screen.dart` | NEW |
| **A-19** | Admin | Test on Camera | `/admin/exercises/:id/test` | `lib/features/admin/presentation/exercises/admin_test_camera_screen.dart` | NEW |
| **A-20** | Admin | Notifications | `/admin/notifications` | `lib/features/admin/presentation/notifications/admin_notifications_screen.dart` | NEW |
| **A-21** | Admin | Audit Log | `/admin/audit` | `lib/features/admin/presentation/audit/admin_audit_log_screen.dart` | NEW |
| **A-22** | Admin | Admin Profile | `/admin/profile` | `lib/features/admin/presentation/profile/admin_profile_screen.dart` | NEW |
| **A-23** | Admin | Change Password | `/admin/change-password` | `lib/features/admin/presentation/profile/admin_change_password_screen.dart` | NEW |
| **A-24** | Admin | Logout Dialog | dialog | `lib/features/admin/presentation/profile/admin_logout_dialog.dart` | NEW |
| **A-25** | Admin | Blocked / Wrong Portal | `/admin/blocked` | `lib/features/admin/presentation/auth/admin_blocked_screen.dart` | NEW |

---

## 6. Implementation Phases (Execution Protocol)

Each implementation phase must strictly conclude with running:
1. `flutter pub get`
2. `flutter analyze` (Must pass with 0 errors, 0 new warnings)
3. `flutter test` (All tests passing)
4. A concise verification summary reporting exactly what was implemented and verified.

### Phase 0: Setup, Dependencies & Core Widgets
- Add `shared_preferences` dependency to `pubspec.yaml` (if not present).
- Build the 7 new core design-token widgets under `lib/core/widgets/`:
  - `RSDoctorCard`: Doctor tile with avatar, title, clinic, tags, match pill.
  - `RSDocumentTile`: Document upload/view row with file icon, name, size, status.
  - `RSStepHeader`: Step indicator (e.g., "Step 2 of 4 · Tracking").
  - `RSTimeline`: Vertical progression tracker with completed, active, pending nodes.
  - `RSSlider`: Discrete slider for pain rating (0-10) with numeric callout.
  - `RSOtpField`: 6-digit PIN input with auto-advance and error shake animation.
  - `RSChoiceChip`: Single and multi-select chips following RehabSense color tokens.
- Export all widgets in `lib/core/widgets/widgets.dart`.
- Verify with unit/widget tests for each component.

### Phase 1: Database Migrations, RLS & Edge Functions (Deliverables Only)
- Author `supabase/migrations/20261103000000_rehabsense_v2_core.sql`:
  - Enums: `user_role`, `account_status`, `doctor_application_status`, `connection_status`, `assignment_status`, `tracking_type`, `camera_view`, `joint_type`.
  - Tables: `doctor_profiles`, `doctor_applications`, `doctor_documents`, `doctor_requests`, `doctor_patients`, `assignments`, `pain_logs`, `exercise_feedback`, `audit_log`.
  - Triggers: `handle_new_user()` (always patient), `audit_log` immutability, updated_at timestamps.
  - RLS Policies: Restrict doctor access to linked patients, deny admin access to clinical health data, protect documents bucket.
  - Storage bucket: `doctor-documents` (private).
- Author `supabase/seed.sql` for local testing.
- Author Edge Functions in `supabase/functions/`:
  - `register-doctor/index.ts`
  - `admin-review-doctor/index.ts`
  - `admin-set-account-status/index.ts`
  - `get-document-url/index.ts`
  - `send-feedback-notification/index.ts`
- Author `supabase/SETUP.md`.

### Phase 2: Auth Architecture & Multi-Portal Routing
- Refactor `lib/core/supabase_config.dart` to use `--dart-define`.
- Implement `AuthNotifier` listening to Supabase auth state changes and reading profile roles.
- Update `lib/app/router.dart` to support role-based route guards and 3 shell branches:
  - Patient shell: 4 tabs (`/home`, `/courses`, `/progress`, `/profile`).
  - Doctor shell: 4 tabs (`/doctor/home`, `/doctor/requests`, `/doctor/exercises`, `/doctor/profile`).
  - Admin shell: 5 tabs (`/admin/dashboard`, `/admin/doctors`, `/admin/patients`, `/admin/exercises`, `/admin/profile`).
  - Root navigator routes for standalone screens (`/welcome`, `/login`, `/doctor/login`, `/admin/login`, `/connect/*`, `/courses/prescribed/:assignmentId`, `/account-inactive`).
- Update `SplashScreen` (`P-01`), `WelcomeScreen` (`P-02`), and `LoginScreen` (`P-03`).
- Upgrade `VerifyEmailScreen` (`P-05`, `P-05b`) to use `RSOtpField`.
- Create `InactiveAccountScreen` (`P-52`).

### Phase 3: Patient Portal Updates & Connect Flow
- Update `HomeScreen` (`P-11`) to handle the 5 clinical states (no doctor, pending, connected, prescribed, doctor inactive).
- Update `ProfileScreen` (`P-28`) with "Connect with a doctor", "My Doctor", and "My Condition" links.
- Implement the "Connect with Doctor" flow:
  - `ConnectHubScreen` (`P-37`)
  - `ConditionFormWizard` (`P-38`) with 3 steps and draft persistence.
  - `RedFlagsAlertSheet` (`P-39`)
  - `FindDoctorsScreen` (`P-40`) with match calculation and filtering.
  - `DoctorProfilePublicScreen` (`P-41`)
  - `SendRequestScreen` (`P-42`) with explicit consent checkbox.
  - `RequestStatusScreen` (`P-43`) with timeline and cancellation.
  - `ConnectedCelebrationScreen` (`P-44`)
  - `RequestDeclinedScreen` (`P-45`)
  - `MyDoctorScreen` (`P-46`) & `DisconnectConfirmDialog` (`P-47`)
  - `MyConditionScreen` (`P-51`)
  - `DeleteAccountDialog` (`P-36`) soft delete.

### Phase 4: Prescribed Exercises & Generic Tracking Engine
- Implement `TrackingEngine` and `TrackingConfig` in `lib/features/exercise/domain/`.
- Refactor `LiveTrackingScreen` (`P-15`) to run dynamically based on `tracking_config` (camera view, rep vs hold, target joint angle calculation).
- Update `SessionSummaryScreen` (`P-17`) to include post-session pain slider (0-10) and notes.
- Create `PainAlertSheet` (`P-18`) triggered when reported pain >= 7.
- Implement Prescribed exercises UI:
  - `PrescribedCoursesScreen` (`P-48`) as a tab in `/courses/prescribed`.
  - `PrescribedExerciseDetailScreen` (`P-49`) showing doctor's prescription, schedule, and notes.

### Phase 5: Doctor Portal — Onboarding & Credential Verification
- Create Doctor Auth & Onboarding screens:
  - `DoctorLoginScreen` (`D-01`)
  - `DoctorRegisterScreen` (`D-02`)
  - `DoctorOtpScreen` (`D-03`)
  - `DoctorDocumentsScreen` (`D-04`) with multi-file picker & `RSDocumentTile`.
  - `DoctorSubmitReviewScreen` (`D-05`)
  - `DoctorApplicationSubmittedScreen` (`D-06`)
  - `DoctorResumeApplicationScreen` (`D-07`)
  - `DoctorApplicationRejectedScreen` (`D-08`)
  - `DoctorInactiveScreen` (`D-09`)
  - `DoctorForgotPasswordScreen` (`D-10`) & `DoctorResetPasswordScreen` (`D-11`)
- Create Doctor Profile Setup Wizard:
  - `DoctorProfileWizard` (`D-12`) (Basics, Expertise, Bio, Availability).
  - `DoctorGoLiveScreen` (`D-13`) with listing criteria checklist.

### Phase 6: Doctor Portal — Patient Management & Assignments
- Create Doctor Dashboard:
  - `DoctorHomeScreen` (`D-14`) with KPI tiles, alerts, and priority pain alert list.
- Create Request Management:
  - `DoctorRequestsScreen` (`D-15`) with segmented status tabs.
  - `DoctorRequestDetailScreen` (`D-16`) with patient condition summary.
  - `DoctorDeclineSheet` (`D-16D`) with reason chips and note.
- Create Patient Management:
  - `DoctorPatientsListScreen` (`D-17`) with search and status chips.
  - `DoctorPatientDetailScreen` (`D-18`) with adherence and score trends.
  - `DoctorPatientPlanScreen` (`D-18b`) showing active and completed assignments.
  - `DoctorPatientSessionsScreen` (`D-18c`) with session history.
  - `DoctorPatientConditionScreen` (`D-18d`) with condition details and disconnect action.
- Create Assignment Wizard:
  - `DoctorAssignWizard` (`D-19`) (Choose exercise, Dose, Schedule).

### Phase 7: Doctor Portal — Exercise Builder, Reviews & Profile
- Create Exercise Management:
  - `DoctorExerciseLibraryScreen` (`D-20`) with category chips.
  - `DoctorExerciseBuilderWizard` (`D-21`) (4-step builder, forced Private).
  - `DoctorTestCameraScreen` (`D-22`) for real-time validation without saving progress.
- Create Session Feedback:
  - `DoctorSessionReviewScreen` (`D-23`) with rep-by-rep breakdown and feedback input.
- Create Doctor Notifications & Profile:
  - `DoctorNotificationsScreen` (`D-25`)
  - `DoctorProfileScreen` (`D-26`)
  - `DoctorEditProfileScreen` (`D-27`)
  - `DoctorUpdateCredentialsScreen` (`D-28`)
  - `DoctorSettingsScreen` (`D-29`)
  - `DoctorLogoutDialog` (`D-30`)

### Phase 8: Admin Portal — Applications, Oversight & Library
- Create Admin Auth:
  - `AdminLoginScreen` (`A-01`)
  - `AdminForgotPasswordScreen` (`A-02`) & `AdminResetPasswordScreen` (`A-03`)
  - `AdminBlockedScreen` (`A-25`)
- Create Admin Dashboard:
  - `AdminDashboardScreen` (`A-04`) with KPIs and alerts.
- Create Doctor Application Reviews:
  - `AdminApplicationsScreen` (`A-05`)
  - `AdminApplicationDetailScreen` (`A-06`)
  - `AdminDocumentViewerScreen` (`A-07`) with signed URL loading.
  - `AdminApproveDialog` (`A-08`) & `AdminRejectSheet` (`A-09`).
- Create Doctors & Patients Oversight:
  - `AdminDoctorsListScreen` (`A-10`) & `AdminDoctorDetailScreen` (`A-11`).
  - `AdminEditDoctorScreen` (`A-12`) & `AdminSuspendDialog` (`A-13`).
  - `AdminAddDoctorScreen` (`A-14`).
  - `AdminPatientsListScreen` (`A-15`) & `AdminPatientDetailScreen` (`A-16`) (Strictly no clinical data).
- Create Exercise Library & Test:
  - `AdminExerciseLibraryScreen` (`A-17`)
  - `AdminExerciseBuilderScreen` (`A-18`) (Can publish Public exercises).
  - `AdminTestCameraScreen` (`A-19`).
- Create Audit & Settings:
  - `AdminNotificationsScreen` (`A-20`)
  - `AdminAuditLogScreen` (`A-21`)
  - `AdminProfileScreen` (`A-22`), `AdminChangePasswordScreen` (`A-23`), `AdminLogoutDialog` (`A-24`).

### Phase 9: End-to-End Verification, Clinical Guardrails & Docs
- Verify clinical language across all 3 portals:
  - Ensure "Movement score" is used consistently.
  - Verify absence of diagnostic claims ("diagnose", "treatment", "injury risk").
  - Verify standard clinical disclaimers.
  - Verify rep outcome triples (Correct, Incorrect, Incomplete).
- Verify Product Rule 4 (zero video/image uploads or storage).
- Verify Product Rule 8 (soft-delete enforcement).
- Run full test suite: `flutter analyze` and `flutter test`.
- Compile final `docs/PROJECT_HANDOFF.md` update notes.

---

## 7. Risks, Assumptions & Mitigation Strategies

1. **Risk: Supabase Backend Cannot Be Run Live During Implementation**  
   *Mitigation:* All database scripts and Edge Functions are written as robust, self-contained migration and TypeScript files in `supabase/` following official Supabase syntax and tested against local repository unit tests. Comprehensive documentation is provided in `supabase/SETUP.md`.
2. **Risk: Pose Tracking Generalization Breaking Existing Exercises**  
   *Mitigation:* The refactored `TrackingEngine` will implement backward-compatible defaults. When an exercise lacks explicit multi-joint landmark configuration, it defaults to the verified knee landmark triplet (23-25-27 / 24-26-28), guaranteeing existing courses continue functioning identically.
3. **Risk: GoRouter Deep Hierarchy & Role Transitions**  
   *Mitigation:* We use a single centralized `AuthNotifier` that synchronizes auth state changes. All routes belong to dedicated path trees (`/`, `/doctor/*`, `/admin/*`). Root navigator keys are used for dialogs and modals to prevent shell overlay conflicts.
4. **Risk: Design Token Non-Compliance**  
   *Mitigation:* No hex codes will be written outside `lib/core/tokens.dart`. Every new screen and widget will use tokens from `RSColors`, `RSText`, `RSSpacing`, and `RSRadius`.
5. **Risk: Admin Accidental Access to Patient Health Data**  
   *Mitigation:* Dual-layer prevention: Database RLS explicitly rejects queries from `role = 'admin'` on tables `exercise_sessions`, `pain_logs`, and `patient_conditions`. UI models for admin patient detail screens omit clinical fields entirely.

---

## 8. Non-Blocking Questions for User

1. **Android Application ID:**  
   *Question:* The Android package ID in `android/app/build.gradle.kts` is currently `com.example.my_app`. Should this remain untouched for now to prevent cache/build invalidations, or would you like it renamed to `com.rehabsense.app` in a dedicated configuration pass?  
   *Proposed Answer:* Leave untouched during implementation to preserve Android build stability.
2. **Document Upload in Testing Environment:**  
   *Question:* During testing without live Supabase storage access, would you prefer the document picker in Doctor Onboarding (`D-04`) to generate mock local file references so the submission wizard can be fully exercised end-to-end?  
   *Proposed Answer:* Yes, provide local mock file fallbacks when offline so all screens and wizards can be thoroughly verified.
3. **Automated Test OTP Bypassing:**  
   *Question:* For automated widget and integration tests of `VerifyEmailScreen` (`P-05`, `D-03`), should entering `123456` or `000000` be accepted as a test bypass when running in debug/test mode?  
   *Proposed Answer:* Yes, accept `123456` in debug/test mode to enable seamless automated UI verification while enforcing strict Supabase verification in production builds.

---

**PLAN READY. Waiting for approval.**

