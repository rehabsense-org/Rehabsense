# DESIGN.md — RehabSense (v2.0, audited and corrected)

> Single source of truth for building the RehabSense mobile app (Flutter, Android first).
> Derived from the `RehabSense Design Kit` Figma plugin (`code.js` v1.0.0, 40 screens) and **corrected** where the audit in §2 found navigation, back-button, bottom-navigation and flow defects.
> Where this file and the Figma plugin disagree, **this file wins**.

---

## 1. Product summary

RehabSense is a smartphone-camera physiotherapy app. The camera tracks body pose, counts reps, gives one line of live feedback, and stores results so patients can see progress.

**Product rules (non-negotiable)**
1. Live tracking screen shows only: skeleton overlay, rep count, one feedback line, audio toggle, Pause, End. Detailed metrics appear on the summary.
2. Exactly three rep outcomes everywhere: **Correct**, **Incorrect**, **Incomplete**. Each has colour **and** icon **and** label (never colour alone). An interrupted rep is never saved as Correct.
3. Wording is "Movement score". Never "diagnosis", "treatment", "injury risk". A no-diagnosis disclaimer is shown on 02, 08, 13, 19, 30.
4. No video or image is ever stored or uploaded. Only landmarks-derived numbers are kept.
5. Gold is used **only** for milestone moments (e.g. personal best). Never as a general accent.
6. Two courses only (names configurable): Course 1 "Knee Rehabilitation", Course 2 "Shoulder Mobility", 5 exercises each.

---

## 2. Audit — what was missing or wrong in the plugin output

Findings from reading `code.js` (`screen()`, `finish()`, `appBar()`, `NAV_TABS`, `link()`, `SPECS`) and the 40 builders. Each has a fix that is **already applied** in sections 5–8.

### 2.1 Bottom navigation (the "invisible nav" problem)
| # | Finding | Cause in plugin | Fix |
|---|---|---|---|
| N1 | Nav exists on only **8 of 40** screens (09, 10, 11, 20, 22, 39a, 39b, 24). It disappears on 13, 21, 23, 25–30, 35, 34, 19. | `finish()` adds nav only when `o.nav` is passed; every other builder omits it. | Nav is a property of the **shell**, not of each screen. Every screen inside the 4 tab branches shows it (§5.2). |
| N2 | Sticky action bars (`stickyBar`) are positioned at `y = H - bar.height`, i.e. **exactly where the nav would be**. 13, 23, 25, 27 can never show both. | Both pinned to the bottom. | Action bar stacks **above** nav (§6.3). Reserved bottom space = bar + 80 px nav. |
| N3 | Session details (23), Exercise progress (21), Session summary (19) have no tabs. | Not passed `nav`. | 23, 21 show nav (Progress tab active). 19 shows nav with a **leave-guard** (§5.4). |
| N4 | Active tab is **not tappable** to reset (`t.key !== o.nav` skips linking), and tapping another tab always goes to that tab's root, losing its stack. | `finish()` link loop. | Per-tab stacks preserved; re-tap active tab pops to its root (§5.3). |
| N5 | Nav tab "Courses" is highlighted on 11 but missing on 13 (child of 11). Inconsistent. | Same as N1. | 13 shows nav, Courses active. |
| N6 | Content bottom padding is 112 only when `nav` set, else 40; with a sticky bar the padding is patched separately → content hidden behind bars. | `screen()` / `stickyBar()`. | One layout rule: `bottomInset = (actionBar?72:0) + (nav?80:0) + safeArea` (§6.3). |

### 2.2 Back button / history
| # | Finding | Fix |
|---|---|---|
| B1 | 22 Session history is opened from "View all" (09, 20) but has **no app bar / back**. User is stranded. | Add app bar with back (pushed child of Progress). |
| B2 | 10 Courses, 09 Home, 20 Progress, 24 Profile are roots → no back is correct, but **Android system back is undefined everywhere**. | Android back table in §5.5. System back on a tab root returns to Home; on Home asks to exit (double-back). |
| B3 | 16 Live tracking has **no back/close**. 17 Pause has none. 15 has chevron to 14 but doesn't stop the camera. | System/AppBar back on 16 → opens End-confirmation (18), never silently leaves. 15 back stops camera, returns to 14. |
| B4 | 19 Summary: `back:false` and an **X → 09 that discards the unsaved result with no warning**. | X and any exit open "Leave without saving?" sheet (42, new). |
| B5 | 36 Logout → 03 and 37 Delete → 02 are plain `NAVIGATE`; in the prototype and a naive app, **Back from Login returns into the signed-in app**. | Logout/delete **clear the whole navigation stack** (`go`, not `push`) (§5.3). |
| B6 | 07 Profile setup back → 31 Email verification (already verified). | 07 is the first screen after verification: **no back**, show "Skip". 08 back → 07 is fine. |
| B7 | 25 Edit profile "Cancel" = `BACK`, "Save" = navigate to 24 (pushes a duplicate 24). 27 Save = BACK. Inconsistent, and no unsaved-changes guard. | Save = save + pop. Back/Cancel with dirty form → "Discard changes?" dialog (43, new). |
| B8 | 11 → 13 → 14 … → 35 → "Back to home" leaves a deep stack; Back from 09 then returns into the session flow. | Session flow is its own navigator; on exit the whole flow is popped (§5.4). |
| B9 | 03 Login `appBar(b,'')` shows a back chevron, but 03 is also reached by logout/reset (root of auth). | Back only shown if `canPop`; after logout there is none. |
| B10 | 26 Settings → "Change password" opens **05 (forgot-password, unauthenticated flow)** and ends at 03 Login. | New in-app screen 44 "Change password" (current + new + confirm); pops back to 26. |
| B11 | 32/33/34 error screens' primary buttons go to unrelated places ("Open settings" → 09). | Real behaviour defined in §7 (opens OS app settings, then re-checks permission on resume). |

