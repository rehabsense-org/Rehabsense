# RehabSense: Admin Portal Architecture

> Scope: everything an admin does, from Splash to Logout.
> Companion: `SYSTEM_OVERVIEW.md` (status model, security, functions), `DOCTOR_PORTAL.md`, `PATIENT_PORTAL.md`.

---

## 1. Principles

- **No signup.** Admin accounts exist only because the owner created them in Supabase.
- Admin enters from a small **"Staff login"** link on the Welcome screen.
- Every admin action is checked **on the server** (Edge Function) and written to the **audit log**.
- Admin can add, update and **soft-delete** doctors, patients (account level) and exercises.
- Admin sees patient **account info only**, never sessions or health conditions.

### 1.1 How an admin account is created (one time, by the owner)

```mermaid
flowchart LR
  A["Supabase Dashboard<br/>Authentication > Add user<br/>(email + password, auto confirm)"] --> B["SQL Editor:<br/>update profiles set role = 'admin'<br/>where email = '...'"]
  B --> C["Admin can now log in<br/>from the Staff login link"]
```

---

## 2. Screen inventory

| ID | Screen | Route | Purpose |
|---|---|---|---|
| A-01 | Admin Login | `/admin/login` | Email + password, no signup |
| A-02 | Forgot Password | `/admin/forgot-password` | Email reset link |
| A-03 | Reset Password | `/admin/reset-password` | Set new password from link |
| A-04 | Dashboard | `/admin/dashboard` | Counts, pending applications, alerts |
| A-05 | Doctor Applications | `/admin/applications` | Pending, Rejected, Approved tabs |
| A-06 | Application Detail | `/admin/applications/:id` | Doctor info and document viewer |
| A-07 | Document Viewer | `/admin/applications/:id/doc/:docId` | Full screen file via signed URL |
| A-08 | Approve Confirm | dialog | Confirm approval |
| A-09 | Reject Sheet | bottom sheet | Reason chips + note |
| A-10 | Doctors List | `/admin/doctors` | Search, filter by status |
| A-11 | Doctor Detail | `/admin/doctors/:id` | Profile, status, patient count, history |
| A-12 | Edit Doctor | `/admin/doctors/:id/edit` | Limited fields (title, clinic, tags) |
| A-13 | Suspend / Reactivate | dialog | Reason, confirm |
| A-14 | Add Doctor (optional) | `/admin/doctors/new` | Direct invite, skips documents |
| A-15 | Patients List | `/admin/patients` | Account info only |
| A-16 | Patient Detail | `/admin/patients/:id` | Name, email, joined, status, linked doctor |
| A-17 | Exercise Library | `/admin/exercises` | All exercises, filters |
| A-18 | Exercise Builder | `/admin/exercises/new` and `/:id/edit` | Create or edit |
| A-19 | Test Exercise | `/admin/exercises/:id/test` | Admin tries tracking on camera |
| A-20 | Notifications | `/admin/notifications` | Inbox |
| A-21 | Audit Log | `/admin/audit` | Who did what, when |
| A-22 | Admin Profile | `/admin/profile` | Name, email, security |
| A-23 | Change Password | `/admin/change-password` | In-app change |
| A-24 | Logout Confirm | dialog | Confirm and sign out |
| A-25 | Inactive / Wrong Portal | `/admin/blocked` | Generic blocked messages |

### 2.1 Navigation map (bottom bar)

```mermaid
flowchart TD
  NAV["Bottom navigation"] --> T1["Dashboard"]
  NAV --> T2["Doctors"]
  NAV --> T3["Patients"]
  NAV --> T4["Exercises"]
  NAV --> T5["More"]

  T2 --> T2a["Applications (badge)"]
  T2 --> T2b["All doctors"]

  T5 --> M1["Notifications"]
  T5 --> M2["Audit Log"]
  T5 --> M3["Profile"]
  T5 --> M4["Change Password"]
  T5 --> M5["Logout"]
```

---

## 3. Master flow (Splash to Logout)

