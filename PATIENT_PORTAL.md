# RehabSense: Patient Portal Architecture

> Scope: everything a patient does, from Splash to Logout.
> Companion: `SYSTEM_OVERVIEW.md`, `DOCTOR_PORTAL.md`, `ADMIN_PORTAL.md`.
> The existing patient app (from `PROJECT_HANDOFF.md`) stays as it is. **New or changed** parts are marked **[NEW]** or **[CHANGED]**.

---

## 1. Principles

- A patient can use the app **fully without a doctor**: Wellness/Yoga and Rehab library, camera tracking, progress.
- Connecting to a doctor is **optional**. The **Prescribed** container is always visible but **locked until a doctor is connected**. Tapping a locked card opens the Connect flow, never a dead end.
- Patient signup is public, with email OTP verification and **no approval wait**.
- Patient picks the doctor: fills a **condition form**, sees doctors **sorted by expertise match**, sends a request. The doctor accepts or declines.
- Only the doctor who receives the request (and later the connected doctor) sees the condition and sessions.

---

## 2. Screen inventory

### 2.1 Existing screens (unchanged unless marked)

| ID | Screen | Route | Note |
|---|---|---|---|
| P-01 | Splash | `/splash` | Runs the Login Gate |
| P-02 | Welcome | `/welcome` | Patient buttons, small Doctor link, tiny Staff link |
| P-03 | Login | `/login` | |
| P-04 | Register | `/register` | |
| P-05 | Verify Email (OTP) | `/verify-email` | |
| P-06 | Forgot Password | `/forgot-password` | |
| P-07 | Reset Password | `/reset-password` | |
| P-08 | Profile Setup | `/setup/profile` | |
| P-09 | Safety Consent | `/setup/consent` | |
| P-10 | Camera Help | `/setup/camera-help` | |
| P-11 | Home | `/home` | **[CHANGED]** Prescribed container |
| P-12 | Courses | `/courses` | **[CHANGED]** 3 segments |
| P-13 | Course Detail | `/courses/:id` | |
| P-14 | Exercise Detail | `/courses/:cid/exercise/:eid` | |
| P-15 | Checklist | `/session/checklist` | |
| P-16 | Camera Setup | `/session/camera-setup` | Shows Side or Front instruction |
| P-17 | Live Tracking | `/session/live` | **[CHANGED]** config-based, rep and hold |
| P-18 | Pause | overlay | |
| P-19 | Summary | `/session/summary` | **[CHANGED]** pain and comment for prescribed |
| P-20 | Saved | `/session/saved` | |
| P-21 | Camera Error | `/session/camera-error` | |
| P-22 | Sync Error | `/session/sync-error` | |
| P-23 | Progress Dashboard | `/progress` | |
| P-24 | Exercise Progress | `/progress/exercise/:id` | |
| P-25 | Session History | `/progress/history` | |
| P-26 | Session Details | `/progress/session/:id` | **[CHANGED]** doctor feedback card |
| P-27 | Notification Inbox | `/notifications` | **[CHANGED]** new types |
| P-28 | Profile | `/profile` | **[CHANGED]** My Doctor row |
| P-29 | Edit Profile | `/profile/edit` | |
| P-30 | Settings | `/profile/settings` | |
| P-31 | Change Password | `/profile/change-password` | |
| P-32 | Notification Prefs | `/profile/notifications` | |
| P-33 | Help | `/profile/help` | |
| P-34 | Privacy | `/profile/privacy` | |
| P-35 | About | `/profile/about` | |
| P-36 | Logout Confirm | dialog | |

### 2.2 New screens [NEW]

| ID | Screen | Route |
|---|---|---|
| P-37 | Connect Hub | `/connect` |
| P-38 | Condition Form (3 steps) | `/connect/condition` |
| P-39 | Safety Alert | sheet |
| P-40 | Find Doctors (matched list) | `/connect/doctors` |
| P-41 | Doctor Public Profile | `/connect/doctors/:id` |
| P-42 | Send Request | `/connect/doctors/:id/request` |
| P-43 | Request Status | `/connect/status/:rid` |
| P-44 | Connected (celebration) | `/connect/connected` |
| P-45 | Request Declined or Expired | `/connect/result/:rid` |
| P-46 | My Doctor | `/profile/doctor` |
| P-47 | Disconnect Confirm | dialog |
| P-48 | Prescribed List | `/courses/prescribed` |
| P-49 | Prescribed Exercise Detail | `/prescribed/:assignmentId` |
| P-50 | Enter Doctor Code (optional) | `/connect/code` |
| P-51 | My Condition (view and edit) | `/profile/condition` |
| P-52 | Inactive Account | `/account-inactive` |

