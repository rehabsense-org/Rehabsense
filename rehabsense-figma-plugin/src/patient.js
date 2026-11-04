// PATIENT PORTAL - screen IDs follow UPDATE_BRIEF section 4
function buildPatient() {
  GROUP = 'PATIENT - Existing and Changed screens';
  let s;

  // ---------- Auth ----------
  s = Screen('P-01', 'Splash', 'CHANGED', { bg: C.brandDeep, gap: 16 });
  s.add(rectSpacer(260), col([iconCircle('activity', 96, C.brandUplift, C.brandMint), txt('RehabSense', 'displayMedium', C.textOnDark, { align: 'CENTER' }), txt('Rehab, guided by your camera', 'body', C.textOnDarkSoft, { align: 'CENTER' })], { gap: 16, cross: 'CENTER' }));
  link(s.f, 'P-02', { timeout: 1.6 }); s.finish();

  s = Screen('P-02', 'Welcome', 'CHANGED', {});
  s.add(rectSpacer(24), col([iconCircle('activity', 120), txt('Rehab, guided by your camera', 'h1', C.brandGreen, { align: 'CENTER' })], { gap: 20, cross: 'CENTER' }),
    bullet('camera', 'On-device tracking', 'Your camera video never leaves your phone.'), bullet('shield', 'Private by design', 'No video or images are stored.'), bullet('heart', 'Safe, guided exercises', 'Clear feedback on every repetition.'),
    txt('RehabSense supports your recovery. It does not replace medical advice.', 'caption', C.textSecondary, { align: 'CENTER' }),
    btn('Get started', { to: 'P-04' }), btn('I already have an account', { v: 'secondary', to: 'P-03' }),
    row([btn('I am a Doctor', { v: 'text', size: 'M', to: 'D-01', full: false }), btn('Staff login', { v: 'text', size: 'M', to: 'A-01', full: false })], { main: 'CENTER', gap: 8 }));
  s.finish();

  s = Screen('P-03', 'Login', 'CHANGED', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(heading('Welcome back', 'Log in to continue your rehab.'), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), input('Password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'P-06', full: false }), btn('Log in', { to: 'P-11' }),
    txt('or', 'small', C.textSecondary, { align: 'CENTER' }), btn('Create account', { v: 'secondary', to: 'P-04' }),
    row([btn('Prototype: inactive account', { v: 'text', size: 'M', to: 'P-52', full: false })], { main: 'CENTER' }));
  s.finish();

  s = Screen('P-04', 'Register', 'EXISTING', { app: { title: '', back: 'P-02' }, gap: 14 });
  s.add(heading('Create your account', 'Patient account. It takes a minute.'), input('Full name', { icon: 'user', value: 'Alex Morgan' }), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), input('Password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }),
    card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }),
    input('Confirm password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), checkRow('I agree to the Terms and Privacy Policy', true),
    btn('Create account', { to: 'P-05' }), row([txt('Already have an account?', 'small', C.textSecondary, { hug: true }), btn('Log in', { v: 'text', size: 'M', to: 'P-03', full: false })], { main: 'CENTER', gap: 4 }));
  s.finish();

  s = Screen('P-05', 'Verify Email (OTP)', 'CHANGED', { app: { title: '', back: 'P-04' }, gap: 20 });
  s.add(rectSpacer(8), col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to alex@rehab.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }),
    otp('482'), banner('info', 'Codes expire after 10 minutes. Check your spam folder.'), btn('Verify', { to: 'P-08' }),
    btn('Resend code (60s)', { v: 'text', to: 'P-05b' }), btn('Change email address', { v: 'text', to: 'P-04' }));
  s.finish();
  s = Screen('P-05b', 'Verify Email - wrong code', 'CHANGED', { app: { title: '', back: 'P-04' }, gap: 20 });
  s.add(rectSpacer(8), col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to alex@rehab.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }),
    banner('error', 'That code is wrong or expired. Request a new one.'), otp('482913'), btn('Verify', { to: 'P-08' }), btn('Resend code', { v: 'text', to: 'P-05' }));
  s.finish();

  s = Screen('P-06', 'Forgot Password', 'EXISTING', { app: { title: '', back: 'P-03' }, gap: 16 });
  s.add(heading('Forgot password?', 'Enter your email and we will send a reset link.'), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), btn('Send reset link', { to: 'P-06b' }), btn('Back to log in', { v: 'text', to: 'P-03' }));
  s.finish();
  stateScreen('P-06b', 'Forgot Password - sent', 'EXISTING', { app: { title: '', back: 'P-06' }, icon: 'mail', title: 'Check your email', body: 'We sent a reset link to alex@rehab.test.', pad: 40, buttons: [['Open email app', 'P-07'], ['Resend email', 'P-06b', 'secondary'], ['Back to log in', 'P-03', 'text']] });
  s = Screen('P-07', 'Reset Password', 'EXISTING', { app: { title: '', close: true, back: 'P-03' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', suffix: 'eye' }), card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }), input('Confirm password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), btn('Update password', { to: 'P-03' }));
  s.finish();

  // ---------- Onboarding ----------
  s = Screen('P-08', 'Profile Setup', 'EXISTING', { gap: 16 });
  s.add(rectSpacer(8), stepHeader(1, 2, 'Profile'), heading('Tell us about you', 'Only what is needed. You can change it later.'), input('Display name', { icon: 'user', value: 'Alex' }), overline('Age range'),
    chips(['Under 18', '18-29', '30-44', '45-64', '65+'], 2), overline('Main goal'),
    card([row([iconCircle('activity', 40), txt('Knee recovery', 'bodyStrong')], { gap: 12 })], { stroke: C.brandAction }), card([row([iconCircle('activity', 40), txt('Shoulder mobility', 'bodyStrong')], { gap: 12 })]), card([row([iconCircle('heart', 40), txt('General', 'bodyStrong')], { gap: 12 })]),
    btn('Save and continue', { to: 'P-09' }), btn('Skip for now', { v: 'text', to: 'P-09' }));
  s.finish();

  s = Screen('P-09', 'Safety and Consent', 'EXISTING', { app: { title: '', back: 'P-08' }, gap: 14 });
  s.add(stepHeader(2, 2, 'Safety'), bullet('camera', 'On-device tracking', 'Your camera is processed on this phone only.'), bullet('shield', 'Medical privacy', 'No video or images are saved or uploaded.'), bullet('heart', 'Exercise safely', 'Stop if you feel sharp pain or dizziness.'),
    card([txt('RehabSense is a guidance tool. It is not a medical device and does not replace advice from your doctor or physiotherapist.', 'small', C.textMutedGreen)], { fill: C.brandMint, flat: true }),
    checkRow('I understand and agree', true), btn('Allow camera and continue', { to: 'P-11' }), btn('Not now', { v: 'text', to: 'P-10' }));
  s.finish();
  stateScreen('P-10', 'Camera Help', 'EXISTING', { app: { title: '', back: 'P-09' }, icon: 'cameraOff', title: 'Camera access is off', body: 'RehabSense needs your camera to count reps. Turn it on in Settings > Permissions > Camera.', pad: 24, buttons: [['Open settings', 'BACK'], ['Back to home', 'P-11', 'secondary']] });

  // ---------- Home (6 prescribed states) ----------
  const homeBase = function (id, name, st, cont, nav) {
    const s = Screen(id, name, st, { nav: 'patient', active: 0, gap: 16 });
    s.add(row([col([txt('Good morning, Alex', 'h3', C.textPrimary), txt('Ready for today\u2019s session?', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'P-27'), (function () { const a = avatar('AM', 40); link(a, 'P-28'); return a; })()], { gap: 4 }));
    s.add(card([txt('Continue where you left off', 'captionStrong', C.textOnDarkSoft), txt('Mini Squats', 'h3', C.textOnDark), txt('4 of 10 reps done \u00B7 about 3 min left', 'small', C.textOnDarkSoft), bar(0.4, 8, C.brandMint, C.brandUplift), btn('Resume', { v: 'onDarkFilled', size: 'M', to: 'P-16' })], { fill: C.brandDeep, r: R.hero, gap: 10 }));
    s.add(cont);
    s.add(card([txt('Today\u2019s plan', 'captionStrong', C.textSecondary), txt('Straight-Leg Raise', 'bodyStrong'), txt('2 sets \u00B7 10 reps \u00B7 45 s rest', 'small', C.textSecondary), btn('Start', { size: 'M', to: 'P-14' })], { gap: 8, to: 'P-14' }));
    s.add(sectionTitle('Courses', 'See all', 'P-12'));
    s.add(listItem('Knee Rehabilitation', '5 exercises \u00B7 Beginner', { icon: 'activity', right: '40%', to: 'P-13' }), listItem('Shoulder Mobility', '5 exercises \u00B7 Beginner', { icon: 'activity', right: '0%', to: 'P-13' }));
    s.add(sectionTitle('Recent activity', 'View all', 'P-25'));
    s.add(listItem('Mini Squats', 'Today \u00B7 10:30 AM', { chip: status('correct', '86'), to: 'P-26' }), listItem('Heel Slide', 'Yesterday \u00B7 6:10 PM', { chip: status('incomplete', '64'), to: 'P-26' }));
    s.finish(); return s;
  };
  const presBox = function (title, body, chipEl, cta) { return card([row([iconCircle('clipboard', 40), col([txt('Prescribed by your doctor', 'captionStrong', C.brandGreen), txt(title, 'bodyStrong')], { gap: 0, grow: true }), chipEl], { gap: 12 }), body ? txt(body, 'small', C.textSecondary) : null, cta], { gap: 12, stroke: C.brandAction, name: 'PrescribedContainer' }); };
  homeBase('P-11', 'Home - Prescribed locked', 'CHANGED', presBox('Connect with a doctor', 'Get exercises made for you and let your doctor follow your progress.', status('neutral', 'Locked'), btn('Connect with a doctor', { v: 'secondary', size: 'M', to: 'P-37' })));
  homeBase('P-11b', 'Home - Request pending', 'CHANGED', presBox('Request sent to Dr. Sara Khan', 'We will tell you as soon as she responds.', status('pending', 'Pending'), btn('View request', { v: 'secondary', size: 'M', to: 'P-43' })));
  homeBase('P-11c', 'Home - Connected, no exercises', 'CHANGED', presBox('Connected with Dr. Sara Khan', 'Your doctor has not assigned exercises yet.', status('correct', 'Connected'), btn('My doctor', { v: 'secondary', size: 'M', to: 'P-46' })));
  homeBase('P-11d', 'Home - Connected, assigned', 'CHANGED', presBox('2 exercises assigned', 'Next: Mini Squats \u00B7 3 sets of 10 \u00B7 today', status('correct', 'Active'), btn('Open prescribed', { size: 'M', to: 'P-48' })));
  homeBase('P-11e', 'Home - Doctor inactive', 'CHANGED', presBox('Your doctor is not available', 'Dr. Sara Khan is no longer active on RehabSense.', status('incomplete', 'Inactive'), btn('Find another doctor', { v: 'secondary', size: 'M', to: 'P-37' })));
  s = Screen('P-11f', 'Home - Loading skeleton', 'EXISTING', { nav: 'patient', active: 0, gap: 16 });
  s.add(skel(48, 0), skel(150, 16), skel(110, 12), skel(70, 12), skel(70, 12), skel(70, 12)); link(s.f, 'P-11', { timeout: 1.2 }); s.finish();

  s = Screen('P-27', 'Notification Inbox', 'CHANGED', { app: { title: 'Notifications', back: 'BACK' }, gap: 12 });
  s.add(listItem('Request accepted', 'Dr. Sara Khan accepted your request \u00B7 2 min ago', { icon: 'check', to: 'P-44' }), listItem('New exercise assigned', 'Mini Squats was added to your plan \u00B7 1 h ago', { icon: 'clipboard', to: 'P-48' }),
    listItem('Doctor feedback', 'Great control on your last session \u00B7 Yesterday', { icon: 'heart', to: 'P-26' }), listItem('Request declined', 'Dr. Omar Sheikh could not take new patients \u00B7 2 d', { icon: 'x', to: 'P-45' }),
    listItem('Doctor not available', 'Your doctor is no longer active \u00B7 3 d', { icon: 'alert', to: 'P-37' }), listItem('Reminder', 'Time for today\u2019s exercises \u00B7 3 d', { icon: 'bell', to: 'P-11' }));
  s.finish();

  // ---------- Courses ----------
  const coursesTabs = ['P-12a', 'P-12', 'P-12b'];
  s = Screen('P-12', 'Courses - Rehab', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 1, coursesTabs),
    courseCard('Knee Rehabilitation', 'Beginner \u00B7 5 exercises \u00B7 about 25 min', 'Restore range of motion and strength after knee injury or surgery.', 0.4, 'P-13'), courseCard('Shoulder Mobility', 'Beginner \u00B7 5 exercises \u00B7 about 20 min', 'Gentle movements to regain shoulder motion and control.', 0, 'P-13'));
  s.finish();
  s = Screen('P-12a', 'Courses - Wellness and Yoga (empty)', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 0, coursesTabs), card([col([iconCircle('heart', 72), txt('Yoga poses are coming soon', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Hold-pose exercises will appear here.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Browse rehab courses', { v: 'secondary', size: 'M', to: 'P-12' })], { gap: 12, cross: 'CENTER' })], { pad: [32, 16, 32, 16] }));
  s.finish();
  s = Screen('P-12b', 'Courses - Prescribed (locked)', 'CHANGED', { nav: 'patient', active: 1, gap: 16 });
  s.add(heading('Courses', 'Guided programs for your recovery.'), seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 2, coursesTabs), card([col([iconCircle('lock', 72), txt('Prescribed is locked', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Connect with a doctor to receive exercises made for you.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Connect with a doctor', { size: 'M', to: 'P-37' })], { gap: 12, cross: 'CENTER' })], { pad: [32, 16, 32, 16] }));
  s.finish();

  s = Screen('P-13', 'Course Detail', 'EXISTING', { app: { title: 'Knee Rehabilitation', back: 'P-12' }, action: { label: 'Continue course', to: 'P-14' }, gap: 12 });
  s.add(card([txt('Beginner', 'captionStrong', C.textOnDarkSoft), txt('Knee Rehabilitation', 'h3', C.textOnDark), txt('Restore range of motion and strength after knee injury or surgery.', 'small', C.textOnDarkSoft), bar(0.4, 8, C.brandMint, C.brandUplift)], { fill: C.brandDeep, r: R.hero }),
    sectionTitle('Exercises'), listItem('1. Mini Squat', '3 sets \u00B7 10 reps', { icon: 'activity', chip: status('correct', 'Done'), to: 'P-14' }), listItem('2. Straight-Leg Raise', '2 sets \u00B7 10 reps', { icon: 'activity', to: 'P-14' }),
    listItem('3. Seated Knee Extension', '2 sets \u00B7 12 reps', { icon: 'activity', to: 'P-14' }), listItem('4. Heel Slide', '2 sets \u00B7 10 reps', { icon: 'activity', to: 'P-14' }), listItem('5. Step-Up', '2 sets \u00B7 8 reps', { icon: 'activity', to: 'P-14' }));
  s.finish();

  s = Screen('P-14', 'Exercise Detail', 'EXISTING', { app: { title: 'Mini Squat', back: 'P-13' }, action: { label: 'Start exercise', to: 'P-15' }, gap: 14 });
  s.add(card([row([iconCircle('activity', 56), col([txt('Mini Squat', 'h3'), txt('Knee Rehabilitation \u00B7 Exercise 1', 'small', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 }), divider(), kv('Target', '3 sets of 10 reps'), kv('Rest', '45 seconds'), kv('Camera view', 'Side'), kv('Joint tracked', 'Knee')]),
    sectionTitle('How to do it'), card([checkRow('Stand with feet shoulder-width apart', false), checkRow('Bend knees slowly to about 30 degrees', false), checkRow('Hold for 1 second, then rise slowly', false)], { gap: 10 }),
    sectionTitle('Watch out for'), infoBox('Do not let your knee move past your toes. Stop if you feel sharp pain.', 'warn'));
  s.finish();

  s = Screen('P-15', 'Pre-Exercise Checklist', 'EXISTING', { app: { title: 'Get ready', back: 'P-14' }, action: { label: 'Continue', to: 'P-16' }, gap: 14 });
  s.add(heading('Quick checklist', 'A minute now gives you better tracking.'), card([checkRow('Clear 2 metres of space', true), checkRow('Prop your phone at hip height', true), checkRow('Wear fitted clothing', true), checkRow('Good lighting, no strong backlight', false), checkRow('Stand on a flat, non-slip surface', false)], { gap: 14 }), infoBox('Stop right away if you feel sharp pain, dizziness or chest tightness.', 'warn'), overline('Prototype shortcuts'), btn('Hold exercise tracking', { v: 'text', size: 'M', to: 'P-17H' }), btn('Invalid tracking config', { v: 'text', size: 'M', to: 'P-17x' }));
  s.finish();

  s = Screen('P-16', 'Camera Setup', 'CHANGED', { camera: true });
  skeleton(s, { color: '#FFFFFF' });
  s.abs(statusBar(true), 0, 0);
  glassBtn(s, 'left', 8, 32, 'P-15'); glassBtn(s, 'help', 304, 32, 'P-10');
  pill(s, 'Side view \u00B7 place phone to your right', 40, 92, 280);
  const guide = mk('Guide', { dir: 'V', gap: 12, pad: [16, 16, 16, 16], fill: C.brandDeep, r: R.sheet, w: 328 });
  A(guide, txt('Step into the frame', 'h3', C.textOnDark), txt('Camera view: Side. Make sure your whole body is visible.', 'small', C.textOnDarkSoft), btn('Body detected - start', { v: 'onDarkFilled', to: 'P-17' }), btn('Lost tracking?', { v: 'onDarkOutline', size: 'M', to: 'P-21' }));
  s.abs(guide, 16, 800 - guide.height - 24); s.finish();

  const live = function (id, name, st, o) {
    const s = Screen(id, name, st, { camera: true });
    skeleton(s, { color: o.color });
    s.abs(statusBar(true), 0, 0);
    glassBtn(s, 'pause', 8, 32, 'P-18'); glassBtn(s, 'x', 304, 32, id === 'P-17' ? 'P-17E' : 'P-17E');
    const top = mk('Counter', { dir: 'V', cross: 'CENTER', gap: 0, w: 360 });
    A(top, txt(o.metric, 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt(o.sub, 'bodyStrong', C.textOnDarkSoft, { hug: true, align: 'CENTER' })); s.abs(top, 0, 96);
    pill(s, o.feedback, 40, 560, 280, o.warn ? C.warning : C.glass, o.warn ? C.warningInk : C.textOnDark);
    const dock = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 });
    A(dock, row([txt(o.left, 'smallStrong', C.textOnDark), txt(o.right, 'smallStrong', C.textOnDark, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN' }), bar(o.prog, 8, C.brandMint, C.brandUplift), btn('Finish exercise', { v: 'onDarkFilled', size: 'M', to: 'P-19' }));
    s.abs(dock, 0, 800 - dock.height); s.finish(); return s;
  };
  live('P-17', 'Live Tracking - rep', 'CHANGED', { metric: '4', sub: 'of 10 reps \u00B7 set 1 of 3', feedback: 'Good depth. Keep your back straight.', left: 'Movement score 86', right: 'Knee angle 42\u00B0', prog: 0.4 });
  live('P-17H', 'Live Tracking - hold', 'NEW', { metric: '0:12', sub: 'hold 30 s \u00B7 attempt 2 of 3', feedback: 'Hold steady. 18 s to go.', left: 'Angle in range', right: 'Grace 2 s', prog: 0.4 });
  s = Screen('P-17x', 'Live Tracking - invalid config', 'NEW', { camera: true }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'left', 8, 32, 'P-14');
  const bad = mk('Err', { dir: 'V', gap: 12, cross: 'CENTER', pad: [24, 24, 24, 24], fill: C.surfaceCard, r: R.hero, w: 312 });
  A(bad, iconCircle('alert', 56, C.warningTint, C.warningInk), txt('This exercise is not ready for tracking', 'h3', C.textPrimary, { align: 'CENTER' }), txt('Ask your doctor to review the exercise setup.', 'small', C.textSecondary, { align: 'CENTER' }), btn('Back to exercise', { to: 'P-14' }));
  s.abs(bad, 24, 280); s.finish();

  s = Screen('P-18', 'Pause', 'EXISTING', { bg: C.brandDeep, gap: 16 });
  s.add(rectSpacer(140), col([iconCircle('pause', 96, C.brandUplift, C.brandMint), txt('Paused', 'h1', C.textOnDark, { align: 'CENTER' }), txt('4 of 10 reps \u00B7 set 1 of 3', 'body', C.textOnDarkSoft, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }), btn('Resume', { v: 'onDarkFilled', to: 'P-17' }), btn('End session', { v: 'onDarkOutline', to: 'P-19' }));
  s.finish();
  dialogScreen('P-17E', 'End Confirmation Dialog', 'EXISTING', { icon: 'alert', title: 'End this session?', body: 'You have done 4 of 10 reps. You can save your progress.', primary: ['End and see summary', 'P-19'], secondary: ['Keep going', 'BACK'] });

  const summary = function (id, name, st, o) {
    const s = Screen(id, name, st, { app: { title: 'Session summary', close: true, back: 'P-19L' }, action: { label: o.save, to: o.saveTo }, gap: 16 });
    s.add(col([ring(86, 140, o.gold), txt(o.gold ? 'New personal best!' : 'Nice work, Alex', 'h3', C.textPrimary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }));
    if (o.gold) s.add(card([txt('Personal best for Mini Squat', 'smallStrong', C.accentGoldDeep)], { fill: C.accentGoldWash, stroke: C.accentGold, flat: true }));
    s.add(statRow([['Reps', '10'], ['Correct', '7'], ['Time', '3:12']]));
    s.add(row([status('correct', '7 Correct'), status('incorrect', '1 Incorrect'), status('incomplete', '2 Incomplete')], { gap: 8 }));
    if (o.shortcuts) s.add(overline('Prototype shortcuts'), btn('Prescribed session with pain', { v: 'text', size: 'M', to: 'P-19P' }), btn('Pain 8 or more', { v: 'text', size: 'M', to: 'P-19S' }), btn('Personal best', { v: 'text', size: 'M', to: 'P-19G' }));
    if (o.pain) { s.add(sectionTitle('How was your pain?'), card([slider(o.pain), area('Comment (optional)', o.comment || '', 72)]));
      if (o.pain >= 8) s.add(banner('error', 'High pain is not normal. Stop exercising and contact your doctor or a medical professional.')); }
    s.finish(); return s;
  };
  summary('P-19', 'Session Summary', 'CHANGED', { save: 'Save result', saveTo: 'P-20', shortcuts: true });
  summary('P-19P', 'Summary - prescribed with pain', 'NEW', { save: 'Save and send to doctor', saveTo: 'P-20', pain: 3, comment: 'Slight stiffness at the end' });
  summary('P-19S', 'Summary - pain 8 or more', 'NEW', { save: 'Save and send to doctor', saveTo: 'P-20', pain: 8, comment: 'Sharp pain on the last reps' });
  summary('P-19G', 'Summary - personal best', 'EXISTING', { save: 'Save result', saveTo: 'P-20', gold: true });
  dialogScreen('P-19L', 'Leave Guard Sheet', 'EXISTING', { sheet: true, icon: 'alert', title: 'Leave without saving?', body: 'Your result has not been saved yet.', primary: ['Save result', 'P-20'], secondary: ['Discard', 'P-11'] });

  stateScreen('P-20', 'Saved', 'EXISTING', { icon: 'check', title: 'Session saved', body: 'Great work. Your progress is up to date.', buttons: [['Back to home', 'P-11'], ['See my progress', 'P-23', 'secondary'], ['View session details', 'P-26', 'text'], ['Prototype: sync failed', 'P-22', 'text'], ['Prototype: loading home', 'P-11f', 'text']] });
  stateScreen('P-21', 'Camera Error', 'EXISTING', { icon: 'cameraOff', tone: 'warn', title: 'We lost tracking', body: 'Step back so your whole body is visible, and check the lighting.', buttons: [['Try again', 'P-16'], ['Exit session', 'P-11', 'secondary']] });
  stateScreen('P-22', 'Sync Error', 'EXISTING', { icon: 'cloudOff', tone: 'error', title: 'Could not sync', body: 'Your session is saved on this phone and will upload when you are online.', buttons: [['Try again', 'P-20'], ['Back to home', 'P-11', 'secondary']] });

  // ---------- Progress ----------
  s = Screen('P-23', 'Progress Dashboard', 'EXISTING', { nav: 'patient', active: 2, gap: 16 });
  s.add(heading('Progress', 'See how you are improving.'), seg(['Week', 'Month', 'All time'], 0), statRow([['Sessions', '5', '+2'], ['Avg score', '82', '+6']]), statRow([['Reps', '86', '+14'], ['Streak', '3 d']]),
    card([txt('Movement score', 'bodyStrong'), barChart([60, 72, 66, 80, 86, 84, 90])]), sectionTitle('By exercise'),
    listItem('Mini Squat', 'Best score 92', { icon: 'activity', right: '86', to: 'P-24' }), listItem('Straight-Leg Raise', 'Best score 88', { icon: 'activity', right: '79', to: 'P-24' }), btn('Session history', { v: 'secondary', to: 'P-25' }));
  s.finish();
  s = Screen('P-24', 'Exercise Progress', 'EXISTING', { app: { title: 'Mini Squat', back: 'P-23' }, gap: 16 });
  s.add(seg(['Week', 'Month', 'All time'], 1), statRow([['Best', '92'], ['Average', '84', '+5']]), card([txt('Score over time', 'bodyStrong'), barChart([70, 74, 80, 78, 86, 90, 92])]), sectionTitle('Recent sessions'),
    listItem('Today \u00B7 10:30 AM', '10 reps \u00B7 3:12', { chip: status('correct', '86'), to: 'P-26' }), listItem('Mon \u00B7 6:00 PM', '10 reps \u00B7 3:40', { chip: status('correct', '84'), to: 'P-26' }), btn('Retry exercise', { to: 'P-14' }));
  s.finish();
  s = Screen('P-25', 'Session History', 'EXISTING', { app: { title: 'Session history', back: 'P-23' }, gap: 12 });
  s.add(input('Search sessions', { icon: 'search', hint: 'Search by exercise' }), chips(['All', 'Knee Rehab', 'Shoulder', 'This week'], 0), overline('Today'), listItem('Mini Squat', 'Knee Rehabilitation \u00B7 10:30 AM \u00B7 3:12', { chip: status('correct', '86'), to: 'P-26' }), overline('Yesterday'),
    listItem('Heel Slide', 'Knee Rehabilitation \u00B7 6:10 PM \u00B7 2:50', { chip: status('incomplete', '64'), to: 'P-26' }), listItem('Straight-Leg Raise', 'Knee Rehabilitation \u00B7 9:00 AM \u00B7 2:20', { chip: status('correct', '79'), to: 'P-26' }), btn('Prototype: show empty state', { v: 'text', to: 'P-25E' }));
  s.finish();
  stateScreen('P-25E', 'Session History - empty', 'EXISTING', { app: { title: 'Session history', back: 'P-25' }, icon: 'clock', title: 'No sessions yet', body: 'Finish your first exercise and it will show up here.', buttons: [['Start an exercise', 'P-12']] });
  s = Screen('P-26', 'Session Details', 'CHANGED', { app: { title: 'Session details', back: 'BACK' }, action: { label: 'Retry exercise', to: 'P-14' }, gap: 14 });
  s.add(card([row([ring(86, 96), col([txt('Mini Squat', 'h3'), txt('Knee Rehabilitation \u00B7 Today at 10:30 AM', 'small', C.textSecondary), status('correct', '7 of 10 correct')], { gap: 4, grow: true })], { gap: 16 })]),
    card([row([avatar('SK', 40), col([txt('Doctor feedback', 'captionStrong', C.brandGreen), txt('Dr. Sara Khan', 'bodyStrong')], { gap: 0, grow: true })], { gap: 12 }), txt('Good control on the way down. Slow the way up a little. See you next week.', 'small', C.textPrimary)], { fill: C.brandMint, flat: true, name: 'DoctorFeedbackCard' }),
    sectionTitle('Rep by rep'), repRow(1, 'correct', 'Correct', '42\u00B0'), repRow(2, 'correct', 'Correct', '40\u00B0'), repRow(3, 'incomplete', 'Incomplete', '28\u00B0'), repRow(4, 'incorrect', 'Incorrect', '55\u00B0'));
  s.finish();

  // ---------- Profile ----------
  s = Screen('P-28', 'Profile', 'CHANGED', { nav: 'patient', active: 3, gap: 16 });
  s.add(card([row([avatar('AM', 64), col([txt('Alex Morgan', 'h3'), txt('alex@rehab.test', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('edit', 'P-29')], { gap: 12 })]),
    menu([{ icon: 'heart', title: 'My Doctor', sub: 'Dr. Sara Khan', to: 'P-46' }, { icon: 'clipboard', title: 'My Condition', sub: 'Right knee, 6 weeks', to: 'P-51' }]),
    menu([{ icon: 'settings', title: 'Settings', to: 'P-30' }, { icon: 'bell', title: 'Notifications', to: 'P-32' }, { icon: 'help', title: 'Help and FAQ', to: 'P-33' }, { icon: 'shield', title: 'Privacy and data', to: 'P-34' }, { icon: 'info', title: 'About', to: 'P-35' }]),
    menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'P-36' }]), btn('Connect with a doctor', { v: 'secondary', to: 'P-37' }));
  s.finish();
  s = Screen('P-29', 'Edit Profile', 'EXISTING', { app: { title: 'Edit profile', back: 'P-29D' }, action: { label: 'Save changes', to: 'P-28' }, gap: 14 });
  s.add(col([avatar('AM', 80)], { cross: 'CENTER' }), input('Display name', { icon: 'user', value: 'Alex Morgan' }), input('Email', { icon: 'mail', value: 'alex@rehab.test' }), overline('Age range'), chips(['Under 18', '18-29', '30-44', '45-64', '65+'], 2), overline('Main goal'), chips(['Knee recovery', 'Shoulder mobility', 'General'], 0));
  s.finish();
  dialogScreen('P-29D', 'Discard Changes Dialog', 'EXISTING', { icon: 'alert', title: 'Discard changes?', body: 'Your edits have not been saved.', primary: ['Discard', 'P-28'], secondary: ['Keep editing', 'BACK'], destructive: true });
  s = Screen('P-30', 'Settings', 'EXISTING', { app: { title: 'Settings', back: 'P-28' }, gap: 16 });
  s.add(menu([{ icon: 'lock', title: 'Change password', to: 'P-31' }, { icon: 'bell', title: 'Notification preferences', to: 'P-32' }, { icon: 'camera', title: 'Camera and audio', sub: 'Skeleton on \u00B7 Haptics on', to: 'P-10' }]));
  s.finish();
  s = Screen('P-31', 'Change Password', 'EXISTING', { app: { title: 'Change password', back: 'P-30' }, action: { label: 'Update password', to: 'P-30' }, gap: 14 });
  s.add(input('Current password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), input('New password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }), card([checkRow('8 or more characters', true), checkRow('At least 1 letter', true), checkRow('At least 1 number', true)], { gap: 8, flat: true, fill: C.brandMint }), input('Confirm new password', { icon: 'lock', value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022' }));
  s.finish();
  s = Screen('P-32', 'Notification Preferences', 'EXISTING', { app: { title: 'Notifications', back: 'P-28' }, action: { label: 'Save', to: 'P-28' }, gap: 14 });
  s.add(card([toggleRow('Exercise reminders', true), divider(), toggleRow('Doctor feedback', true), divider(), toggleRow('Weekly summary', true), divider(), toggleRow('Tips', false)], { gap: 12 }), input('Reminder time', { icon: 'clock', value: '9:00 AM' }), overline('Reminder days'), chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], [0, 2, 4]));
  s.finish();
  s = Screen('P-33', 'Help and FAQ', 'EXISTING', { app: { title: 'Help and FAQ', back: 'P-28' }, gap: 12 });
  s.add(faq('How do I place my phone?', 'Prop it at hip height about 2 metres away and follow the camera view shown.'), faq('Is my video saved?', 'No. Tracking runs on your phone and no video or images are stored.'), faq('What if the count looks wrong?', 'Check lighting and wear fitted clothing, then try again.'), faq('When should I stop?', 'Stop right away if you feel sharp pain, dizziness or chest tightness.'));
  s.finish();
  s = Screen('P-34', 'Privacy and Data', 'EXISTING', { app: { title: 'Privacy and data', back: 'P-28' }, gap: 14 });
  s.add(banner('info', 'Your camera is processed on this phone. No video or images are stored.'), menu([{ icon: 'file', title: 'Privacy policy' }, { icon: 'shield', title: 'Data we keep', sub: 'Profile, sessions, scores' }]), menu([{ icon: 'trash', title: 'Delete account', danger: true, to: 'P-34D' }]));
  s.finish();
  dialogScreen('P-34D', 'Delete Account Dialog', 'CHANGED', { icon: 'trash', title: 'Delete your account?', body: 'Your account will be disabled and you will be logged out. Contact support to restore it.', primary: ['Delete account', 'P-02'], secondary: ['Cancel', 'BACK'], destructive: true });
  s = Screen('P-35', 'About', 'EXISTING', { app: { title: 'About', back: 'P-28' }, gap: 16 });
  s.add(col([iconCircle('activity', 96), txt('RehabSense', 'h1', C.brandGreen, { align: 'CENTER' }), txt('Version 2.0', 'small', C.textSecondary, { align: 'CENTER' })], { gap: 8, cross: 'CENTER' }), infoBox('RehabSense is a guidance tool and not a medical device. It does not replace professional medical advice.'), menu([{ icon: 'file', title: 'Terms of use' }, { icon: 'shield', title: 'Privacy policy' }]));
  s.finish();
  dialogScreen('P-36', 'Logout Dialog', 'EXISTING', { icon: 'logout', title: 'Log out?', body: 'Unsynced sessions stay on your phone and upload next time.', primary: ['Log out', 'P-02'], secondary: ['Cancel', 'BACK'] });

  // ---------- NEW: connect with doctor ----------
  GROUP = 'PATIENT - New (Connect with a doctor and Prescribed)';
  s = Screen('P-37', 'Connect Hub', 'NEW', { app: { title: 'Connect with a doctor', back: 'P-28' }, action: { label: 'Start', to: 'P-38' }, gap: 16 });
  s.add(heading('Get a plan made for you', 'Share your condition, pick a doctor and send a request.'), bullet('clipboard', '1. Tell us about your condition', 'Three short steps.'), bullet('users', '2. Choose a doctor', 'Matched to your needs.'), bullet('check', '3. Send a request', 'The doctor accepts and assigns exercises.'), infoBox('Only the doctor you request can see your condition. Doctors never see your camera.'));
  s.finish();
  wizard('P-38', 'Condition Form', 'NEW', {
    title: 'Your condition', back: 'P-37', finish: 'Find doctors', done: 'P-40', steps: [
      { title: 'Body area', head: 'Where does it hurt?', sub: 'Pick the main area.', build: function (s) { s.add(chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'], 0), overline('How long?'), chips(['Under 2 weeks', '2-6 weeks', '6 weeks+'], 1), input('Diagnosis, if you know it', { hint: 'For example ACL repair' })); } },
      { title: 'Symptoms', head: 'Current pain', sub: 'Be honest. This helps your doctor.', build: function (s) { s.add(slider(4), overline('Do you have any of these?'), card([checkRow('Numbness or tingling', false), checkRow('Fever or swelling with heat', false), checkRow('Pain that wakes you at night', false), checkRow('Recent fall or accident', false)], { gap: 12 }), btn('Prototype: I have a red flag symptom', { v: 'text', size: 'M', to: 'P-39' })); } },
      { title: 'Goals', head: 'What do you want to achieve?', sub: 'Optional notes for your doctor.', build: function (s) { s.add(chips(['Walk without pain', 'Return to sport', 'Daily activities', 'After surgery'], [0]), area('Notes for your doctor', 'Right knee after ACL surgery 6 weeks ago.', 120)); } }]
  });
  dialogScreen('P-39', 'Safety Alert (sheet)', 'NEW', { sheet: true, icon: 'alert', destructive: true, title: 'Please see a doctor first', body: 'Some of your symptoms need medical attention before exercise. Contact a doctor or emergency services.', primary: ['I understand, continue', 'P-40'], secondary: ['Go back', 'BACK'] });
  s = Screen('P-40', 'Find Doctors', 'NEW', { app: { title: 'Find doctors', back: 'P-37' }, gap: 12 });
  s.add(chips(['Best match', 'Knee', 'Female doctor', 'Online'], 0), doctorCard('Dr. Sara Khan', 'Physiotherapist \u00B7 8 yrs', ['Knee', 'Post-surgery'], '96% match', 'P-41'), doctorCard('Dr. Omar Sheikh', 'Sports physio \u00B7 5 yrs', ['Knee', 'Sports'], '88% match', 'P-41'), doctorCard('Dr. Hina Malik', 'Orthopedic rehab \u00B7 11 yrs', ['Shoulder', 'Hip'], '71% match', 'P-41'));
  s.finish();
  s = Screen('P-41', 'Doctor Public Profile', 'NEW', { app: { title: 'Doctor profile', back: 'P-40' }, action: { label: 'Request this doctor', to: 'P-42' }, gap: 14 });
  s.add(col([avatar('SK', 96), txt('Dr. Sara Khan', 'h1', C.brandGreen, { align: 'CENTER' }), txt('Physiotherapist \u00B7 8 years', 'small', C.textSecondary, { align: 'CENTER' }), status('correct', 'Accepting patients')], { gap: 6, cross: 'CENTER' }),
    card([kv('Clinic', 'City Rehab Clinic'), kv('Languages', 'English, Urdu'), kv('City', 'Karachi')], { gap: 10 }), sectionTitle('Expertise'), chips(['Knee', 'Post-surgery', 'Sports injury'], [0, 1]), sectionTitle('About'), txt('I help patients return to daily life after knee surgery using clear, gradual plans.', 'small', C.textSecondary), sectionTitle('Approach'), txt('Small steps, honest feedback, and regular check-ins.', 'small', C.textSecondary));
  s.finish();
  s = Screen('P-42', 'Send Request (consent)', 'NEW', { app: { title: 'Send request', back: 'P-41' }, action: { label: 'Send request', to: 'P-43' }, gap: 14 });
  s.add(heading('Send to Dr. Sara Khan', 'She will see this summary of your condition.'), card([kv('Area', 'Right knee'), kv('Duration', '2-6 weeks'), kv('Pain now', '4 / 10'), kv('Goal', 'Walk without pain')], { gap: 10 }), area('Message (optional)', 'Hello doctor, I would like help after my surgery.', 96),
    card([checkRow('I agree to share my condition summary with this doctor. I can disconnect any time.', true)], { fill: C.brandMint, flat: true }));
  s.finish();
  s = Screen('P-43', 'Request Status', 'NEW', { app: { title: 'Request status', back: 'P-11b' }, gap: 16 });
  s.add(card([row([avatar('SK', 48), col([txt('Dr. Sara Khan', 'bodyStrong'), txt('Sent just now \u00B7 expires in 7 days', 'caption', C.textSecondary)], { gap: 0, grow: true }), status('pending', 'Pending')], { gap: 12 })]),
    timeline([['Request sent', 'Today, 10:42 AM', true], ['Doctor reviews', 'Usually within 2 days', false], ['Connected', 'You get a notification', false]]),
    btn('Back to home', { to: 'P-11b' }), btn('Cancel request', { v: 'destructiveOutline', to: 'P-11' }), overline('Prototype shortcuts'), btn('Doctor accepted', { v: 'text', size: 'M', to: 'P-44' }), btn('Doctor declined', { v: 'text', size: 'M', to: 'P-45' }), btn('Doctor assigned exercises', { v: 'text', size: 'M', to: 'P-11d' }), btn('Doctor became inactive', { v: 'text', size: 'M', to: 'P-11e' }));
  s.finish();
  stateScreen('P-44', 'Connected (celebration)', 'NEW', { icon: 'heart', title: 'You are connected!', body: 'Dr. Sara Khan accepted your request. Exercises will show up under Prescribed.', buttons: [['Go to home', 'P-11c'], ['See my doctor', 'P-46', 'secondary']], pad: 100 });
  stateScreen('P-45', 'Request Declined or Expired', 'NEW', { app: { title: '', back: 'P-11' }, icon: 'x', tone: 'warn', title: 'Request not accepted', body: 'Dr. Sara Khan could not take your request. You can choose another doctor.', buttons: [['Find another doctor', 'P-40'], ['Back to home', 'P-11', 'secondary']] });
  s = Screen('P-46', 'My Doctor', 'NEW', { app: { title: 'My doctor', back: 'P-28' }, gap: 14 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Connected')], { gap: 4, grow: true })], { gap: 12 })]),
    menu([{ icon: 'clipboard', title: 'Prescribed exercises', sub: '2 assigned', to: 'P-48' }, { icon: 'heart', title: 'Doctor profile', to: 'P-41' }]), btn('Disconnect from doctor', { v: 'destructiveOutline', to: 'P-47' }));
  s.finish();
  dialogScreen('P-47', 'Disconnect Confirm', 'NEW', { icon: 'alert', destructive: true, title: 'Disconnect from Dr. Sara Khan?', body: 'Your doctor will no longer see your sessions. Prescribed exercises will be locked.', primary: ['Disconnect', 'P-11'], secondary: ['Stay connected', 'BACK'] });
  s = Screen('P-48', 'Prescribed List', 'NEW', { app: { title: 'Prescribed', back: 'P-12' }, gap: 12 });
  s.add(seg(['Wellness and Yoga', 'Rehab', 'Prescribed'], 2, coursesTabs), card([row([avatar('SK', 40), txt('From Dr. Sara Khan', 'smallStrong', C.brandGreen)], { gap: 12 })], { fill: C.brandMint, flat: true }),
    listItem('Mini Squat', '3 sets \u00B7 10 reps \u00B7 Mon, Wed, Fri', { icon: 'activity', chip: status('pending', 'Today'), to: 'P-49' }), listItem('Straight-Leg Raise', '2 sets \u00B7 12 reps \u00B7 Tue, Thu', { icon: 'activity', to: 'P-49' }), listItem('Wall Sit hold', '3 holds \u00B7 30 s \u00B7 Mon, Fri', { icon: 'activity', to: 'P-49' }));
  s.finish();
  s = Screen('P-49', 'Prescribed Exercise Detail', 'NEW', { app: { title: 'Mini Squat', back: 'P-48' }, action: { label: 'Start exercise', to: 'P-15' }, gap: 14 });
  s.add(card([txt('Doctor\u2019s note', 'captionStrong', C.brandGreen), txt('Go slowly and stop if pain goes above 5. Rest 45 seconds between sets.', 'small', C.textPrimary)], { fill: C.brandMint, flat: true }), card([kv('Sets and reps', '3 x 10'), kv('Rest', '45 seconds'), kv('Days', 'Mon, Wed, Fri'), kv('Camera view', 'Side'), kv('Ends', '30 Nov')], { gap: 10 }), sectionTitle('How to do it'), card([checkRow('Stand with feet shoulder-width apart', false), checkRow('Bend knees slowly to about 30 degrees', false), checkRow('Rise slowly', false)], { gap: 10 }));
  s.finish();
  s = Screen('P-50', 'Enter Doctor Code (optional)', 'NEW', { app: { title: 'Doctor code', back: 'P-37' }, action: { label: 'Connect', to: 'P-43' }, gap: 16 });
  s.add(heading('Have a doctor code?', 'Optional. Hidden until invite codes are approved (D-07).'), otp('RS48'), banner('info', 'Codes come from your doctor.'));
  s.finish();
  s = Screen('P-51', 'My Condition', 'NEW', { app: { title: 'My condition', back: 'P-28' }, action: { label: 'Save', to: 'P-28' }, gap: 14 });
  s.add(overline('Body area'), chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck'], 0), input('Diagnosis', { value: 'ACL repair, right knee' }), overline('Pain now'), slider(4), area('Notes', 'Right knee after ACL surgery 6 weeks ago.', 96), infoBox('Only your connected doctor can see this.'));
  s.finish();
  stateScreen('P-52', 'Inactive Account', 'NEW', { icon: 'ban', tone: 'warn', title: 'Account inactive', body: 'Your account is disabled. Please contact support to restore it.', buttons: [['Log out', 'P-02'], ['Contact support', 'P-33', 'secondary']] });
}

// ---- patient-specific helpers ----
function rectSpacer(h) { const r = figma.createRectangle(); r.resize(10, h); r.fills = []; r.name = 'spacer'; return r; }
function skel(h, r) { const b = figma.createRectangle(); b.resize(328, h); b.cornerRadius = r || 12; b.fills = [paint(C.surfaceCeramic)]; b.name = 'Skeleton'; flag(b, { st: true }); return b; }
function courseCard(name, meta, desc, v, to) {
  return card([row([iconCircle('activity', 48), col([txt(name, 'h3'), txt(meta, 'caption', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 }), txt(desc, 'small', C.textSecondary), bar(v), btn(v > 0 ? 'Continue course' : 'Start course', { size: 'M', to: to })], { to: to, name: 'CourseCard/' + name });
}
function repRow(n, type, label, angle) { return card([row([txt('Rep ' + n, 'bodyStrong'), status(type, label), txt('Knee ' + angle, 'small', C.textSecondary, { align: 'RIGHT' })], { main: 'SPACE_BETWEEN', gap: 12 })], { pad: [12, 16, 12, 16] }); }
function toggleRow(label, on) {
  const t = mk('Toggle', { dir: 'H', cross: 'CENTER', w: 48, h: 28, r: R.pill, fill: on ? C.brandAction : C.borderInput, pad: [3, 3, 3, 3], main: on ? 'MAX' : 'MIN' });
  A(t, circle(22, C.surfaceCard, 'knob')); return row([txt(label, 'body'), t], { main: 'SPACE_BETWEEN' });
}
function faq(q, a) { return card([row([txt(q, 'bodyStrong'), icon('plus', 20, C.brandAction)], { main: 'SPACE_BETWEEN', gap: 12 }), txt(a, 'small', C.textSecondary)], { gap: 8 }); }
function barChart(vals) {
  const f = mk('BarChart', { dir: 'H', gap: 10, cross: 'MAX', h: 120, pad: [8, 0, 0, 0], main: 'SPACE_BETWEEN' }); flag(f, { st: true });
  vals.forEach(function (v, i) { const b = figma.createRectangle(); b.resize(28, Math.round(v * 1.1)); b.cornerRadius = 6; b.fills = [paint(i === vals.length - 1 ? C.brandAction : C.brandMint)]; b.name = 'bar ' + v; A(f, b); });
  return f;
}