### 2.3 Flow / logic gaps
| # | Finding | Fix |
|---|---|---|
| F1 | Spec says "Unverified → 31" on 03 but Login button only links to 09. | Login result decides: verified → 09 (or 07 if profile incomplete), unverified → 31. |
| F2 | 01 Splash: no route to **38 Interrupted session** even though 38 exists. | Splash checks `unsavedSession`; if present → Home with 38 modal. |
| F3 | 09 bell icon has red badge but **no destination**. | New 41 Notification inbox. |
| F4 | 19 "Next exercise" → 13 (same exercise); plugin hard-codes `ex(1,x)` and `CFG.course1` in 13/21 titles. | Routes are parameterised (`:cid`, `:eid`). Next = next exercise in course; if last → course complete state. |
| F5 | 10 lists 2 courses but 11 is built only for course 1. 13's app-bar title is the **course** name, not exercise. | Parameterised 11; 13 title = exercise name, subtitle = course. |
| F6 | 35 Saved and 34 Network error are only reachable by prototype link; no rule for when each is shown. | Save pipeline (§8.4): local save always succeeds → 35; sync failure shows 34 only if user taps "Sync now" or on non-blocking banner. |
| F7 | Home "Resume" → 14 (checklist) but the card says "4 of 10 reps done". | Resume → 38-style restore → 15 (camera) with counts restored; checklist skipped. |
| F8 | No empty/loading/error states beyond 39a (history) and 39b (home). | Every list screen has Loading / Empty / Error variants (§7.2). |
| F9 | No offline banner, session-expired, permission-permanently-denied, low-light, multiple-people, storage-full states. | Added (§7). |
| F10 | Screen number 12 is merged into 11; codes 39a/39b are not numeric. | Codes are labels only; routes use names (§5.1). |
| F11 | Prototype timer on 16 (8 s → 19) is a stand-in. | Real trigger: target reps reached or End confirmed. |
| F12 | Form screens (03, 04, 06, 07, 25, 44) show no validation/error/keyboard states. | §6.6 form spec + states. |
| F13 | Status bar is a drawn 28 px mock. | Use real system status bar + `SafeArea`; never draw it. |
| F14 | Touch targets: nav label 13 px; icon buttons size not guaranteed ≥ 44. | Min 48×48 dp hit area for every tappable. |

---

## 3. Design tokens

Inter is the typeface (stand-in for SoDoSans). Bundle Inter 400/500/600/700 as assets (no network fetch).

### 3.1 Colour
| Token | Hex | Use |
|---|---|---|
| `brand/green` | `#006241` | H1 titles, brand moments |
| `brand/action` | `#00754A` | Primary buttons, active states, FAB, progress fill |
| `brand/deep` | `#1E3932` | Splash, hero bands, pause screen, continue card |
| `brand/uplift` | `#2B5148` | Decorative accent on deep green |
| `brand/mint` | `#D4E9E2` | Selected nav indicator, icon circles |
| `accent/gold` | `#CBA258` | Milestone only |
| `accent/gold-light` | `#DFC49D` | Milestone wash |
| `accent/gold-wash` | `#FAF6EE` | Surface under milestone content |
| `accent/gold-deep` | `#7D5E22` | Text on gold wash |
| `surface/canvas` | `#F2F0EB` | Page background (never pure white) |
| `surface/ceramic` | `#EDEBE9` | Tracks, skeletons, segmented control bg |
| `surface/card` | `#FFFFFF` | Cards, sheets, dialogs, inputs, nav, action bar |
| `surface/cool` | `#F9F9F9` | Menus |
| `surface/ink` | `#000000` | Dark buttons only |
| `surface/camera` | `#101614` | Camera backdrop |
| `text/primary` | `#000000` @ 87% | Body on light |
| `text/secondary` | `#000000` @ 58% | Metadata on light |
| `text/on-dark` | `#FFFFFF` | On green/camera |
| `text/on-dark-soft` | `#FFFFFF` @ 70% | Secondary on dark |
| `text/muted-green` | `#33433D` | Calm info blocks |
| `border/input` | `#D6DBDE` | Inputs, controls |
| `border/hairline` | `#E7E7E7` | Dividers |
| `status/success` · tint | `#00754A` · `#EAF4F0` | Correct, valid |
| `status/error` · tint | `#C82014` · `#FBECEB` | Incorrect, errors, destructive |
| `status/warning` · ink · tint | `#FBBC05` · `#8A6100` · `#FEF5DA` | Incomplete. Yellow is fill-only; text uses ink |
| `overlay/scrim` | `#000000` @ 50% | Dialog scrim |
| `overlay/glass` | `#FFFFFF` @ 16% | Controls over camera |

Contrast rule: text on `status/warning` fills uses `warning-ink`; white text only on `brand/*` and `error`.

### 3.2 Typography (tracking −1% unless noted)
| Style | Size / weight / line-height |
|---|---|
| Display/Metric | 56 / 600 / 100% / −2% (live rep counter) |
| Display/Large | 45 / 600 / 120% |
| Display/Medium | 32 / 600 / 120% |
| Heading/H1 | 24 / 600 / 36px (colour `brand/green`) |
| Heading/H2 | 24 / 400 / 36px |
| Heading/H3 | 19 / 600 / 140% |
| Body/Large | 19 / 400 / 175% |
| Body/Default | 16 / 400 / 150% |
| Body/Strong | 16 / 600 / 150% |
| Body/Small (+Strong) | 14 / 400 (600) / 150% |
| Caption (+Strong) | 13 / 400 (600) / 150% |
| Label/Overline | 12 / 700 / 150% / **+10%**, uppercase |
| Button/Large · Medium | 16 · 14 / 600 / 120% |

Support system font scaling up to **130%** without clipping; layouts must wrap, not truncate, titles.

### 3.3 Spacing, radius, size
- Spacing scale: 4, 8, 16, 24, 32, 40, 48, 56, 64. Screen horizontal padding **16**. Default vertical gap between blocks **20**.
- Radius: input 4 · card 12 · hero card 16 · sheet 24 · pill 50.
- Sizes: touch-min 44 (implement 48), button-large 52, button-medium 40, FAB 56, app bar 48, **bottom nav 80**, action bar 72 (+ safe area).