### 2.3 Navigation map (bottom bar)

```mermaid
flowchart TD
  NAV["Bottom navigation"] --> T1["Home"]
  NAV --> T2["Courses"]
  NAV --> T3["Progress"]
  NAV --> T4["Profile"]

  T2 --> S1["Wellness and Yoga"]
  T2 --> S2["Rehab"]
  T2 --> S3["Prescribed (locked until doctor connected)"]

  T3 --> G1["Dashboard"]
  T3 --> G2["History"]

  T4 --> R1["Edit Profile"]
  T4 --> R2["My Doctor or Connect with Doctor"]
  T4 --> R3["My Condition"]
  T4 --> R4["Settings, Password, Notification prefs"]
  T4 --> R5["Help, Privacy, About"]
  T4 --> R6["Logout"]
```

---

## 3. Master flow (Splash to Logout)

```mermaid
flowchart TD
  S["P-01 Splash"] --> SESS{"Session?"}
  SESS -->|"No"| W["P-02 Welcome"]
  SESS -->|"Yes"| GATE{"Login Gate"}
  W -->|"Create account"| REG["P-04 Register"]
  W -->|"Login"| LOG["P-03 Login"]
  REG --> OTP["P-05 Verify OTP"]
  OTP --> SET["P-08 Profile Setup"]
  LOG --> GATE
  GATE -->|"Not verified"| OTP
  GATE -->|"Not onboarded"| SET
  GATE -->|"Ready"| HOME
  SET --> CON["P-09 Safety Consent"]
  CON --> CAM["P-10 Camera Help"]
  CAM --> HOME["P-11 Home"]

  HOME --> CRS["P-12 Courses"]
  HOME --> PRG["P-23 Progress"]
  HOME --> PRF["P-28 Profile"]
  HOME --> CN["P-37 Connect Hub"]
  HOME --> NI["P-27 Notifications"]

  CRS --> SES["Session loop (section 6)"]
  CRS --> PRE["P-48 Prescribed"]
  PRE --> SES
  SES --> SUM["P-19 Summary"] --> PRG

  CN --> CF["Connect flow (section 7)"]
  CF --> HOME

  PRF --> LO["P-36 Logout"]
  LO --> W
```

---

## 4. Authentication flows

### 4.1 Register and verify

```mermaid
flowchart TD
  R["P-04 Register<br/>Name, email, password, confirm, terms"] --> V{"Valid?"}
  V -->|"No"| E1["Inline errors:<br/>weak password, mismatch, terms not ticked"]
  V -->|"Yes"| SU["Create account (role always patient)"]
  SU --> CH{"Result"}
  CH -->|"Email already registered"| E2["Message with Login and Forgot password buttons"]
  CH -->|"Email belongs to a doctor account"| E3["This email is used for a doctor account.<br/>Use another email"]
  CH -->|"Rate limited"| E4["Try again later"]
  CH -->|"Offline or server error"| E5["Banner, form data kept, retry"]
  CH -->|"OK"| O["P-05 Verify OTP"]

  O --> OC{"Code"}
  OC -->|"Correct"| NEXT["P-08 Profile Setup"]
  OC -->|"Wrong"| O1["Inline error"]
  OC -->|"Expired"| O2["Code expired, Resend"]
  OC -->|"Resend"| O3["60 second cooldown, then allowed"]
  OC -->|"Wrong email"| O4["Change email, back to P-04"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E1,E2,E3,E4,E5,O1,O2 fail;
```

### 4.2 Login

```mermaid
flowchart TD
  L["P-03 Login<br/>Email, Password, Forgot password, Register link"] --> V{"Fields valid?"}
  V -->|"No"| E1["Inline errors, button disabled"]
  V -->|"Yes"| A{"Supabase auth"}
  A -->|"Wrong credentials"| E2["Email or password is wrong<br/>After 3 tries, Forgot password is highlighted"]
  A -->|"Email not verified"| E3["Go to P-05 with Resend"]
  A -->|"Banned (disabled account)"| E4["P-52 Inactive Account message"]
  A -->|"Rate limited"| E5["Try again in N minutes"]
  A -->|"Offline or server error"| E6["Banner and retry"]
  A -->|"OK"| R{"role"}
  R -->|"doctor or admin"| E7["Sign out. This is not a patient account.<br/>Button: Doctor login"]
  R -->|"patient"| G["Login Gate: onboarding or Home"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E1,E2,E3,E4,E5,E6,E7 fail;
```

