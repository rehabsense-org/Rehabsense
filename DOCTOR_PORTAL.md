# RehabSense: Doctor Portal Architecture

> Scope: everything a doctor or physio does, from Splash to Logout.
> Companion: `SYSTEM_OVERVIEW.md`, `ADMIN_PORTAL.md`, `PATIENT_PORTAL.md`.

---

## 1. Principles

- Doctor **registers publicly** but **cannot log in until the admin approves** (blocked at the auth level).
- Registration is one guided wizard: **account, email OTP, documents, submit**.
- After approval the doctor sets up an **expertise profile** and only then appears to patients.
- A doctor sees **only his own linked patients**. All of this is enforced by RLS (`is_approved_doctor`, `is_linked_doctor`), not only by hiding screens.

---

## 2. Screen inventory

### 2.1 Onboarding and gate screens

| ID | Screen | Route | Purpose |
|---|---|---|---|
| D-01 | Doctor Login | `/doctor/login` | Email + password |
| D-02 | Register: Account | `/doctor/register` | Name, email, password, phone, clinic, license number |
| D-03 | Register: Verify Email | `/doctor/verify-email` | OTP code (same as patient app) |
| D-04 | Register: Documents | `/doctor/documents` | License, degree, certificates |
| D-05 | Register: Review and Submit | `/doctor/submit` | Summary, declaration, submit |
| D-06 | Application Submitted | `/doctor/submitted` | Signed out, what happens next |
| D-07 | Resume Application | `/doctor/resume` | For `incomplete` status |
| D-08 | Application Rejected | `/doctor/rejected` | Reason, resubmit |
| D-09 | Inactive Account | `/doctor/inactive` | Generic blocked message |
| D-10 | Forgot Password | `/doctor/forgot-password` | Email |
| D-11 | Reset Password | `/doctor/reset-password` | New password |
| D-12 | Profile Setup (wizard) | `/doctor/setup` | Expertise, bio, experience, clinic, availability |
| D-13 | Profile Preview and Go Live | `/doctor/setup/preview` | How patients see you, toggle listed |

### 2.2 Main portal screens

| ID | Screen | Route |
|---|---|---|
| D-14 | Home Dashboard | `/doctor/home` |
| D-15 | Patient Requests | `/doctor/requests` |
| D-16 | Request Detail | `/doctor/requests/:id` |
| D-17 | My Patients | `/doctor/patients` |
| D-18 | Patient Detail | `/doctor/patients/:pid` |
| D-19 | Assign Exercise (3 steps) | `/doctor/patients/:pid/assign` |
| D-20 | Exercise Library | `/doctor/exercises` |
| D-21 | Exercise Builder | `/doctor/exercises/new` |
| D-22 | Test Exercise | `/doctor/exercises/:id/test` |
| D-23 | Session Review and Feedback | `/doctor/patients/:pid/sessions/:sid` |
| D-24 | Invite Code (optional) | `/doctor/invite` |
| D-25 | Notifications | `/doctor/notifications` |
| D-26 | Doctor Profile | `/doctor/profile` |
| D-27 | Edit Profile and Expertise | `/doctor/profile/edit` |
| D-28 | Update Credentials (re-review) | `/doctor/profile/credentials` |
| D-29 | Settings, Change Password, Notification Prefs | `/doctor/settings` |
| D-30 | Logout Confirm | dialog |

### 2.3 Navigation map (bottom bar)

```mermaid
flowchart TD
  NAV["Bottom navigation"] --> T1["Home"]
  NAV --> T2["Patients"]
  NAV --> T3["Exercises"]
  NAV --> T4["Profile"]

  T2 --> T2a["Requests (badge)"]
  T2 --> T2b["My Patients"]
  T3 --> T3a["My Exercises"]
  T3 --> T3b["Library (public)"]
  T4 --> T4a["Edit Profile"]
  T4 --> T4b["Credentials"]
  T4 --> T4c["Notifications"]
  T4 --> T4d["Settings"]
  T4 --> T4e["Logout"]
```