### 3.4 Elevation
| Name | Layers (x, y, blur, alpha) | Use |
|---|---|---|
| Card | (0,0,0.5,.14) (0,1,1,.24) | Cards |
| Nav | (0,1,3,.10) (0,2,2,.06) (0,0,2,.07) | Bottom nav, action bar |
| Floating | (0,0,6,.24) (0,8,12,.14) | FAB, camera controls |
| Sheet | (0,0,6,.12) (0,12,24,.16) | Dialogs, bottom sheets, live panel |

### 3.5 Motion
- Page transition: 250 ms fade-through (ease-out). Modals: 200 ms slide-up.
- Rep counter increments with a 120 ms scale pulse. No other decorative motion. Respect "Remove animations" OS setting.

---

## 4. Components

All components are reusable widgets; screens never hand-roll them.

| Component | Variants / props | Notes |
|---|---|---|
| **Button** | `Primary` (action green, white text) · `Secondary` (white, green outline) · `Dark` (ink) · `Text` · `Destructive` (error fill) · `Destructive Outline`; sizes Large 52 / Medium 40; `fill`, `loading`, `disabled`, optional leading icon | 50 px pill. Loading shows spinner and blocks taps. |
| **Button / On dark** | `Filled` (white) · `Outline` (white 1.5px) | Pause screen, continue card, camera screens. |
| **IconButton** | `plain` · `soft` (canvas circle) · `glass` · `filled` · `light`; 40 visual, 48 hit | Needs `semanticLabel`. |
| **AppBar** | `title`, `subtitle?`, `leading: back|close|none`, `actions[]`, `dark` | Back shown automatically when `canPop`. Title ellipsises at 1 line, never overlaps actions. |
| **BottomNav** | 4 tabs: Home, Courses, Progress, Profile. Active = mint 56×32 pill + green icon + Caption/Strong label | 80 dp + safe area. Optional dot badge on Profile (unsaved) – none by default. |
| **ActionBar** | Column of 1–3 buttons on `surface/card`, Elevation/Nav | Sits above BottomNav (§6.3). |
| **Card** | padding 16, radius 12, Elevation/Card | `flat` removes shadow. |
| **MenuCard / Row** | icon circle (mint), title, subtitle?, trailing chevron/toggle/value, `danger` | Row min height 56. |
| **Input** | label, helper, error, prefix/suffix icon (eye toggle), states: default/focus/filled/error/disabled | 4 px radius, border `border/input`, focus 2px `brand/action`. |
| **StatusChip** | `Correct` (success) · `Incorrect` (error) · `Incomplete` (warning) · `Info` | Always icon + label. |
| **FilterChip** | selected/unselected | Horizontal scroll or wrap. |
| **Checkbox / Toggle** | on/off/disabled | 48 hit area. |
| **SegmentedControl** | Week / Month / All time | Pill on ceramic. |
| **StatTile** | label, big value, delta | 2-column grid. |
| **ProgressBar** | value, track, fill, height | Used for reps, course progress. |
| **LineChart** | points, area, last-point dot | Custom painter; no chart library required. |
| **SkeletonBlock** | rect/line/circle on ceramic with shimmer | Loading states. |
| **Banner** | `offline` · `syncPending` · `error` · `info` | Under app bar, above content; non-blocking. |
| **Dialog / Sheet** | icon circle, title, body, 1–2 buttons | Elevation/Sheet, radius 24, scrim. |
| **EmptyState** | illustration icon, title, body, CTA | |
| **Logo** | `mark`, `lockup` | |
| **PoseOverlay** | 13 bones over camera preview; joint highlight (good = green, bad = red) | Landmark set per §8.2. |
| **FeedbackLine** | icon + one sentence; tint by state | Max 1 line + wrap to 2. |
| **RepCounter** | `4 / 10` Display/Metric + chip | Live. |

Icons: Lucide-style 24 px, 1.75 stroke, 53 icons (home, book, bar-chart, user, chevrons, bell, camera, camera-off, play, pause, check, x, plus, minus, check-circle, x-circle, minus-circle, alert, info, help, volume, volume-off, eye, eye-off, mail, lock, sliders, shield, clock, calendar, repeat, sun, smartphone, logout, trash, edit, search, wifi, wifi-off, activity, target, image, file, person, bulb, scan, star, list, trend, users). Use `lucide_icons` or equivalent.

---

## 5. Navigation architecture (corrected)

### 5.1 Route map

Router: `go_router`. Three navigators: **Auth**, **Shell** (4 tab branches, each with its own stack), **Session** (full-screen, over the shell).

Legend — Nav: ✅ bottom nav visible · ❌ hidden · Back: ↩ app-bar back (pops) · ✕ close · — none (root).

#### A. Auth & onboarding (root navigator, no shell)
| Code | Route | Nav | Back | Notes |
|---|---|---|---|---|
| 01 | `/splash` | ❌ | — | 1.5 s, then route by state (§5.6) |
| 02 | `/welcome` | ❌ | — | Get started → 04; I have an account → 03 |
| 03 | `/login` | ❌ | ↩ if canPop | Success rules F1 |
| 04 | `/register` | ❌ | ↩ | → 31 |
| 31 | `/verify-email` | ❌ | ↩ ("Change email" pops) | Resend with 60 s cooldown; auto-poll verification |
| 05 | `/forgot-password` | ❌ | ↩ | → "Check your email" state in place |
| 06 | `/reset-password` | ❌ | ✕ → 03 | Opened from email deep link |
| 07 | `/setup/profile` | ❌ | **— (none)**, "Skip" | Step 1 of 2 |
| 08 | `/setup/safety` | ❌ | ↩ → 07 | Step 2 of 2; camera permission request |
| 32 | `/setup/camera-help` | ❌ | ↩ | Open OS settings; re-check on resume |

#### B. Shell — tab 1 HOME
| Code | Route | Nav | Back |
|---|---|---|---|
| 09 | `/home` | ✅ Home | — |
| 39b | `/home` (loading variant) | ✅ Home | — |
| 41 | `/home/notifications` (new) | ✅ Home | ↩ |

#### C. Shell — tab 2 COURSES
| Code | Route | Nav | Back |
|---|---|---|---|
| 10 | `/courses` | ✅ Courses | — |
| 11 | `/courses/:cid` | ✅ Courses | ↩ |
| 13 | `/courses/:cid/exercise/:eid` | ✅ Courses | ↩ (+ help → 28) |

