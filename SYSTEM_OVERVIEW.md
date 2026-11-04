# RehabSense: System Overview (3 Portals)

> **Portals:** Admin, Doctor, Patient (one Flutter app, role-based routing)
> **Backend:** Supabase (Auth, Postgres + RLS, Storage, Edge Functions)
> **Companion files:** `ADMIN_PORTAL.md`, `DOCTOR_PORTAL.md`, `PATIENT_PORTAL.md`
> **Base:** `PROJECT_HANDOFF.md` (existing patient app and its screens stay as they are unless stated)

Diagrams are written in Mermaid. They render in GitHub, VS Code (Markdown Preview Mermaid extension), Notion, Obsidian and most AI tools.

---

## 1. Final decisions

| # | Topic | Decision |
|---|---|---|
| 1 | Portals | Three: **Admin**, **Doctor** (physio is the same role), **Patient**. |
| 2 | Admin signup | **None.** Admin accounts are created manually in Supabase and given `role = admin` by SQL. Admin only has Login. |
| 3 | Admin entry point | A small "Staff login" link on the Welcome screen. Not a main button. |
| 4 | Admin powers | Add, update, soft-delete doctors, patients (account level) and exercises. Review doctor applications. Create public exercises. Common screens (profile, password, notifications, logout). |
| 5 | Doctor signup | Public registration with **license, degree and certificate documents**. |
| 6 | Doctor login before approval | **Not possible.** A pending doctor is blocked at the auth level (Supabase user ban) until the admin approves. |
| 7 | Email verification | Same OTP-code flow the app already uses. |
| 8 | Doctor profile | After approval the doctor sets up profile: expertise tags, bio, experience, clinic. |
| 9 | Patient to doctor | Patient fills a condition form, sees doctors matched by expertise, sends a request. Doctor accepts or declines. |
| 10 | Prescribed exercises | Prescribed container is always visible but **locked until a doctor is connected**. Doctor assigns exercises from the library or his own new ones. |
| 11 | Patient without doctor | Fully usable (Wellness/Yoga and Rehab library, tracking, progress). |
| 12 | Tracking | 2D only (x, y angles). Exercise has a camera view (Side or Front). Types: rep and hold. No video stored. |
| 13 | Deletes | **Soft delete only** (archive / disable). Hard delete is manual SQL. |
| 14 | One email, one role | A patient email cannot be reused as a doctor email. |

---

## 2. Portal map (whole app)

```mermaid
flowchart TD
  S["Splash"] --> SESS{"Valid session?"}
  SESS -->|"No"| W["Welcome"]
  SESS -->|"Yes"| GATE["Login Gate (section 3)"]

  W -->|"Patient: Create account / Login"| PA["Patient Auth"]
  W -->|"I am a Doctor"| DA["Doctor Auth"]
  W -->|"Staff login (small link)"| AA["Admin Login only"]

  PA --> GATE
  DA --> GATE
  AA --> GATE

  GATE -->|"role = patient"| PP["PATIENT PORTAL<br/>Home, Courses, Progress, Profile"]
  GATE -->|"role = doctor + approved"| DP["DOCTOR PORTAL<br/>Home, Patients, Exercises, Profile"]
  GATE -->|"role = admin"| ADP["ADMIN PORTAL<br/>Dashboard, Doctors, Patients, Exercises, More"]
  GATE -->|"role = doctor + not approved"| DLIM["Doctor limited screens<br/>(resume or rejected)"]

  PP --> LO["Logout"]
  DP --> LO
  ADP --> LO
  DLIM --> LO
  LO --> W
```

---

## 3. Login Gate (runs after every successful login and on every app start)