```mermaid
flowchart TD
  S["Splash"] --> SESS{"Session?"}
  SESS -->|"No"| W["Welcome"]
  W -->|"Staff login link"| L["A-01 Admin Login"]
  SESS -->|"Yes, role admin"| D
  L -->|"Success"| D["A-04 Dashboard"]
  L -->|"Forgot password"| FP["A-02 / A-03 Reset flow"]
  FP --> L

  D --> APP["A-05 Applications"]
  D --> DOC["A-10 Doctors"]
  D --> PAT["A-15 Patients"]
  D --> EX["A-17 Exercises"]
  D --> MORE["More"]

  APP --> AD["A-06 Application Detail"]
  AD --> APR["Approve"]
  AD --> REJ["Reject with reason"]
  APR --> APP
  REJ --> APP

  DOC --> DD["A-11 Doctor Detail"]
  DD --> DE["A-12 Edit"]
  DD --> DS["A-13 Suspend / Reactivate"]
  DOC --> DN["A-14 Add Doctor (optional)"]

  PAT --> PD["A-16 Patient Detail"]
  PD --> PS["Disable / Enable"]

  EX --> EB["A-18 Builder"]
  EB --> ET["A-19 Test"]
  ET --> EX

  MORE --> NO["A-20 Notifications"]
  MORE --> AU["A-21 Audit Log"]
  MORE --> PR["A-22 Profile"]
  PR --> CP["A-23 Change Password"]
  PR --> LO["A-24 Logout"]
  LO --> W
```

---

## 4. Login (A-01) with all failure paths

```mermaid
flowchart TD
  A["A-01 Admin Login<br/>Email, Password, Forgot password"] --> V{"Fields valid?"}
  V -->|"No"| E1["Inline field errors, button disabled"]
  V -->|"Yes"| AUTH{"Supabase auth"}

  AUTH -->|"Wrong credentials"| E2["Generic: Email or password is wrong<br/>(never reveal which)"]
  AUTH -->|"Rate limited"| E3["Too many attempts. Try again in N minutes"]
  AUTH -->|"No internet"| E4["Offline banner, retry"]
  AUTH -->|"Server error"| E5["Something went wrong, retry"]
  AUTH -->|"OK"| ROLE{"profiles.role = admin<br/>and account_status = active?"}

  ROLE -->|"No (patient or doctor account)"| E6["Sign out immediately.<br/>Message: This account cannot use the staff portal"]
  ROLE -->|"Yes"| OK["A-04 Dashboard"]

  E2 --> A
  E3 --> A
  E4 --> A
  E5 --> A
  E6 --> A

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E1,E2,E3,E4,E5,E6 fail;
```

Forgot password: **A-02** (enter email, always the same "if registered, a link was sent" message) then email link opens the app, **A-03** (new password + confirm). Expired link shows "Link no longer works" with a button to request a new one.

---

## 5. Dashboard (A-04)

```mermaid
flowchart TD
  D["A-04 Dashboard"] --> K1["Pending applications (tap: A-05 Pending tab)"]
  D --> K2["Active doctors (tap: A-10)"]
  D --> K3["Patients (tap: A-15)"]
  D --> K4["Exercises: public / private (tap: A-17)"]
  D --> AL["Alerts: applications older than 3 days,<br/>suspended doctors, failed emails"]
  D --> RA["Recent activity (last 10 audit entries)"]
```

| State | Behaviour |
|---|---|
| Loading | Skeleton tiles |
| Nothing pending | "No applications waiting" |
| Error | "Could not load" + Retry |
| Offline | Cached numbers + offline banner, action buttons disabled |

---

## 6. Doctor application review (core admin task)

### 6.1 Flow

```mermaid
flowchart TD
  L["A-05 Applications list<br/>Tabs: Pending, Rejected, Approved"] --> I["Tap an application"]
  I --> DET["A-06 Application Detail<br/>Name, email, clinic, license no, degree,<br/>years, submitted at, attempt number"]
  DET --> DOCS["Documents list: license, degree, certificates"]
  DOCS --> VIEW["A-07 Document Viewer<br/>(60 second signed URL)"]
  VIEW --> CHK["Review checklist (optional ticks):<br/>Name matches, License number matches,<br/>Degree valid, Document readable"]
  CHK --> DEC{"Decision"}

  DEC -->|"Approve"| AC["A-08 Confirm dialog"]
  AC -->|"Confirm"| AP["Edge Function admin-review-doctor<br/>status approved, un-ban, audit log, email"]
  AP --> DONE1["Back to list, snackbar: Dr. X approved"]

  DEC -->|"Reject"| RS["A-09 Reject sheet<br/>Reason chips + note (required)"]
  RS -->|"Submit"| RJ["Edge Function admin-review-doctor<br/>status rejected, un-ban, audit log, email with reason"]
  RJ --> DONE2["Back to list, snackbar: Dr. X rejected"]

  DEC -->|"Not sure"| BACK["Leave as pending, come back later"]
```