### 4.3 Forgot and reset password

```mermaid
flowchart TD
  A["P-03 Login: tap Forgot password"] --> B["P-06 Enter email"]
  B --> C{"Valid format?"}
  C -->|"No"| E1["Inline error"]
  C -->|"Yes"| D["Send reset email"]
  D --> E["Confirmation: If this email is registered, a link was sent<br/>(same message always)"]
  E --> F["Resend after 60 s"]
  E --> G["Patient opens the email link"]
  G --> H{"Opens in app?"}
  H -->|"No (browser)"| I["Open in app button"]
  H -->|"Yes"| J["P-07 Reset Password: new + confirm"]
  J --> K{"Result"}
  K -->|"Link expired or already used"| L["Link no longer works. Request a new one"]
  K -->|"Weak, mismatch, same as old"| M["Inline errors"]
  K -->|"Offline or server error"| N["Retry, typed password kept"]
  K -->|"OK"| O["Password changed, back to P-03 Login"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E1,L,M,N fail;
```

### 4.4 Onboarding

```mermaid
flowchart TD
  A["P-08 Profile Setup<br/>Age, gender, height, weight, goals"] --> B["P-09 Safety Consent<br/>Medical disclaimer, tick to agree"]
  B --> C["P-10 Camera Help<br/>How to place the phone, lighting, distance"]
  C --> D["Camera permission request"]
  D -->|"Allowed"| E["Home"]
  D -->|"Denied"| F["Explain why it is needed, Open Settings,<br/>Home still opens, tracking is disabled until allowed"]
  A -->|"Leave midway"| G["Draft saved, resume on next login"]
  A -->|"Save failed"| H["Retry, data kept"]
```

Onboarding completion is stored as `profiles.onboarded_at`, so logging in on another phone does not repeat it.

---

## 5. Home and Courses [CHANGED]

### 5.1 Home with the Prescribed container

```mermaid
flowchart TD
  H["P-11 Home"] --> A["Greeting + today summary"]
  H --> B["Today suggestion"]
  H --> C["Prescribed container"]
  H --> D["Quick access: Wellness, Rehab, Progress"]

  C --> ST{"State"}
  ST -->|"No doctor"| L["LOCKED card<br/>Connect with a doctor to see exercises prescribed for you<br/>Buttons: Connect with Doctor, Browse library"]
  ST -->|"Request pending"| PN["Request sent to Dr. X, view status"]
  ST -->|"Connected, nothing assigned"| EM["Connected to Dr. X. No exercises assigned yet"]
  ST -->|"Connected, assigned"| LS["Today's prescribed exercises with Done or Pending"]
  ST -->|"Doctor inactive"| DI["Dr. X is not available. Find another doctor"]
  ST -->|"Loading"| SK["Skeleton"]
  ST -->|"Error"| ER["Could not load + Retry"]

  L -->|"Tap"| CN["P-37 Connect Hub"]
  PN -->|"Tap"| RS["P-43 Request Status"]
  LS -->|"Tap exercise"| PD["P-49 Prescribed Detail"]
  DI -->|"Tap"| CN
```

### 5.2 Courses (3 segments)

```mermaid
flowchart TD
  C["P-12 Courses"] --> S1["Wellness and Yoga<br/>(category yoga or general)"]
  C --> S2["Rehab<br/>(category rehab, knee and shoulder courses)"]
  C --> S3["Prescribed"]
  S1 --> CD["P-13 Course Detail"] --> ED["P-14 Exercise Detail"]
  S2 --> CD
  S3 --> Q{"Doctor connected?"}
  Q -->|"No"| LK["Locked state, tap opens Connect Hub"]
  Q -->|"Yes"| PL["P-48 Prescribed List"] --> PD["P-49 Prescribed Detail"]
  ED --> SES["Session loop"]
  PD --> SES
```

---

## 6. Session loop (core exercise flow)