---

## 3. Master flow (Splash to Logout)

```mermaid
flowchart TD
  S["Splash"] --> SESS{"Session?"}
  SESS -->|"No"| W["Welcome"]
  W -->|"I am a Doctor"| CH{"New or existing?"}
  CH -->|"New"| REG["Registration wizard (section 4)"]
  CH -->|"Existing"| LOG["D-01 Login (section 5)"]

  REG --> SUB["D-06 Application Submitted<br/>(signed out)"]
  SUB --> WAIT["Waits for admin"]
  WAIT -->|"Approved + email"| LOG
  WAIT -->|"Rejected + email"| LOG

  LOG --> GATE{"Application status"}
  SESS -->|"Yes"| GATE
  GATE -->|"incomplete"| RES["D-07 Resume Application"]
  GATE -->|"rejected"| REJ["D-08 Rejected + resubmit"]
  GATE -->|"approved, profile incomplete"| SET["D-12 Profile Setup"]
  GATE -->|"approved, profile complete"| HOME["D-14 Home"]

  RES --> SUB
  REJ --> SUB
  SET --> PREV["D-13 Preview and Go Live"] --> HOME

  HOME --> REQ["D-15 Requests"]
  HOME --> PAT["D-17 My Patients"]
  HOME --> EX["D-20 Exercises"]
  HOME --> PRO["D-26 Profile"]

  REQ --> RD["D-16 Request Detail"]
  RD -->|"Accept"| PAT
  PAT --> PD["D-18 Patient Detail"]
  PD --> AS["D-19 Assign Exercise"]
  PD --> SR["D-23 Session Review"]
  EX --> EB["D-21 Builder"] --> ET["D-22 Test"] --> EX
  PRO --> LO["D-30 Logout"]
  LO --> W
```

---

## 4. Registration wizard (signup to submit)

### 4.1 Flow

```mermaid
flowchart TD
  R["D-02 Account<br/>Name, email, password, confirm, phone,<br/>clinic or hospital name, license number, title<br/>(Doctor or Physiotherapist)"] --> V{"Valid?"}
  V -->|"No"| RE1["Inline errors"]
  V -->|"Yes"| EF["Edge Function register-doctor"]
  EF --> CHK{"Checks"}
  CHK -->|"Email already used"| E1["This email is already registered.<br/>Login or Forgot password"]
  CHK -->|"Email belongs to a patient"| E2["Use a different email for a doctor account"]
  CHK -->|"License number already used"| E3["This license number is already registered.<br/>Contact support"]
  CHK -->|"Rate limit"| E4["Try again later"]
  CHK -->|"OK"| OTP["D-03 Verify Email<br/>6 digit code"]

  OTP -->|"Correct"| DOCS["D-04 Documents"]
  OTP -->|"Wrong code"| O1["Inline error, attempts counted"]
  OTP -->|"Expired"| O2["Code expired, Resend"]
  OTP -->|"Resend (60 s cooldown)"| OTP
  OTP -->|"Wrong email typed"| O3["Change email, back to D-02"]

  DOCS --> UP["Upload each file<br/>License (required), Degree (required),<br/>Certificates (optional, up to 3)"]
  UP --> UCHK{"File check"}
  UCHK -->|"Not PDF/JPG/PNG"| U1["Unsupported file type"]
  UCHK -->|"Over 5 MB"| U2["File too large"]
  UCHK -->|"Upload failed"| U3["Retry this file only, others are kept"]
  UCHK -->|"OK"| UOK["File shown with preview, replace, remove"]
  UOK --> NEXT{"License and degree present?"}
  NEXT -->|"No"| NB["Continue button disabled"]
  NEXT -->|"Yes"| REV["D-05 Review and Submit<br/>All details + files + declaration checkbox"]

  REV -->|"Submit"| SUBF["Edge Function submit-doctor-application"]
  SUBF --> SCHK{"Server checks"}
  SCHK -->|"Missing documents"| S1["Go back to D-04"]
  SCHK -->|"Attempts used up"| S2["Contact support screen"]
  SCHK -->|"Network error"| S3["Not submitted, Retry (idempotent)"]
  SCHK -->|"OK"| SUCC["User banned, sessions revoked,<br/>admin notified, confirmation email"]
  SUCC --> D6["D-06 Application Submitted<br/>You will get an email when reviewed.<br/>Usually within 2 to 3 days"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class RE1,E1,E2,E3,E4,O1,O2,U1,U2,U3,S1,S2,S3 fail;
```