Reject reason chips: *License not readable*, *License number does not match*, *Degree missing or invalid*, *Name mismatch*, *Suspicious document*, *Other* (note required for Other).

### 6.2 Sequence (approve or reject)

```mermaid
sequenceDiagram
  autonumber
  actor Adm as Admin
  participant App
  participant EF as Edge Function
  participant Auth as Supabase Auth
  participant DB as Database
  actor Doc as Doctor

  Adm->>App: Open application, view documents
  App->>EF: get-document-url (doc id)
  EF->>EF: Verify caller is admin
  EF-->>App: Signed URL (60 s)
  Adm->>App: Approve or Reject
  App->>EF: admin-review-doctor (id, decision, reason)
  EF->>EF: Verify admin, application is pending
  EF->>DB: Update status, reviewed_by, reviewed_at, reject_reason
  EF->>Auth: Un-ban user
  EF->>DB: Write audit_log
  EF-->>Doc: Email with decision
  EF-->>App: Success
```

### 6.3 Failure paths

| Failure | What admin sees | Next step |
|---|---|---|
| Another admin already reviewed it | "This application was already reviewed by X" | List refreshes |
| Document URL expired | "Link expired" with Reload button | Tap to get a new URL |
| Document fails to load (corrupt, deleted) | "Could not open file" | Reject with reason "Document not readable" |
| Reject without a reason | Submit disabled | Add reason |
| Email to doctor failed | Decision is saved, banner: "Email not sent" with **Resend** | Resend |
| Network error during decision | "Not saved, try again" (action is idempotent) | Retry |
| Application withdrawn or doctor deleted | "Application no longer exists" | Back to list |

---

## 7. Doctors management

### 7.1 Flow

```mermaid
flowchart TD
  L["A-10 Doctors list<br/>Search, filter: Active, Suspended, Pending, Rejected"] --> D["A-11 Doctor Detail<br/>Profile, expertise, verified badge,<br/>patients count, application history, audit entries"]
  D --> E["A-12 Edit Doctor<br/>Title, clinic, expertise tags, listed toggle"]
  D --> S{"Status action"}
  S -->|"Active"| SU["A-13 Suspend dialog<br/>Reason required"]
  S -->|"Suspended"| RE["A-13 Reactivate dialog"]
  D --> DEL["Delete (soft): archive account"]

  SU --> EFS["Edge Function admin-set-account-status<br/>account_status disabled, auth ban,<br/>pause new assignments, notify linked patients"]
  RE --> EFR["Edge Function admin-set-account-status<br/>active, un-ban"]
  DEL --> CF{"Has linked patients?"}
  CF -->|"Yes"| W["Warn: N patients linked.<br/>They will be notified and moved to No doctor"]
  CF -->|"No"| OKD["Archive doctor"]
  W -->|"Confirm"| OKD

  L --> N["A-14 Add Doctor (optional)<br/>Name, email, clinic, title"]
  N --> INV["Invite email, doctor sets password,<br/>pre-approved, profile setup next"]
```

### 7.2 Rules and failures

| Rule or failure | Behaviour |
|---|---|
| Admin cannot suspend or delete **own** account | Button hidden, server also refuses |
| Suspend effect | Doctor cannot log in. Linked patients get "Dr. X is not available". Their existing assignments stay viewable until end date. No new assignments |
| Delete is soft | `account_status = disabled`, `archived_at` set. Sessions and assignments remain |
| Edit changes license or degree | Not allowed here. Doctor must upload new documents (re-review) |
| Add Doctor email already exists | "This email already has an account (patient or doctor)". Never convert a patient |
| Invite email fails | Doctor created as **Invite pending** with Resend button |
| Action fails (network or server) | "Could not save" and status stays unchanged |
| Doctor is currently in the middle of a session review | No effect, they are signed out on the next request |

---

## 8. Patients management

```mermaid
flowchart TD
  L["A-15 Patients list<br/>Search by name or email, filter: Active, Disabled"] --> D["A-16 Patient Detail<br/>Name, email, joined date, last active,<br/>account status, linked doctor"]
  D --> X["Disable or Enable (reason)"]
  D --> DEL["Delete (soft)"]
  X --> EF["admin-set-account-status<br/>(auth ban + status)"]
  DEL --> CONF["Confirm: data kept for records,<br/>patient cannot log in"]
  CONF --> EF
```