#### D. Shell — tab 3 PROGRESS
| Code | Route | Nav | Back |
|---|---|---|---|
| 20 | `/progress` | ✅ Progress | — |
| 21 | `/progress/exercise/:eid` | ✅ Progress | ↩ |
| 22 | `/progress/history` | ✅ Progress | ↩ **(was missing)** |
| 23 | `/progress/session/:sid` | ✅ Progress | ↩ |
| 39a | `/progress/history` (empty variant) | ✅ Progress | ↩ |

Session details 23 can be opened from Home (09 recent activity), Progress (20), Exercise progress (21), History (22), Saved (35). It is always pushed **onto the branch the user is in**, so Back returns to the origin and the active tab stays the origin's tab. From Home it keeps Home active; use `/session/:sid` as a **shared route** that renders inside whichever branch pushed it.

#### E. Shell — tab 4 PROFILE
| Code | Route | Nav | Back |
|---|---|---|---|
| 24 | `/profile` | ✅ Profile | — |
| 25 | `/profile/edit` | ✅ Profile | ↩ (dirty guard) |
| 26 | `/profile/settings` | ✅ Profile | ↩ |
| 44 | `/profile/settings/password` (new) | ✅ Profile | ↩ |
| 27 | `/profile/notifications` | ✅ Profile | ↩ (dirty guard) |
| 28 | `/profile/help` (reachable from 13, 33 too) | ✅ Profile | ↩ |
| 29 | `/profile/privacy` | ✅ Profile | ↩ |
| 30 | `/profile/about` | ✅ Profile | ↩ |
| 36 | dialog over 24 | ❌ (scrim) | Cancel |
| 37 | dialog over 29 (requires password) | ❌ (scrim) | Cancel |

#### F. Session flow (full-screen, covers the shell; entered from 13, 09 Resume, 19 Retry/Next, 38)
| Code | Route | Nav | Back / exit |
|---|---|---|---|
| 14 | `/session/:eid/checklist` | ❌ | ↩ → 13 |
| 15 | `/session/:eid/camera` | ❌ | ↩ → 14 (camera released) |
| 16 | `/session/:eid/live` | ❌ | System back / ✕ → **18 End confirmation** |
| 17 | `/session/:eid/paused` | ❌ | System back → 16 (Resume) |
| 18 | dialog over 16/17 | ❌ | Back = "Continue exercise" |
| 40 | overlay over 16 (safety alert) | ❌ | Back = Pause (17) |
| 33 | `/session/:eid/tracking-error` | ❌ | ↩ → 15 |
| 38 | dialog over 09 on launch | ✅ (Home behind scrim) | Back = Resume |
| 19 | `/session/:eid/summary` | ✅ **with leave-guard** | ✕ and all exits → 42 if unsaved |
| 42 | sheet "Leave without saving?" (new) | — | Save and leave / Discard / Stay |
| 35 | `/session/:eid/saved` | ✅ (flow popped; nav belongs to the tab it lands on) | — |
| 34 | `/session/:eid/sync-error` | ✅ | ↩ → 35 |

Screens 35 and 34: because the user may tap nav here, the flow navigator is already complete (data is saved locally), so tab taps are unguarded.

### 5.2 Nav visibility rule (one rule, not per-screen flags)

```
showBottomNav = route is inside Shell
             OR route == 19 (guarded)
             OR route in {35, 34, 38-behind-scrim}
hideBottomNav = Auth routes, 14, 15, 16, 17, 33, 40, any open keyboard, any full-screen dialog scrim
```
Implementation: `ShellRoute` / `StatefulShellRoute.indexedStack` owns the `BottomNav`. Child pages never build it themselves. The nav is **never** removed because a page has an action bar.

### 5.3 Stack behaviour
- Each tab keeps its own stack (`StatefulShellRoute.indexedStack`). Switching tabs preserves scroll and stack.
- **Re-tap active tab** → pop to that tab's root and scroll to top.
- **Logout (36 confirm)** → clear tokens, clear all stacks, `go('/login')`. Back from Login exits the app.
- **Delete account (37 confirm)** → wipe local DB, `go('/welcome')`. Back exits.
- **Signup completion (07→08→permission result)** → `go('/home')` replaces the onboarding stack.
- Session flow is a nested navigator: leaving it (35 buttons, 42 Discard, 38 Discard) pops the whole flow in one operation, landing on the previous shell location.
- Deep links: `rehabsense://reset?token=…` → 06; `rehabsense://verify?token=…` → 31 success; `rehabsense://session/:sid` → 23 (requires login).

### 5.4 Leave-guard for 19 Summary
Session result is held in memory + a `draft` row in the local DB until saved.
- Tapping a tab, ✕, or system back while `saved == false` → sheet **42**:
  - **Save and leave** (primary) → save locally, then continue the original navigation.
  - **Discard result** (destructive outline) → delete draft, continue.
  - **Stay** (text).
- After saving once, 19 becomes read-only "Saved ✓" and the guard is off.

### 5.5 Android system-back table
| Where | Back does |
|---|---|
| Any pushed screen | Pop one |
| Tab root (10, 20, 24) | Switch to Home tab |
| Home root | First press: snackbar "Press back again to exit". Second within 2 s: exit |
| 16 Live | Open 18 |
| 17 Paused | Resume (16) |
| 18 / dialogs | Dismiss = safest option (Continue / Cancel) |
| 19 Summary unsaved | Open 42 |
| 25 / 27 / 44 / 07 dirty | Open 43 "Discard changes?" |
| 03 Login after logout | Exit app |
| 07 | Disabled (use Skip) |
| 01 Splash | Disabled |

### 5.6 Launch routing (01 Splash)
```
if no onboarding seen              → 02
elif not authenticated             → 03
elif email not verified            → 31
elif profile not set up            → 07
elif camera consent not recorded   → 08
else                               → 09
   └ if unsavedSession exists      → show 38 on top of 09
```

---

## 6. Layout system

### 6.1 Frames
Design baseline 360 × 800 dp (also verify 412 × 915 and 390 × 844). Use `SafeArea`; never draw a fake status bar. Content scrolls; header, action bar, and nav are fixed.