### 4.2 Interrupted registration (user closes the app)

```mermaid
flowchart TD
  A["Doctor closes app at any step"] --> B{"Which step?"}
  B -->|"Before OTP verified"| C["Account exists unverified.<br/>Next login goes to D-03 with Resend"]
  B -->|"After OTP, before submit"| D["Status incomplete.<br/>Next login goes to D-07 Resume Application"]
  D --> E["Uploaded files are kept.<br/>Continue at D-04"]
  B -->|"After submit"| F["Pending. Login is blocked.<br/>Inactive-account message"]
```

### 4.3 Field rules

| Field | Rule |
|---|---|
| Name | 3 to 60 characters |
| Email | Valid, unique, not a patient email |
| Password | 8 or more characters, 1 number |
| License number | Required, unique among non-rejected applications |
| Clinic or hospital | Required |
| Documents | License and degree required, 5 MB, PDF/JPG/PNG |
| Declaration | "I confirm these documents are genuine" must be ticked |

---

## 5. Login (D-01) and the status gate

```mermaid
flowchart TD
  A["D-01 Doctor Login<br/>Email, Password, Forgot password,<br/>Register link"] --> AUTH{"Supabase auth"}
  AUTH -->|"Wrong credentials"| E1["Generic error"]
  AUTH -->|"Banned (pending or suspended)"| E2["D-09 message:<br/>Your account is not active yet.<br/>If you applied recently, the application is under review.<br/>Otherwise contact support"]
  AUTH -->|"Rate limited"| E3["Try again in N minutes"]
  AUTH -->|"Offline or server error"| E4["Banner and retry"]
  AUTH -->|"OK"| R{"role"}
  R -->|"patient"| E5["Sign out. This is not a doctor account.<br/>Link: Patient login"]
  R -->|"admin"| E6["Sign out. Use the staff login"]
  R -->|"doctor"| ST{"application status"}

  ST -->|"incomplete"| D7["D-07 Resume Application"]
  ST -->|"rejected"| D8["D-08 Rejected"]
  ST -->|"approved"| PC{"Profile complete?"}
  PC -->|"No"| D12["D-12 Profile Setup"]
  PC -->|"Yes"| D14["D-14 Home"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E1,E2,E3,E4,E5,E6 fail;
```

Forgot password: **D-10** (enter email, same generic message) then email link, **D-11** (new password), then Login. Expired link: "Link no longer works, request a new one". A banned (pending) doctor can request a reset email but still cannot log in.

---

## 6. Rejected application and resubmission

```mermaid
flowchart TD
  A["Email: Application rejected + reason"] --> B["Doctor logs in"]
  B --> C["D-08 Application Rejected<br/>Reason from admin, attempts used 1 of 3"]
  C --> D{"Action"}
  D -->|"Fix and resubmit"| E["D-04 Documents<br/>Replace or add files, edit license or clinic details"]
  E --> F["D-05 Review and Submit"]
  F --> G["submit-doctor-application"]
  G -->|"OK"| H["Status pending, banned again, D-06"]
  G -->|"Attempt 3 already used"| I["Contact support screen"]
  D -->|"Logout"| J["Welcome"]
```

While rejected, the doctor has access to **only** D-08, D-04, D-05 and logout. RLS returns nothing for patients, requests or exercises.

---

## 7. Profile setup after approval (D-12, D-13)