| Rule | Detail |
|---|---|
| Visible | Name, email, joined, last active, status, linked doctor name |
| **Not visible** | Sessions, pain, condition form, progress (health data) |
| Disabled patient | Login shows the generic inactive-account message. Linked doctor is notified |
| Failure | Same pattern: "Could not save, retry". Self-disable not applicable |

---

## 9. Exercise management (admin creates public exercises)

### 9.1 Flow

```mermaid
flowchart TD
  L["A-17 Exercise Library<br/>Filters: category (rehab, yoga, general),<br/>type (rep, hold), visibility, status"] --> N["New exercise"]
  L --> ED["Open an exercise"]
  N --> B1
  ED --> B1

  subgraph BUILDER ["A-18 Exercise Builder (4 steps)"]
    B1["1 Basics<br/>Name, category, body part,<br/>steps, precautions"] --> B2["2 Tracking<br/>Type rep or hold,<br/>camera view Side or Front,<br/>joint (3 points), left/right/auto"]
    B2 --> B3["3 Targets<br/>Rep: start angle, target angle, tolerance, reps, sets<br/>Hold: angle range, hold seconds, sets"]
    B3 --> B4["4 Review<br/>Summary + visibility (Public or Private)"]
  end

  B4 --> T["A-19 Test on camera"]
  T -->|"Tracking looks right"| SAVE["Save (tested)"]
  T -->|"Not right"| B3
  B4 --> SAVE2["Save without test (Untested badge)"]
  SAVE --> L
  SAVE2 --> L

  L --> AR["Archive (soft delete)"]
  AR --> CHK{"Assigned to active patients?"}
  CHK -->|"Yes"| WARN["Warn: N patients. Existing assignments continue,<br/>new assignments blocked"]
  CHK -->|"No"| DONE["Archived"]
  WARN -->|"Confirm"| DONE
```

### 9.2 Validation and failures

| Check | Message |
|---|---|
| Name 3 to 60 characters, unique | "Name is too short" or "An exercise with this name exists" |
| At least 2 steps | "Add at least two steps" |
| Start and target angle differ by 20 degrees or more | "Angles are too close to track reliably" |
| Hold: min < max, hold seconds 3 to 120 | Inline errors |
| 2D warning when the movement is toward or away from the camera | Yellow banner: "Depth movement is not tracked well. Choose Side or Front carefully" |
| Save fails or offline | Draft stored locally, "Try again" |
| Leave builder with unsaved changes | "Save draft?" dialog |
| Camera permission denied in test | Camera Help screen |
| Body not in frame during test | "Move back so your whole body is visible" |

Visibility: admin may set **Public** (shown to every patient in the library) or **Private**. Doctors can only create Private exercises.

---

## 10. Common screens

```mermaid
flowchart TD
  M["More"] --> N["A-20 Notifications<br/>New application, failed email, doctor suspended"]
  M --> AU["A-21 Audit Log<br/>Filter by action, admin, date"]
  M --> P["A-22 Admin Profile"]
  P --> CP["A-23 Change Password<br/>Old password, new, confirm"]
  P --> LO["A-24 Logout confirm"]
  LO -->|"Confirm"| W["Welcome"]
  CP -->|"Wrong old password"| E1["Inline error"]
  CP -->|"Weak or same as old"| E2["Inline error"]
  CP -->|"Success"| OK["Snackbar, stay signed in"]
```

Audit log row: `admin, action, target type, target id, before/after summary, time`. Read-only, no edit or delete.

---

## 11. Global states (every admin screen)

| State | Behaviour |
|---|---|
| Offline | Banner on top, cached data shown, write buttons disabled |
| Session expired | Dialog then Login (unsaved builder draft kept locally) |
| Admin account disabled or role changed | Next request fails, **A-25** generic blocked screen, sign out |
| 403 from a function | "You do not have permission", never raw error text |
| 5xx | "Something went wrong" + Retry |

---

## 12. Admin portal checklist

- [ ] No signup route exists for admin
- [ ] "Staff login" link is small and secondary on Welcome
- [ ] Every admin action goes through an Edge Function that re-checks `is_admin()`
- [ ] Service key never in the app
- [ ] Documents opened only through 60 second signed URLs
- [ ] Audit log written for approve, reject, suspend, reactivate, delete, exercise publish
- [ ] Admin cannot read patient sessions or conditions (RLS)
- [ ] Soft delete everywhere
- [ ] Phase 2: TOTP multi-factor for admin