### 6.2 Screen anatomy
```
┌──────────────────────────────┐
│ system status bar (OS)        │
│ AppBar (48)  [fixed]          │
│ Banner? (offline/sync)        │
│ ── scrollable content ──      │  padding 16, gap 20
│                               │
│ ActionBar (72 + safe)? [fixed]│  white, Elevation/Nav
│ BottomNav (80 + safe)? [fixed]│  white, Elevation/Nav
└──────────────────────────────┘
```

### 6.3 Bottom inset formula
`scrollPaddingBottom = 24 + (actionBar ? actionBarHeight : 0) + (nav ? 80 : 0) + safeAreaBottom`
- When both are visible, the ActionBar sits **directly above** the nav with no gap; only the ActionBar draws the shadow on its top edge, the nav draws a hairline `border/hairline` on its top.
- With keyboard open: nav hides, ActionBar rides above keyboard.
- Screens with 2 buttons in an ActionBar: primary (Large) on top, secondary/text below, or side-by-side Medium pair.

### 6.4 Camera screens (15, 16, 17, 33, 40)
Full bleed `surface/camera` + preview; glass controls ≥ 48 dp; panel at bottom radius 24 with Elevation/Sheet; no nav. Keep screen awake. Lock to portrait.

### 6.5 Lists and cards
Card list gap 12; group header = Overline above card; rows 56 dp min; hairline dividers inset 16.

### 6.6 Forms
- Label above field (Body/Small Strong), helper below (Caption), error replaces helper in `status/error` with icon.
- Validate on blur and on submit; primary button disabled until required fields valid **or** enabled and shows errors on tap (use the second).
- Password: show/hide toggle, rule checklist (8+ chars, 1 letter, 1 number) live.
- `textInputAction` chain, correct `keyboardType`, `autofillHints`, scroll focused field into view.
- Submit buttons show loading; fields disabled while loading.

---

## 7. Global states

### 7.1 System states
| State | UI |
|---|---|
| Offline | `Banner.offline` under app bar; tracking still works; results saved locally |
| Sync pending | Small "Sync pending · N" row in 24 and 35; auto-retry on reconnect |
| Session expired | Dialog "Please log in again" → 03 (stack cleared, draft retained) |
| Camera permission denied once | Re-request from 08/15 |
| Camera permission permanently denied | 32 with "Open settings"; re-check on `AppLifecycleState.resumed`; if granted → continue to where the user was |
| Camera in use / failed to open | 33 variant "Camera unavailable" |
| Storage full | Inline error on save; keep draft |
| Low light / too far / partial body / multiple people | Non-blocking top chip on 15/16 (one at a time), with 3 s debounce |
| Phone call / app backgrounded during session | Auto-pause (17), draft persisted → 38 on next launch if app killed |
| Thermal/battery low | Info banner on 14 "Low battery may interrupt tracking" |

### 7.2 Per-screen data states
Every screen that loads data implements **Loading (skeleton) · Empty · Error (retry) · Content**.
| Screen | Empty copy | CTA |
|---|---|---|
| 09 Home (new user) | "Start your first exercise" – hides Continue card | Browse courses → 10 |
| 20 Progress | "No sessions yet" | Start exercise → 10 |
| 22 History | "Your sessions will appear here" (39a) | Browse courses |
| 21 Exercise progress | "No attempts at this exercise yet" | Start exercise → 13 |
| 41 Notifications | "You're all caught up" | — |

---

## 8. Screen specifications

Common to all: AppBar/BottomNav per §5, 16 dp padding, tokens from §3.

### 8.1 Auth & onboarding

**01 Splash** — bg `brand/deep`, centred Logo lockup (mint mark + white wordmark Display/Medium), tagline Body/Default on-dark-soft. Auto route §5.6 after 1.5 s (or when init completes, minimum 800 ms).

**02 Welcome** — hero illustration (pose figure on mint circle), H1 "Rehab, guided by your camera", 3 bullets (Reps & instant feedback · Progress you can see · Private: no video stored), disclaimer Caption: "RehabSense is a guidance tool. It does not diagnose or replace your physiotherapist." ActionBar: **Get started** (Primary) / **I already have an account** (Secondary). No nav.

**03 Login** — AppBar (back if canPop), H1 "Welcome back", sub. Fields: Email, Password (eye). Link "Forgot password?" → 05. **Log in** (Primary). Divider "or". **Create account** (Secondary) → 04. Errors: invalid credentials banner (error tint), account locked after 5 tries (30 s lockout message), offline.

**04 Registration** — Fields: Full name, Email, Password (rules), Confirm password, Checkbox "I agree to the Terms and Privacy Policy" (links open in-app web view). **Create account** → 31. Errors: email in use (with "Log in instead" link).

**31 Email verification** — mail icon circle, H1 "Check your inbox", shows email. Buttons: **I've verified my email** (Primary; checks server; if not verified shows inline warning), **Resend email** (Text, 60 s countdown), **Change email address** (Text, pops to 04 with email pre-filled). Auto-poll every 5 s. Success → 07.

**05 Password recovery** — Email field, **Send reset link** → in-place success state ("We sent a link to …", Open email app, Resend). Text button "Back to log in".

**06 Reset password** — Opened by deep link. New password + confirm + rule checklist. **Update password** → success toast → 03 (stack cleared). Expired token state: "Link expired" + Request new link → 05.

**07 Initial profile setup** — AppBar title "Step 1 of 2", **no back**, step progress bar. Fields: Display name (prefilled), Age range (chips: Under 18 / 18–29 / 30–44 / 45–59 / 60+), Main goal (chips: Knee recovery / Shoulder mobility / General), Reminder time (optional). No sensitive health data. ActionBar: **Save and continue** (Primary) · **Skip for now** (Text). Both → 08.

**08 Safety, consent & permissions** — AppBar "Step 2 of 2" with back → 07. Three icon rows: Camera use ("Your phone camera tracks your body; video is never stored"), Privacy, Exercise safely (stop if you feel pain, exercise in a clear space). Disclaimer. Consent checkbox **required**. ActionBar: **Allow camera & continue** (disabled until consent) → OS permission → granted → 09; denied → 32. **Not now** (Text) → 32.