```mermaid
flowchart TD
  A["First login after approval<br/>Welcome message: You are verified"] --> S1["D-12 Step 1: Basics<br/>Photo (optional, phase 2), title, clinic, phone,<br/>city, languages"]
  S1 --> S2["Step 2: Expertise<br/>Pick expertise tags: Knee, Shoulder, Back, Neck, Hip,<br/>Ankle, Post-surgery, Sports injury, Arthritis,<br/>Balance, Elderly care, Yoga and wellness"]
  S2 --> S3["Step 3: About<br/>Bio (30 characters or more), years of experience,<br/>consultation approach"]
  S3 --> S4["Step 4: Availability<br/>Accepting new patients, max patients (default 30)"]
  S4 --> P["D-13 Preview<br/>Shows how the patient sees the profile<br/>with Verified badge"]
  P --> G{"Go live (listed)"}
  G -->|"Rules met"| OK["Listed in patient directory, D-14 Home"]
  G -->|"Missing tag or bio"| NO["Go live disabled, checklist shows what is missing"]
  G -->|"Skip for now"| SK["Home, profile reminder card stays"]
```

Listed rule: **approved + at least 1 expertise tag + bio 30+ characters + clinic + accepting patients**. Doctor can leave and resume setup at any time (draft saved).

Failures: validation errors inline; save failure shows "Not saved, retry" and keeps typed data; offline shows banner and disables Save.

---

## 8. Home (D-14)

```mermaid
flowchart TD
  H["D-14 Home"] --> K1["Pending requests count (tap: D-15)"]
  H --> K2["Active patients (tap: D-17)"]
  H --> K3["Sessions today"]
  H --> NA["Needs attention list:<br/>no session for 3 days, pain 7 or more, score drop"]
  H --> PC["Profile completion card (if incomplete)"]
  H --> QA["Quick actions: New exercise, Assign, Invite code"]
```

| State | Behaviour |
|---|---|
| New doctor, no patients | "No patients yet. Complete your profile so patients can find you" + button |
| Loading | Skeleton |
| Error | Retry |
| Offline | Cached data + banner |

---

## 9. Patient requests

### 9.1 Flow

```mermaid
flowchart TD
  N["Notification: new request"] --> L["D-15 Requests list<br/>Patient first name, body area, pain,<br/>match chips, time left (72 h)"]
  L --> D["D-16 Request Detail<br/>Condition summary: body areas, type, since when,<br/>surgery, pain, goals, red flags, note"]
  D --> DEC{"Decision"}

  DEC -->|"Accept"| ACC["respond_connection_request accept"]
  ACC --> C1{"Server checks"}
  C1 -->|"Request expired or cancelled"| F1["This request is no longer active"]
  C1 -->|"Capacity full"| F2["Your patient limit is reached.<br/>Raise limit in profile or decline"]
  C1 -->|"Patient already linked to another doctor"| F3["Patient is now connected to another doctor"]
  C1 -->|"OK"| OK["Link created, patient notified.<br/>Prompt: View patient or Assign exercise"]

  DEC -->|"Decline"| DS["Reason chips: Capacity full, Not my specialty, Other"]
  DS --> DR["respond_connection_request decline"]
  DR --> DONE["Patient notified, condition hidden from doctor"]

  DEC -->|"Do nothing"| EXP["Expires after 72 h, patient notified"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class F1,F2,F3 fail;
```

### 9.2 Rules

| Rule | Detail |
|---|---|
| Condition visibility | Only to the doctor who received the request, and only while `pending` or `accepted` |
| Red flags | Shown prominently (numbness, chest pain, fever with swelling, cannot bear weight) |
| Action buttons | Idempotent: double tap or retry never creates two links |
| Network error | "Not saved, try again" and request stays pending |
| Reminder | Doctor gets a notification 24 hours before expiry |

---

## 10. Patient management and assigning exercises

### 10.1 Patient list and detail