```mermaid
flowchart TD
  A["User submits email + password"] --> B{"Supabase auth result"}
  B -->|"Wrong credentials"| F1["Generic error: Email or password is wrong"]
  B -->|"User banned"| F2["Message: Account is not active yet.<br/>If you applied recently, your application is under review.<br/>Otherwise contact support."]
  B -->|"Too many attempts"| F3["Rate limit message + countdown"]
  B -->|"Network / server error"| F4["Offline or retry message"]
  B -->|"OK"| C["Load profile: role, account_status,<br/>doctor application status"]
  C --> D{"Login screen used vs role"}
  D -->|"Mismatch"| F5["Sign out immediately.<br/>Wrong portal message + link to correct login"]
  D -->|"Match"| E{"role"}

  E -->|"patient"| P1{"email verified?"}
  P1 -->|"No"| P2["Verify OTP screen"]
  P1 -->|"Yes"| P3{"onboarded?"}
  P3 -->|"No"| P4["Profile Setup + Consent"]
  P3 -->|"Yes"| P5["Patient Home"]

  E -->|"doctor"| DS{"application status"}
  DS -->|"incomplete"| D1["Resume Application (documents step)"]
  DS -->|"rejected"| D2["Application Rejected + resubmit"]
  DS -->|"approved"| D3{"profile complete?"}
  D3 -->|"No"| D4["Doctor Profile Setup"]
  D3 -->|"Yes"| D5["Doctor Home"]

  E -->|"admin"| A1["Admin Dashboard"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  classDef ok fill:#e6f7ee,stroke:#1e8449,color:#000;
  class F1,F2,F3,F4,F5 fail;
  class P5,D5,A1 ok;
```

Note: a **pending** doctor never reaches the "OK" branch because the auth user is banned. A **rejected** doctor is un-banned so he can see the reason and resubmit, but RLS gives him access to nothing except his own application.

---

## 4. Status model

| Field | Values | Who changes it |
|---|---|---|
| `profiles.role` | `patient`, `doctor`, `admin` | Server only (signup trigger sets `patient`; Edge Function sets `doctor`; SQL sets `admin`) |
| `profiles.account_status` | `active`, `disabled` | Admin via Edge Function |
| `doctor_applications.status` | `incomplete`, `pending`, `rejected`, `approved` | Edge Functions only |
| `connection_requests.status` | `pending`, `accepted`, `declined`, `expired`, `cancelled` | RPC functions only |
| `doctor_patients.status` | `active`, `ended` | RPC functions only |

### 4.1 Doctor application state machine

```mermaid
stateDiagram-v2
  [*] --> incomplete: Registered and email verified
  incomplete --> incomplete: Documents partly uploaded
  incomplete --> pending: Submit application (user banned)
  pending --> approved: Admin approves (user un-banned)
  pending --> rejected: Admin rejects with reason (user un-banned)
  rejected --> pending: Resubmit (max 3 attempts, user banned again)
  rejected --> [*]: 3 attempts used, contact support
  approved --> suspended: Admin suspends (user banned)
  suspended --> approved: Admin reactivates (user un-banned)
  approved --> approved: Edits credentials, re-review flag only
```

### 4.2 Connection request state machine

```mermaid
stateDiagram-v2
  [*] --> pending: Patient sends request
  pending --> accepted: Doctor accepts
  pending --> declined: Doctor declines (reason)
  pending --> cancelled: Patient cancels
  pending --> expired: 72 hours pass
  accepted --> [*]: doctor_patients row becomes active
  declined --> [*]
  cancelled --> [*]
  expired --> [*]
```

---

## 5. Key sequences

### 5.1 Doctor registration to first login