**32 Camera permission help** — camera-off icon circle, H1 "Camera access is off", 3 numbered steps (Open settings → Permissions → Camera → Allow). **Open settings** (Primary) opens OS app settings; **Back to home** (Secondary) → 09. When app resumes and permission is granted: success snackbar and returns to the originating screen.

### 8.2 Home & discovery

**09 Home** (Nav Home)
- Header: "Good morning," + user name (H1, `text/primary`), bell IconButton (red dot if unread) → **41**, Avatar (initials on mint) → 24 tab.
- **Continue card** (only if unsaved or partially done session): `brand/deep` card radius 16, overline "Continue where you left off", exercise name, "Course · 4 of 10 reps done", mint progress bar, **Resume** (On-dark filled) → 15 with restored counts, "~3 min left".
- **Today's plan**: card with next exercise, **Start** → 13.
- **Courses** section header with "See all" → 10; two course cards (icon circle, name, "5 exercises · 12 min", progress bar, Start/Continue) → 11.
- **Recent activity**: header + "View all" → 22; 2–3 session rows (exercise, "Today · Score 86", StatusChip) → 23.
- Variants: Loading (39b skeleton), Empty (new user), Error.

**10 Courses** (Nav Courses) — H1 "Courses", search not needed (2 courses). Two large course cards: hero icon, name, description, level, exercise count, duration, progress ring/bar, **Start course / Continue** → 11.

**11 Course details + exercise list** (Nav Courses, back) — AppBar title = course name. Hero band (`brand/deep`, mint overline "COURSE", description, 3 meta chips: duration, exercises, camera needed). Progress bar "2 of 5 completed". **Exercise list** (5 rows): number badge, name, "10 reps · 2 sets", status (Not started / In progress / Completed with latest score), chevron → 13. ActionBar: **Continue** (next unfinished exercise → 13).

**13 Exercise details** (Nav Courses, back) — AppBar title = exercise name, subtitle = course; right icon `help` → 28. Demo video placeholder 200 dp (play button, "Demo video · 0:45"; if no asset, show pose illustration). Sections: "What it helps" (Body), Targets row (reps, sets, rest), "How to do it" numbered 3–5 steps, "Watch out for" (warning tint card), Movement score disclaimer (Caption). ActionBar (above nav): **Start exercise** → 14.

### 8.3 Exercise session (no nav except 19/35/34)

**14 Pre-exercise checklist** — AppBar "Get ready" (back → 13). Intro line. Checklist (each is a tappable checkbox row with icon): Phone propped at hip height, 2 m away · Bright, even lighting · Clear space · Full body visible · Comfortable clothing · "I'm not in pain" (safety). Start enabled when all ticked (or "Skip tips"). ActionBar: **Start camera** → 15.

**15 Camera setup & body alignment** — camera bg. Top: glass back IconButton (→ 14, stops camera), title "Position yourself". Silhouette guide + live skeleton. Status chip cycles: "Step back a little" · "Move into frame" · "Body detected ✓". Bottom card: instruction + **I'm ready** (enabled only when body detected for 1 s; Primary) → 16. Text "Body not detected?" → 33 after 10 s undetected (also shown manually).

**16 Live tracking** — camera bg + skeleton.
- Top bar: exercise name + "Set 1 of 2", glass timer pill, audio IconButton (toggle, persists).
- Floating angle pill near the tracked joint ("Knee 92° · target 90°").
- Bottom panel (white, radius 24, Elevation/Sheet): Overline "Reps", RepCounter `4 / 10`, phase chip (Moving down / Hold / Moving up), progress bar, FeedbackLine (one line only; tint success/warning/error), controls row: Pause IconButton (52, filled) → 17; **End session** (Secondary Large) → 18.
- No nav, no extra metrics, no back chevron; system back → 18.
- Auto-complete when target reps reached → 19. Safety alert condition → 40.
- Per rep: classify Correct / Incorrect / Incomplete (§9.3), haptic tick, optional spoken cue.

**17 Pause** — bg `brand/deep`, eye-off circle, "Camera paused · preview hidden", Display/Large "Paused", 3-stat strip (Reps, Time, Set), **Resume** (On-dark filled) → 16, **End session** (On-dark outline) → 18. Timer stopped; camera stream released after 30 s.

**18 End confirmation** — dialog over dimmed camera: warning icon circle, "End this session?", "You've done 4 of 10 reps. The remaining reps will be saved as incomplete. Nothing is marked as done that wasn't." **Continue exercise** (Primary) → 16, **Finish session** (Destructive outline) → 19.

**19 Session summary** (Nav visible, leave-guarded) — AppBar "Session summary", no back, trailing ✕ (guarded). Gold milestone banner only on personal best. Score ring (Display/Large "86", "Movement score"). Outcome trio tiles: Correct 7 / Incorrect 2 / Incomplete 1 (icon + colour + count). Metrics card: duration, avg ROM, tempo, symmetry. "Tips for next time" (1–3 bullets from rule engine). Disclaimer Caption. ActionBar: **Save result** (Primary) → 35; row **Retry** → 14, **Next exercise** → 13 of the next exercise (hidden/replaced by "Finish course" if last). Text "Back to home" guarded.

**35 Saved** — check-circle (mint), "Result saved", "Saved on this phone. Syncs when online." If gold milestone → gold wash card "Personal best". Buttons: **Back to home** (Primary) → 09, **View progress** (Secondary) → 20, Text "View this session" → 23. Nav visible.

**33 Camera / tracking error** — camera bg dim. Back → 15. Red-tint card: icon, "We can't see you clearly", causes list (lighting, distance, camera blocked, other people), **Try again** → 15, Text "View camera tips" → 28.

**38 Interrupted session** — dialog on 09: "Pick up where you left off?" Exercise name, "4 of 10 reps · interrupted 12 min ago". **Resume** (Primary) → 15 (restored), **Discard and start over** (Secondary) → deletes draft then 14. Interrupted reps are stored Incomplete.

**40 Safety alert** — overlay on 16: red-bordered skeleton joint, icon, "Move carefully" / "Check your position", no clinical claims. **Pause exercise** (Primary) → 17, **I feel fine, continue** (Secondary) → 16. Triggered by out-of-range angle or sudden pose loss; max once per 20 s.