```mermaid
flowchart TD
  L["D-17 My Patients<br/>Search, filters: All, Needs attention, Inactive"] --> D["D-18 Patient Detail"]
  D --> T1["Overview: adherence ring, score trend, last session"]
  D --> T2["Plan: active, paused, completed assignments"]
  D --> T3["Sessions: list"]
  D --> T4["Condition: from the request, patient can update"]
  D --> AC1["Assign exercise"]
  D --> AC2["End connection"]
  T3 --> SR["D-23 Session Review"]
  AC1 --> AS["D-19 Assign Exercise"]
  AC2 --> CF["Confirm dialog, patient notified, assignments paused"]
```

| Edge | Behaviour |
|---|---|
| Patient disconnected while doctor is on the screen | "This patient is no longer connected", back to list |
| Sessions empty | "No sessions yet" |
| RLS returns nothing | Same friendly message, never a raw error |

### 10.2 Assign exercise (D-19)

```mermaid
flowchart TD
  A["D-19 Step 1: Choose exercise<br/>Tabs: My exercises, Library (public)<br/>Search, filter: category, body part, type"] --> B["Step 2: Settings<br/>Sets, reps or hold seconds, rest,<br/>days of week, start date, end date, doctor note"]
  B --> C["Step 3: Review and Assign"]
  C --> EF["create_assignment"]
  EF --> CHK{"Server checks"}
  CHK -->|"Patient no longer linked"| F1["Patient is not connected"]
  CHK -->|"Exercise archived"| F2["This exercise is no longer available"]
  CHK -->|"Same exercise already active"| F3["Already assigned. Replace the old one?"]
  CHK -->|"End date before start date"| F4["Fix the dates"]
  CHK -->|"No day selected"| F5["Pick at least one day"]
  CHK -->|"Network error"| F6["Draft kept, retry"]
  CHK -->|"OK"| OK["Patient notified, back to Plan tab"]
  F3 -->|"Replace"| EF

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class F1,F2,F3,F4,F5,F6 fail;
```

Leaving the wizard with unsaved changes shows "Discard draft?".

---

## 11. Exercise creation (doctor)

```mermaid
flowchart TD
  L["D-20 Exercise Library<br/>Tabs: My exercises, Library<br/>Filters: category, body part, type"] --> N["New exercise"]
  N --> B1

  subgraph BUILDER ["D-21 Exercise Builder"]
    B1["1 Basics<br/>Name, category, body part, steps, precautions"] --> B2["2 Tracking<br/>Type rep or hold, camera view Side or Front,<br/>joint (3 points), left, right or auto"]
    B2 --> B3["3 Targets<br/>Rep: start angle, target angle, tolerance, reps, sets<br/>Hold: angle range, hold seconds, sets"]
    B3 --> B4["4 Review"]
  end

  B4 --> T["D-22 Test on camera"]
  T -->|"Tracking is correct"| S["Save as Private (Tested)"]
  T -->|"Not correct"| B3
  B4 --> S2["Save without test (Untested badge)"]
  S --> L
  S2 --> L
  L --> AR["Archive"]
  AR --> W{"Assigned to patients?"}
  W -->|"Yes"| WN["Warn, old assignments continue, no new ones"]
  W -->|"No"| OK["Archived"]
```

Doctor exercises are **always Private** (only his own patients can see them). Only admin can make an exercise Public. Same validations as the admin builder: unique name, 2 or more steps, angles 20 degrees apart, hold range valid, 2D depth warning. Draft is saved locally on failure.

Test failures: camera permission denied (Camera Help), body out of frame ("Move back"), low landmark confidence ("Improve lighting"), camera crash (Camera Error screen).

---

## 12. Session review and feedback (D-23)