```mermaid
sequenceDiagram
  autonumber
  actor Doc as Doctor
  participant App
  participant Auth as Supabase Auth
  participant EF as Edge Functions
  participant ST as Storage (private)
  actor Adm as Admin

  Doc->>App: Fill registration form
  App->>EF: register-doctor (name, email, password, clinic, license no)
  EF->>Auth: Create user (role forced to doctor, status incomplete)
  Auth-->>Doc: Email with OTP code
  Doc->>App: Enter OTP
  App->>Auth: verifyOtp (session created)
  Doc->>App: Pick license, degree, certificates
  App->>ST: Upload to doctor-documents/{doctor_id}/...
  Doc->>App: Review and Submit
  App->>EF: submit-doctor-application
  EF->>EF: Check required documents exist, file types, license not duplicate
  EF->>Auth: Ban user, revoke sessions
  EF-->>Adm: Notification: new application
  EF-->>Doc: Email: application received
  App-->>Doc: "Application submitted" screen (signed out)

  Adm->>EF: admin-review-doctor (approve)
  EF->>Auth: Un-ban user
  EF->>EF: status approved, audit log written
  EF-->>Doc: Email: approved, you can log in
  Doc->>App: Login
  App->>Doc: Profile Setup then Doctor Home
```

### 5.2 Patient request to prescribed exercise

```mermaid
sequenceDiagram
  autonumber
  actor Pat as Patient
  participant App
  participant DB as Supabase (RLS + RPC)
  actor Doc as Doctor

  Pat->>App: Connect with Doctor
  Pat->>App: Fill condition form
  App->>DB: Query doctor_directory (approved, listed, accepting)
  DB-->>App: Doctors sorted by expertise match
  Pat->>App: Open doctor profile, Send request
  App->>DB: send_connection_request (condition snapshot)
  DB-->>Doc: Notification: new request
  Doc->>DB: respond_connection_request (accept)
  DB->>DB: Create doctor_patients link, cancel other pending
  DB-->>Pat: Notification: accepted
  Note over Pat: Prescribed container unlocks
  Doc->>DB: create_assignment (exercise, sets, reps, days, note)
  DB-->>Pat: Notification: new exercise assigned
  Pat->>App: Do exercise with camera tracking
  App->>DB: Save session (assignment id, pain, comment)
  DB-->>Doc: Session visible, alert if pain is high
  Doc->>DB: Add feedback
  DB-->>Pat: Notification: doctor feedback
```

---

## 6. Data model

```mermaid
erDiagram
  PROFILES ||--o| DOCTOR_APPLICATIONS : "applies"
  PROFILES ||--o| DOCTOR_PROFILES : "has"
  DOCTOR_APPLICATIONS ||--o{ APPLICATION_DOCUMENTS : "contains"
  PROFILES ||--o{ CONNECTION_REQUESTS : "patient sends"
  PROFILES ||--o{ CONNECTION_REQUESTS : "doctor receives"
  PROFILES ||--o{ DOCTOR_PATIENTS : "links"
  PROFILES ||--o{ ASSIGNMENTS : "doctor prescribes"
  PROFILES ||--o{ SESSIONS : "patient performs"
  EXERCISES ||--o{ ASSIGNMENTS : "used in"
  ASSIGNMENTS ||--o{ SESSIONS : "tracked by"
  SESSIONS ||--o{ REPS : "has"
  SESSIONS ||--o{ SESSION_FEEDBACK : "gets"
  PROFILES ||--o{ NOTIFICATIONS : "receives"
  PROFILES ||--o{ AUDIT_LOG : "admin actions"

  PROFILES {
    uuid id PK
    text role
    text account_status
    timestamptz onboarded_at
  }
  DOCTOR_APPLICATIONS {
    uuid doctor_id PK
    text status
    text license_number
    text degree
    int attempt_count
    text reject_reason
    uuid reviewed_by
  }
  APPLICATION_DOCUMENTS {
    uuid id PK
    uuid doctor_id
    text doc_type
    text storage_path
  }
  DOCTOR_PROFILES {
    uuid doctor_id PK
    text title
    text clinic_name
    text_array expertise_tags
    text bio
    int years_experience
    bool accepting_patients
    bool listed
  }
  CONNECTION_REQUESTS {
    uuid id PK
    uuid patient_id
    uuid doctor_id
    jsonb condition_snapshot
    text status
    timestamptz expires_at
  }
  DOCTOR_PATIENTS {
    uuid id PK
    uuid doctor_id
    uuid patient_id
    text status
  }
  EXERCISES {
    text id PK
    uuid author_id
    text category
    text kind
    text camera_view
    jsonb tracking_config
    text visibility
    bool is_active
  }
  ASSIGNMENTS {
    uuid id PK
    uuid doctor_id
    uuid patient_id
    text exercise_id
    int sets
    text status
  }
  SESSIONS {
    text id PK
    uuid user_id
    uuid assignment_id
    int pain_level
  }
```