**34 Network / sync error** — wifi-off circle, "You're offline", "Your result is saved on this phone and will sync automatically." **Try again** → retries sync; success → 35 else stays; Text **Continue offline** → 09. Nav visible.

**42 Leave without saving?** (new) — sheet described in §5.4.

### 8.4 Progress & history

**20 Progress** (Nav Progress) — H1 + sub. SegmentedControl Week/Month/All time. 2×2 StatTiles (Sessions, Reps, Avg score, Streak). LineChart "Movement score over time" (tap → 21 for the selected exercise). "Exercises" list (per-exercise latest score, trend) → 21. "Recent sessions" + "View all" → 22; rows → 23. Gold appears only for a personal best.

**21 Exercise progress** (Nav Progress, back) — AppBar exercise name. Best score, average, attempts. Chart. Outcome distribution bar (Correct/Incorrect/Incomplete). Sessions list → 23. Empty state per §7.2.

**22 Session history** (Nav Progress, **back added**) — AppBar "History". Search field, FilterChips (All · Course 1 · Course 2 · This week). Grouped by day (Overline). Row: exercise name, course, time · duration, reps "10/10", StatusChip → 23. Variants: 39a Empty, loading skeleton, filter-no-results ("No sessions match").

**23 Session details** (Nav Progress, back) — AppBar "Session details". Header: exercise, date/time. Score ring, outcome trio, per-rep timeline (strip of ✓/✗/– with rep numbers; tap rep shows its feedback), metrics, feedback given, notes. ActionBar above nav: **Retry exercise** → 13. Overflow menu: Delete session (confirm).

### 8.5 Profile & settings

**24 Profile** (Nav Profile) — Avatar 72, name, email, **Edit profile** (Secondary Medium) → 25. Menu card: Edit profile, Settings (→ 26), Notifications (→ 27), Help & FAQ (→ 28), Privacy & data (→ 29), About (→ 30). Separate card: **Log out** (danger) → 36. Sync status row.

**25 Edit profile** (Nav Profile, back) — Avatar (initials, tap to change colour), Name, Email (read-only with "Verified" chip), Age range, Goal. ActionBar above nav: **Save changes** (Primary, enabled when dirty) → saves and pops; **Cancel** (Text) → pops (dirty → 43).

**26 Settings** (Nav Profile, back) — Groups: *Exercise* (Audio feedback toggle, Haptics toggle, Voice cues language, Show skeleton toggle), *Account* (Change password → **44**), *More* (Notification preferences → 27, Help & FAQ → 28, Privacy & data → 29, About → 30). Persist instantly (no Save).

**44 Change password** (new) — current, new, confirm, rules. **Update password**; success toast, pop to 26.

**27 Notification preferences** (Nav Profile, back) — Toggles: Exercise reminders, Weekly progress summary, Tips. Time picker for reminder, day chips. **Save preferences** (ActionBar above nav) → pops; dirty-guard 43. Permission prompt for OS notifications on first enable.

**41 Notification inbox** (new, Home tab) — list of in-app messages (reminder, milestone, tip); unread dot; swipe to dismiss; empty state.