```mermaid
flowchart TD
  A["Notification or Patient Detail > Sessions"] --> B["D-23 Session Review<br/>Score, reps timeline, range of motion,<br/>pain level, patient comment"]
  B --> C["Write feedback (500 characters max)"]
  C --> D["Save"]
  D --> E{"Result"}
  E -->|"OK"| F["Patient notified, feedback card shown"]
  E -->|"Save failed"| G["Text kept, Retry"]
  E -->|"Link ended meanwhile"| H["This session is no longer available"]
  B --> P{"Pain 7 or more?"}
  P -->|"Yes"| AL["Highlighted alert at the top"]
```

---

## 13. Profile, credentials, settings and logout

```mermaid
flowchart TD
  P["D-26 Doctor Profile<br/>Verified badge, expertise, bio,<br/>accepting toggle, listed toggle"] --> E["D-27 Edit Profile and Expertise<br/>(no re-review)"]
  P --> CR["D-28 Update Credentials<br/>License number, degree, documents"]
  P --> NO["D-25 Notifications"]
  P --> ST["D-29 Settings<br/>Change password, notification prefs"]
  P --> LO["D-30 Logout"]

  CR --> UP["Upload new documents"]
  UP --> RR["Flag: re-review requested.<br/>Doctor stays active, badge shows Update under review"]
  RR --> AD["Admin reviews the update"]
  AD -->|"Approved"| BD["Badge restored"]
  AD -->|"Rejected"| WARN["Doctor notified, old verified data kept,<br/>admin may suspend if documents were false"]

  ST --> CP["Change Password<br/>old, new, confirm"]
  CP -->|"Wrong old password"| E1["Inline error"]
  CP -->|"OK"| OK["Snackbar"]
  LO --> CF{"Confirm"}
  CF -->|"Yes"| W["Sign out, Welcome"]
  CF -->|"No"| P
```

---

## 14. Optional: invite code (D-24)

```mermaid
flowchart TD
  A["D-24 Invite Code"] --> B["Generate code (48 hours, one patient)"]
  B --> C["Copy or share by WhatsApp"]
  C --> D["Patient enters code in Enter Code screen"]
  D --> E{"Server checks"}
  E -->|"Invalid, used or expired"| F["Patient sees clear error"]
  E -->|"Doctor not accepting or full"| G["Patient sees: doctor not available"]
  E -->|"OK"| H["Link created, no request needed"]
  A --> L["List of active codes + Revoke"]
  B -->|"5 unused codes already"| M["Revoke or use old codes first"]
```

This is a convenience path for patients the doctor already knows. It can be built in a later phase.

---

## 15. Suspension and global states

### 15.1 If the admin suspends this doctor

```mermaid
flowchart TD
  A["Admin suspends doctor"] --> B["account_status disabled + auth ban"]
  B --> C["Doctor's next request fails"]
  C --> D["Doctor app: D-09 Inactive Account, signed out"]
  B --> E["Linked patients notified"]
  E --> F["Patient sees: Doctor is not available.<br/>Old assignments stay until end date,<br/>no new ones, option to find another doctor"]
  B --> G["Doctor's pending requests cancelled"]
```

### 15.2 Global states (every doctor screen)

| State | Behaviour |
|---|---|
| Offline | Banner, cached data, write buttons disabled, drafts kept locally |
| Session expired | Dialog then login, drafts kept |
| Status changed by admin while using the app | Next request fails, routed by the gate |
| 403 | "You do not have permission", no raw error |
| 5xx | "Something went wrong" + Retry |

---

## 16. Doctor portal checklist

- [ ] No doctor can log in while `pending` (auth ban) or `suspended`
- [ ] `incomplete` doctor resumes at documents, nothing else is reachable
- [ ] `rejected` doctor reaches only D-08, D-04, D-05
- [ ] Every doctor RLS policy uses `is_approved_doctor()` and `is_linked_doctor()`
- [ ] Documents bucket is private, doctor can write only while `incomplete` or `rejected`
- [ ] License number uniqueness enforced on the server
- [ ] Doctor exercises are Private only
- [ ] Condition data hidden after decline, expiry, cancel or disconnect
- [ ] Credentials change triggers re-review without locking the doctor out