---

## 7. Security layers

```mermaid
flowchart LR
  U["App screen"] --> G["1. Route guard<br/>(role + status)"]
  G --> R["2. RLS on every table<br/>(is_admin, is_approved_doctor, is_linked_doctor)"]
  R --> E["3. Edge Functions for sensitive actions<br/>(service key stays on server)"]
  E --> B["4. Auth ban for pending / suspended users"]
  R --> S["5. Private Storage with signed URLs"]
```

| Rule | Why |
|---|---|
| Role is never read from signup metadata | Anyone could send `role: doctor` |
| `guard_profile_protected_cols` trigger | Logged-in users cannot change `role` or `account_status` |
| `is_approved_doctor()` in every doctor policy | A rejected or incomplete doctor can log in but sees nothing |
| Documents bucket is private, access via short-lived signed URLs (60 s) | License and degree files are sensitive |
| Admin sees patient **account info only**, not sessions or condition | Privacy of health data |
| Every admin action writes `audit_log` | Accountability |
| Service key only in Edge Functions | Never inside the app |

---

## 8. Edge Functions and RPCs

| Name | Caller | Server checks | Effect |
|---|---|---|---|
| `register-doctor` | Public | Email not already used, password rules, rate limit | Creates auth user, role `doctor`, application `incomplete` |
| `submit-doctor-application` | Doctor (incomplete or rejected) | Required docs exist, file type and size, license number not duplicate, attempts under 3 | Status `pending`, ban user, notify admin |
| `admin-review-doctor` | Admin | Caller is admin, application is `pending` | Approve: un-ban, `approved`. Reject: un-ban, `rejected` + reason. Email + audit log |
| `admin-set-account-status` | Admin | Caller is admin, target is not self | Suspend or reactivate doctor or patient (DB status + auth ban) |
| `admin-add-doctor` (optional) | Admin | Caller is admin, email unused | Invite email, doctor pre-approved (admin vouches) |
| `get-document-url` | Admin or owning doctor | Role check | 60 second signed URL |
| `send_connection_request` | Patient | No active doctor, under 3 pending, doctor listed and accepting | Creates request |
| `respond_connection_request` | Doctor | Own request, pending, capacity | Accept creates link and cancels the patient's other pending requests |
| `end_connection` | Patient or linked doctor | Part of the link | Link ended, assignments paused |
| `create_assignment` | Linked approved doctor | Patient linked, exercise active, dates valid | Creates assignment and notification |
| `expire_requests` (cron, hourly) | System | `expires_at` passed | `pending` becomes `expired` |
| `purge_rejected_documents` (cron, daily) | System | Rejected for more than 30 days | Deletes files from storage |

---

## 9. Notifications and emails

| Event | To | Channel |
|---|---|---|
| New doctor application | Admin | In-app |
| Application received | Doctor | Email |
| Application approved | Doctor | Email + (on login) in-app |
| Application rejected + reason | Doctor | Email |
| Doctor suspended | Doctor (email), linked patients (in-app) | Email, in-app |
| New connection request | Doctor | In-app |
| Request accepted / declined / expired | Patient | In-app |
| New assignment / plan updated | Patient | In-app |
| Doctor feedback | Patient | In-app |
| Pain 7 or more reported | Doctor | In-app |
| No session for 3 days | Doctor | In-app |
| Patient disconnected | Doctor | In-app |