```mermaid
flowchart TD
  A["P-14 Exercise Detail or P-49 Prescribed Detail<br/>(doctor note and targets if prescribed)"] --> CFG{"Exercise config valid?"}
  CFG -->|"No"| E0["This exercise is not ready for tracking.<br/>Doctor or admin is notified"]
  CFG -->|"Yes"| B["P-15 Checklist<br/>Space, clothing, phone stable"]
  B --> C["P-16 Camera Setup<br/>Shows view instruction: Side or Front,<br/>distance guide, whole body in frame"]
  C --> PERM{"Camera permission?"}
  PERM -->|"Denied"| CE["P-21 Camera Error<br/>Open Settings, Retry"]
  PERM -->|"Granted"| D["P-17 Live Tracking"]

  D --> TY{"Exercise type"}
  TY -->|"Rep"| R1["Angle moves start to target and back.<br/>Rep counted, correct, incorrect or incomplete"]
  TY -->|"Hold"| R2["Angle stays in range.<br/>Timer runs, grace period if it drops"]

  D -->|"Body not visible for 3 s"| F1["Counting pauses. Overlay: Bring your whole body into frame"]
  D -->|"Low confidence"| F2["Overlay: Improve lighting or step back"]
  D -->|"Camera crash"| CE
  D -->|"Pause"| PA["P-18 Pause: Resume or End"]
  PA -->|"Resume"| D
  PA -->|"End"| SUM
  R1 --> DONE["All sets done"]
  R2 --> DONE
  DONE --> SUM["P-19 Summary<br/>Score, reps, range of motion, form"]

  SUM --> PN{"Prescribed session?"}
  PN -->|"Yes"| PAIN["Pain 0 to 10 slider + optional comment (skippable)"]
  PN -->|"No"| SAVE
  PAIN -->|"Pain 8 or more"| SAFE["Message: Stop if pain is severe and contact your doctor.<br/>Doctor gets an alert"]
  PAIN --> SAVE["Save session"]
  SAFE --> SAVE
  SAVE --> RES{"Result"}
  RES -->|"OK"| OK["P-20 Saved"]
  RES -->|"Failed"| SE["P-22 Sync Error<br/>Data kept locally, Retry"]
  SE -->|"Retry OK"| OK
  OK --> NEXT["Next exercise, Home or Progress"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class E0,CE,F1,F2,SE fail;
```

Rules: tracking uses **2D (x, y) angles only**. No video is recorded or uploaded. A prescribed session is saved with its `assignment_id`.

---

## 7. Connect with a doctor [NEW]

### 7.1 Flow

```mermaid
flowchart TD
  ENTRY["Entry points:<br/>Locked Prescribed card, Profile My Doctor row,<br/>Find a doctor button"] --> HUB["P-37 Connect Hub"]
  HUB --> CHK{"Current situation"}
  CHK -->|"Already connected"| MD["P-46 My Doctor"]
  CHK -->|"Has pending request"| ST["P-43 Request Status"]
  CHK -->|"Free to connect"| COND["P-38 Condition Form"]
  HUB -->|"I have a doctor code (optional)"| CODE["P-50 Enter Code"]

  subgraph FORM ["P-38 Condition Form (3 steps)"]
    F1["Step 1: Body area<br/>Knee, Shoulder, Back, Neck, Hip, Ankle,<br/>Wrist or Elbow, General"] --> F2["Step 2: Condition<br/>Type (injury, post-surgery, arthritis, weakness, balance, other),<br/>since when, surgery done?"]
    F2 --> F3["Step 3: Pain and goals<br/>Pain 0 to 10, goals, red-flag symptoms, note (300 characters)"]
  end
  COND --> F1
  F3 --> RF{"Red-flag selected?"}
  RF -->|"Yes"| SA["P-39 Safety Alert:<br/>See a doctor or hospital in person.<br/>This app is not for emergencies.<br/>Continue anyway or Go back"]
  RF -->|"No"| FD
  SA -->|"Continue anyway"| FD["P-40 Find Doctors"]

  FD --> LIST["Doctors sorted by expertise match.<br/>Best match badge, expertise chips, clinic, Verified badge.<br/>Filters: expertise, name search"]
  LIST --> PROF["P-41 Doctor Public Profile"]
  PROF --> BTN{"Request button state"}
  BTN -->|"Normal"| REQ["P-42 Send Request"]
  BTN -->|"Doctor stopped accepting"| X1["Disabled: Not accepting new patients"]
  BTN -->|"Already requested"| X2["Disabled: Request already sent"]
  BTN -->|"3 pending requests"| X3["Disabled: You have 3 pending requests"]
  BTN -->|"Already connected"| X4["Disabled: Disconnect first"]
  BTN -->|"Doctor suspended or unlisted"| X5["This doctor is no longer available"]

  REQ --> CS["Consent checkbox:<br/>Dr. X will see my condition form,<br/>sessions, scores and pain reports.<br/>I can disconnect any time"]
  CS --> SEND["send_connection_request"]
  SEND --> RESP{"Result"}
  RESP -->|"OK"| ST
  RESP -->|"Limits or doctor unavailable"| X6["Matching message, back to list"]
  RESP -->|"Offline"| X7["Form saved locally, retry"]
  RESP -->|"Server error"| X8["Request not sent, retry"]

  classDef fail fill:#fde8e8,stroke:#c0392b,color:#000;
  class X1,X2,X3,X4,X5,X6,X7,X8 fail;
```