**28 Help & FAQ** (Nav Profile, back) — Search, accordion FAQs (Camera won't detect me, How are reps counted?, Why "incomplete"?, Is my video saved?, Sync issues), "Camera tips" illustrated card, Contact card (`brand/deep`): mailto action.

**29 Privacy & data** (Nav Profile, back) — What we store (name, email, optional age range; session results; preferences), what we don't (video/images), buttons: Export my data (JSON share), Clear local sessions (confirm), **Delete account** (danger row) → 37.

**30 About** (Nav Profile, back) — Logo, version, mission, disclaimer, Team list (names configurable: Muhammad Rizwan Shahzad, Muhammad Shariq Khan, Manahil Tariq, Quratulain Muqaddas), Licences link.

**36 Log out dialog** — "Log out?" "Your sessions are saved to your account." **Cancel** (Secondary) / **Log out** (Dark). Confirm → §5.3.

**37 Delete account dialog** — warning, consequences list, requires typing `DELETE` or re-entering password. **Delete account** (Destructive, disabled until valid) / **Cancel** (Text) → 29. Confirm → wipe data, go 02.

**43 Discard changes?** (new) — **Keep editing** (Primary) / **Discard** (Destructive outline).

---

## 9. Behaviour & data

### 9.1 Domain model (local-first, SQLite via drift)
```
User(id, name, email, emailVerified, ageRange?, goal?, createdAt)
Preferences(userId, audio, haptics, showSkeleton, reminders{enabled,time,days}, weeklySummary, tips)
Course(id, name, description, level, exerciseIds[])           // seeded
Exercise(id, courseId, order, name, targets{reps,sets,restSec}, joints[], thresholds, steps[], mediaAsset?)
Session(id, userId, exerciseId, startedAt, endedAt, status{draft|saved|interrupted}, score, reps[], metrics, syncState{local|pending|synced})
Rep(index, outcome{correct|incorrect|incomplete}, peakAngle, durationMs, feedbackKey)
Notification(id, type, title, body, createdAt, read)
```
Seed 2 courses × 5 exercises. Suggested Course 1: Mini squat, Straight-leg raise, Seated knee extension, Heel slide, Step-up. Course 2: Pendulum swing, Shoulder flexion, External rotation, Wall slide, Scapular squeeze (names editable in seed).

### 9.2 Pose pipeline
- `camera` plugin (front camera default, 720p, 30 fps) + on-device pose landmarks (`google_mlkit_pose_detection`, stream mode). Process every frame, smooth with a 5-frame moving average; confidence threshold 0.6.
- Joint angle = angle at joint B between segments AB and BC using 2D landmark coordinates (z optional).
- Body-in-frame check: required landmarks per exercise visible with confidence > 0.6 for ≥ 1 s.
- Landmarks set (13 bones): neck–shoulders, shoulder–elbow–wrist (L/R), shoulders–hips, hip–hip, hip–knee–ankle (L/R).

### 9.3 Rep state machine
```
IDLE → DOWN (angle < downThreshold) → HOLD (optional) → UP (angle > upThreshold) → COUNT
```
- **Correct**: reached target range (± tolerance) and form rules passed.
- **Incorrect**: completed the cycle but a form rule failed (e.g. back angle, knee valgus, range too small by >15%).
- **Incomplete**: cycle not finished (user stopped, tracking lost > 1 s, interrupted).
- Only **Correct** + **Incorrect** increment the visible rep counter; Incomplete reps appear on the summary only.
- Feedback priority: safety > form error > encouragement; show **one** line, hold ≥ 1.5 s; spoken cue max every 4 s and only if audio on.
- Movement score = `round(100 × (correct + 0.5·partialCredit) / target)` capped 0–100, where partialCredit is the sum of range-accuracy ratios for incorrect reps. Explain score in 13/19 copy.

### 9.4 Save pipeline
1. On 19 enter: create `draft` session row.
2. Save result → status `saved`, syncState `pending`, show 35 immediately (never blocked by network).
3. Background sync with exponential back-off; failure shows non-blocking banner; 34 only if the user taps "Sync now" and it fails.
4. App killed mid-session: last checkpoint (every rep) stored as `interrupted` → 38.

### 9.5 Backend
Any REST/Firebase auth is acceptable; abstract behind `AuthRepository` and `SyncRepository` interfaces with **fake in-memory implementations** shipped so the app runs without a backend. Email verification and reset use real flows if configured, simulated otherwise (6 s delay → verified).

---

## 10. Accessibility
- Hit targets ≥ 48×48 dp; spacing ≥ 8 dp between adjacent targets.
- Contrast ≥ 4.5:1 for text (verify `text/secondary` @ 58% on `canvas`: acceptable for 14 px+ only).
- Every IconButton, chip and icon has `Semantics(label)`. Rep outcomes announce "Rep 4, correct".
- Live screen: announce count via `SemanticsService.announce` when audio is on or TalkBack enabled.
- Dynamic type to 130%; no fixed-height text containers.
- Focus order follows reading order; dialogs trap focus and announce title.
- Reduced motion respected.
- Never colour alone: outcomes = icon + colour + text.

---

## 11. Copy rules
- Sentence case, second person, calm tone, no exclamation marks except milestones.
- Never: "diagnose", "treat", "cure", "injury risk", "medical grade".
- Errors: what happened → what to do ("We can't see you clearly. Move back until your full body is in view.").
- Disclaimer (canonical): "RehabSense is a guidance tool. It does not diagnose or replace a physiotherapist."

---

## 12. Flutter implementation blueprint

```
lib/
  main.dart
  app/            router.dart (go_router), shell_scaffold.dart, theme/
  core/           tokens.dart (RSColors, RSText, RSSpacing, RSRadius, RSShadows), widgets/ (components §4), utils/
  data/           db/ (drift), repositories/, seed/
  domain/         models, pose/ (angle math, rep_state_machine.dart, feedback_rules.dart)
  features/
    auth/ onboarding/ home/ courses/ session/ progress/ profile/ notifications/
assets/ fonts/Inter-*.ttf, icons/, images/
```
Packages: `go_router`, `flutter_riverpod`, `drift` + `sqlite3_flutter_libs`, `camera`, `google_mlkit_pose_detection`, `permission_handler`, `flutter_tts`, `flutter_local_notifications`, `shared_preferences`, `lucide_icons`, `wakelock_plus`, `url_launcher`, `intl`.
Flutter ≥ 3.22. Theme: `ThemeData(useMaterial3: true)`, `scaffoldBackgroundColor: RSColors.surfaceCanvas`, button shapes `StadiumBorder`, card radius 12.

Shell: `StatefulShellRoute.indexedStack` with 4 branches (home, courses, progress, profile); `ShellScaffold` builds `BottomNav` once. `/session/*` is declared on the **root navigator key** so it covers the shell, **except** 19/35/34 which render inside a `ShellScaffold`-wrapped route so the nav is visible (19 uses a `PopScope` + tab-tap interceptor that triggers sheet 42).

---

## 13. Acceptance checklist (must all pass)

**Navigation**
- [ ] Bottom nav visible on 09, 10, 11, 13, 20, 21, 22, 23, 24–30, 41, 19, 35, 34, 39a, 39b; hidden on auth, 14–18, 33, 40, and when keyboard is open.
- [ ] Nav never overlapped by an ActionBar; both visible together on 13, 23, 25, 27.
- [ ] Every non-root screen has an app-bar back; every tab root has none.
- [ ] Re-tapping the active tab pops to its root; switching tabs preserves each stack.
- [ ] Back from 22 returns to 20 (or 09 if opened from Home). Back from 23 returns to its origin.
- [ ] After logout/delete, Back does not return to signed-in screens.
- [ ] System back follows §5.5 on every screen; 16 never exits without 18.
- [ ] Leaving 19 unsaved always shows 42; saved results never show it.
- [ ] 07 has no back; 08 back → 07.

**Flows**
- [ ] First-run: 01→02→04→31→07→08→09 and 08 denied → 32 → settings → resumes.
- [ ] Core: 09/10→11→13→14→15→16→(17/18/40)→19→35→(09|20|23).
- [ ] Resume from Home restores counts; app kill during 16 → 38 on next launch.
- [ ] Change password in-app (44) never opens the forgot-password flow.
- [ ] Bell opens 41.

**Visual**
- [ ] No pure white page backgrounds; gold only on personal-best.
- [ ] All colours/typography from tokens; no hard-coded hex outside `tokens.dart`.
- [ ] Verified at 360×800, 412×915, 390×844, and 130% font scale with no clipping.
- [ ] Loading, empty, error variants exist for 09, 20, 21, 22, 41.

**Product rules**
- [ ] Live screen shows only items listed in §1, rule 1.
- [ ] Three outcomes with icon + colour + label everywhere; interrupted reps stored Incomplete.
- [ ] No video/image persisted (verify no file writes from the camera pipeline).
- [ ] Disclaimer on 02, 08, 13, 19, 30.

---

## 14. Screen inventory (final, 44)
01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39a, 39b, 40 (original 40) **+ new:** 41 Notification inbox, 42 Leave-without-saving sheet, 43 Discard-changes dialog, 44 Change password. Plus states per §7.