Production note: Supabase's default email service is very limited. Configure a custom SMTP provider before testing with real users.

---

## 10. Storage

| Bucket | Visibility | Who can write | Who can read |
|---|---|---|---|
| `doctor-documents` | Private | The doctor, only while status is `incomplete` or `rejected` | The doctor (own folder), admin |
| `avatars` (phase 2) | Private | Owner | Owner, linked users |

Document rules: PDF, JPG, PNG only. 5 MB max per file. License and degree are required, certificates optional (up to 3). The Edge Function checks the real file type, not only the extension.

---

## 11. Extra improvements added to your idea

| # | Improvement | Benefit |
|---|---|---|
| 1 | Pending doctor blocked by auth ban, not only by hiding screens | Truly cannot log in until approved |
| 2 | `incomplete` status and resume screen | A doctor who closes the app mid-registration can continue |
| 3 | 3 resubmission attempts | Stops spam |
| 4 | Duplicate license number check | One license cannot create many doctors |
| 5 | Rejected documents auto-deleted after 30 days | Privacy and storage cost |
| 6 | Verified badge on doctor profile | Patient trust (means documents were checked, not a medical guarantee) |
| 7 | Editing license or degree later triggers re-review but the doctor stays active meanwhile | Keeps credentials trustworthy |
| 8 | Audit log | Dispute handling |
| 9 | Admin cannot see patient sessions or conditions | Health data privacy |
| 10 | Soft delete everywhere | Sessions and assignments never break |
| 11 | Optional admin MFA (TOTP) in phase 2 | Admin account is the most valuable target |
| 12 | Doctor suspended mid-way: patients notified, old assignments stay viewable until end date | Patients are not left confused |
| 13 | Safety Alert for red-flag symptoms in the condition form | Clinical safety |

---

## 12. Build phases

| Phase | Work | Result |
|---|---|---|
| 0 | Custom SMTP, auth redirect and deep links, storage bucket | Emails and uploads work |
| 1 | Roles, statuses, guard trigger, RLS helpers, router redirect, move patient data from in-memory seed to Supabase | Foundation |
| 2 | Admin account (SQL), Admin Login, Dashboard shell | Admin can enter |
| 3 | Doctor registration, documents, submit, ban, admin review, approve and reject | Doctor onboarding works end to end |
| 4 | Doctor profile setup, directory view | Doctors appear to patients |
| 5 | Patient condition form, request flow, doctor accept and decline | Connection works |
| 6 | Assign exercise, prescribed container, pain report, feedback | Core clinical loop |
| 7 | Config-based tracking (rep and hold), exercise builder, yoga poses | Doctor and admin can create exercises |
| 8 | Admin management screens (doctors, patients, exercises, audit log) | Admin complete |
| 9 | Polish, empty and error states, full test pass | Demo ready |

---

## 13. Test cases (must pass)

| # | Test | Expected |
|---|---|---|
| 1 | Pending doctor tries to log in | Blocked, inactive-account message |
| 2 | Doctor closes app after OTP, before documents | Next login shows Resume Application |
| 3 | Rejected doctor logs in | Only the rejected screen, no doctor data |
| 4 | Rejected doctor resubmits 4 times | 4th attempt refused |
| 5 | Patient token calls `admin-review-doctor` | 403 |
| 6 | Doctor token calls `admin-review-doctor` | 403 |
| 7 | Client updates own `role` | Rejected by trigger |
| 8 | Patient opens a doctor document URL | Denied |
| 9 | Unapproved doctor reads any patient data | Empty |
| 10 | Admin reads a patient's sessions | Empty |
| 11 | Duplicate license number on second doctor | Refused |
| 12 | Doctor suspended while patients linked | Patients notified, no new assignments |
| 13 | Patient has 3 pending requests, sends a 4th | Refused |
| 14 | Two admins review the same application | Only the first succeeds |
| 15 | Patient email used in doctor registration | Refused with clear message |