### 7.2 Find Doctors states

| State | Behaviour |
|---|---|
| Loading | Skeleton cards |
| No doctors at all | "No doctors available right now" + **Enter code** and **Browse library** |
| No match for filters | "No doctors found" + Clear filters |
| Expertise match | Doctors with the most matching tags first, ties broken by free capacity |
| Offline | Cached list, Request button disabled |
| Error | Retry |

Matching note: this is a convenience sort, not medical advice. The screen shows "Choose the doctor you feel is right for you".

### 7.3 Request Status and result (P-43, P-44, P-45)

```mermaid
flowchart TD
  ST["P-43 Request Status<br/>Timeline: Sent, Doctor reviewing, Result<br/>Time left (72 h), Cancel button, Find another doctor"] --> OUT{"Outcome"}
  OUT -->|"Accepted"| AC["P-44 Connected<br/>Dr. X accepted. Prescribed container is unlocked.<br/>Button: Go Home"]
  OUT -->|"Declined"| DE["P-45 Declined<br/>Reason if given. Your condition is no longer visible to this doctor.<br/>Buttons: Choose another doctor, Browse library"]
  OUT -->|"Expired (72 h)"| EX["P-45 Expired<br/>Buttons: Send again, Choose another doctor"]
  ST -->|"Cancel"| CF{"Confirm"}
  CF -->|"Yes"| CA["Request cancelled"]
  CF -->|"No"| ST
  ST -->|"Cancel failed"| ER["Retry, request stays pending"]
  AC --> HOME["Home with Prescribed unlocked"]
  DE --> FD["P-40 Find Doctors (this doctor excluded)"]
  EX --> FD
  CA --> FD
```

Rules: max **3 pending requests**, one request per doctor at a time, **one active doctor** per patient. When one request is accepted, the patient's other pending requests are cancelled automatically. Status changes arrive by notification and by auto-refresh.

### 7.4 Optional: Enter Doctor Code (P-50)

| Failure | Message |
|---|---|
| Wrong code | "This code is not valid" |
| Expired | "This code expired. Ask your doctor for a new one" |
| Already used | "This code was already used" |
| Doctor full or not available | "This doctor is not accepting patients" |
| Already connected | "Disconnect from your current doctor first" |
| 5 wrong codes | Locked for 15 minutes |
| Success | Confirmation sheet showing what the doctor will see, then P-44 |

---

## 8. Prescribed exercises [NEW]

```mermaid
flowchart TD
  N["Notification: Dr. X assigned you an exercise"] --> L["P-48 Prescribed List<br/>Groups: Today, Upcoming, Completed<br/>Card: name, sets x reps or hold, doctor note preview, status"]
  HOME["Home Prescribed container"] --> L
  L --> D["P-49 Prescribed Exercise Detail<br/>Doctor note, prescribed targets, demo steps, precautions"]
  D --> SES["Session loop (section 6) with assignment_id"]
  SES --> PAIN["Pain and comment on Summary"]
  PAIN --> FB["Doctor feedback arrives later"]
  FB --> NT["Notification: Doctor feedback"]
  NT --> SD["P-26 Session Details with Doctor feedback card"]
```

| Edge | Behaviour |
|---|---|
| Assignment end date passed | Moves to Completed |
| Doctor cancelled or updated the plan while the list is open | Refresh removes or updates the card, snackbar "Your doctor updated your plan" |
| Exercise archived afterwards | Card disabled "This exercise is no longer available" |
| Doctor suspended | Banner, old assignments stay until end date, no new ones |
| Fetch error | Retry |
| Config broken | "This exercise is not ready for tracking" |

---

## 9. My Doctor and disconnect [NEW]

```mermaid
flowchart TD
  P["P-28 Profile > My Doctor"] --> S{"Connected?"}
  S -->|"No"| CH["P-37 Connect Hub"]
  S -->|"Yes"| MD["P-46 My Doctor<br/>Name, title, clinic, connected since,<br/>What the doctor can see: sessions, scores, pain, condition"]
  MD --> DC["Disconnect"]
  DC --> CF["P-47 Confirm:<br/>Dr. X will no longer see your data.<br/>Prescribed exercises will stop."]
  CF -->|"Confirm"| EF["end_connection"]
  EF --> R{"Result"}
  R -->|"OK"| OK["Prescribed locked again. Past sessions stay with you"]
  R -->|"Failed or offline"| ER["Could not disconnect, link unchanged, retry"]
  CF -->|"Cancel"| MD
  MD --> MC["P-51 My Condition: view or update.<br/>Connected doctor sees the update"]
```

---

## 10. Progress, notifications, profile and logout

### 10.1 Progress

```mermaid
flowchart TD
  A["P-23 Progress Dashboard<br/>Adherence, streak, score trend, weekly chart"] --> B["P-24 Exercise Progress"]
  A --> C["P-25 Session History"]
  C --> D["P-26 Session Details<br/>Reps timeline, score, pain, Doctor feedback card (if any)"]
  A -->|"No sessions yet"| E["Empty state: Do your first exercise"]
  A -->|"Error"| F["Retry"]
```

### 10.2 Notifications

```mermaid
flowchart TD
  N["P-27 Notification Inbox"] --> T{"Type"}
  T -->|"Request accepted"| A["P-44 Connected"]
  T -->|"Request declined or expired"| B["P-45 Result"]
  T -->|"New exercise assigned or plan updated"| C["P-48 Prescribed List"]
  T -->|"Doctor feedback"| D["P-26 Session Details"]
  T -->|"Doctor not available"| E["P-37 Connect Hub"]
  T -->|"Reminder"| F["Home"]
  N -->|"Target no longer exists"| G["Snackbar: This is no longer available"]
```

### 10.3 Profile and logout

```mermaid
flowchart TD
  P["P-28 Profile"] --> E["P-29 Edit Profile"]
  P --> D["My Doctor or Connect with Doctor"]
  P --> C["P-51 My Condition"]
  P --> S["P-30 Settings"]
  S --> CP["P-31 Change Password"]
  S --> NP["P-32 Notification Prefs"]
  P --> H["P-33 Help"]
  P --> PV["P-34 Privacy"]
  P --> AB["P-35 About"]
  P --> LO["P-36 Logout"]

  CP -->|"Wrong old password"| E1["Inline error"]
  CP -->|"Weak or same as old"| E2["Inline error"]
  CP -->|"OK"| OK["Snackbar"]

  LO --> CF{"Confirm"}
  CF -->|"Yes"| SO["Sign out, clear local session,<br/>keep unsynced sessions queued"]
  SO --> W["P-02 Welcome"]
  CF -->|"No"| P
```

---

## 11. Global states (every patient screen)

| State | Behaviour |
|---|---|
| Offline | Banner, cached data, write actions disabled, sessions queue locally and sync later |
| Session expired | Dialog, then Login. Unsynced sessions are kept |
| Account disabled by admin | Next request fails, **P-52 Inactive Account**, signed out |
| Doctor suspended or deleted | Banner on Home and My Doctor, option to find another doctor |
| Doctor ended the connection | Notification, Prescribed locked again, past data stays with the patient |
| 403 from server | "You do not have permission", no raw error text |
| 5xx | "Something went wrong" + Retry |

---

## 12. Patient privacy rules

| Rule | Detail |
|---|---|
| Condition form | Seen only by the doctor who received the request. Hidden after decline, expiry, cancel or disconnect |
| Sessions, pain, scores | Seen only by the currently connected doctor |
| Admin | Sees account info only (name, email, status, linked doctor), never health data |
| Video | Never recorded or stored |
| Disconnect | Patient can disconnect any time, data stays with the patient |
| Directory | Patient sees only approved, listed doctors (view hides email and phone) |

---

## 13. Patient portal checklist

- [ ] Patient signup can never create a doctor or admin (role forced server side)
- [ ] Prescribed container visible but locked until connected, tap opens Connect Hub
- [ ] App works fully without a doctor
- [ ] Max 3 pending requests, 72 hour expiry, one active doctor
- [ ] Condition form has red-flag Safety Alert
- [ ] Consent shown before a request is sent
- [ ] Doctor directory shows only approved and listed doctors
- [ ] Offline sessions queue and sync later
- [ ] Onboarding flag stored on the server
