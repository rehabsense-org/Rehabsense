// DOCTOR PORTAL - all screens NEW (UPDATE_BRIEF section 5)
function buildDoctor() {
  GROUP = 'DOCTOR PORTAL';
  let s;
  const dots = '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022';

  // ---------- Gate and onboarding ----------
  s = Screen('D-01', 'Doctor Login', 'NEW', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(heading('Doctor login', 'Sign in to manage your patients.'), input('Email', { icon: 'mail', value: 'sara.khan@clinic.test' }), input('Password', { icon: 'lock', value: dots, suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'D-10', full: false }), btn('Log in', { to: 'D-14' }), btn('Create doctor account', { v: 'secondary', to: 'D-02' }),
    overline('Prototype: login gate results'), btn('Pending application', { v: 'text', size: 'M', to: 'D-06' }), btn('Incomplete application', { v: 'text', size: 'M', to: 'D-07' }),
    btn('Rejected application', { v: 'text', size: 'M', to: 'D-08' }), btn('Inactive account', { v: 'text', size: 'M', to: 'D-09' }), btn('Approved, profile not set up', { v: 'text', size: 'M', to: 'D-12' }));
  s.finish();

  s = Screen('D-02', 'Register Account', 'NEW', { app: { title: '', back: 'D-01' }, gap: 14 });
  s.add(heading('Create doctor account', 'Step 1 of 3. Your application is reviewed by our team.'), input('Full name', { icon: 'user', value: 'Sara Khan' }), input('Work email', { icon: 'mail', value: 'sara.khan@clinic.test' }), input('Licence number', { icon: 'file', value: 'PMDC-48213' }), input('Degree', { value: 'DPT, Physiotherapy' }),
    input('Password', { icon: 'lock', value: dots, suffix: 'eye', helper: '8 or more characters, with a letter and a number.' }), banner('info', 'You can submit up to 3 applications.'), btn('Create account', { to: 'D-03' }));
  s.finish();
  s = Screen('D-03', 'Verify Email (OTP)', 'NEW', { app: { title: '', back: 'D-02' }, gap: 20 });
  s.add(col([iconCircle('mail', 80), txt('Enter your code', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We sent a 6-digit code to sara.khan@clinic.test', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 12, cross: 'CENTER' }), otp('7391'), btn('Verify', { to: 'D-04' }), btn('Resend code (60s)', { v: 'text', to: 'D-03' }), btn('Change email', { v: 'text', to: 'D-02' }));
  s.finish();
  s = Screen('D-04', 'Documents', 'NEW', { app: { title: 'Documents', back: 'D-03' }, action: { label: 'Continue', to: 'D-05' }, gap: 12 });
  s.add(stepHeader(2, 3, 'Documents'), heading('Upload your documents', 'PDF, JPG or PNG. Up to 5 MB each.'), docTile('Medical licence', 'licence.pdf \u00B7 1.2 MB', true), docTile('Degree certificate', 'degree.jpg \u00B7 2.4 MB', true), docTile('National ID', 'Tap to upload', false), banner('info', 'Documents are private. Only our review team can open them.'));
  s.finish();
  s = Screen('D-05', 'Review and Submit', 'NEW', { app: { title: 'Review', back: 'D-04' }, action: { label: 'Submit application', to: 'D-06' }, gap: 14 });
  s.add(stepHeader(3, 3, 'Review'), card([kv('Name', 'Sara Khan'), kv('Email', 'sara.khan@clinic.test'), kv('Licence', 'PMDC-48213'), kv('Degree', 'DPT, Physiotherapy'), kv('Attempt', '1 of 3')], { gap: 10 }), docTile('Medical licence', 'licence.pdf', true), docTile('Degree certificate', 'degree.jpg', true), docTile('National ID', 'id.png', true), btn('Edit documents', { v: 'text', to: 'D-04' }));
  s.finish();
  s = Screen('D-06', 'Submitted', 'NEW', { gap: 16 });
  s.add(rectSpacer(48), col([iconCircle('clock', 96), txt('Application submitted', 'h1', C.brandGreen, { align: 'CENTER' }), txt('We will email you after review. This usually takes 1 to 3 days.', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }),
    timeline([['Submitted', 'Today', true], ['Under review', 'In progress', false], ['Decision by email', 'Soon', false]]), btn('Back to login', { to: 'D-01' }), btn('Prototype: approved', { v: 'text', size: 'M', to: 'D-12' }));
  s.finish();
  s = Screen('D-07', 'Resume Application', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(rectSpacer(24), col([iconCircle('file', 96), txt('Finish your application', 'h1', C.brandGreen, { align: 'CENTER' }), txt('You have not submitted your documents yet.', 'body', C.textSecondary, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }), bar(0.66), btn('Continue', { to: 'D-04' }));
  s.finish();
  s = Screen('D-08', 'Application Rejected', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(col([iconCircle('x', 96, C.errorTint, C.error), txt('Application not approved', 'h1', C.brandGreen, { align: 'CENTER' })], { gap: 14, cross: 'CENTER' }), card([txt('Reason', 'captionStrong', C.error), txt('The licence photo is not readable. Please upload a clearer copy.', 'small')], { fill: C.errorTint, flat: true }), kv('Attempts used', '1 of 3'), btn('Edit and resubmit', { to: 'D-04' }), btn('Back to login', { v: 'text', to: 'D-01' }));
  s.finish();
  stateScreen('D-09', 'Inactive Account', 'NEW', { app: { title: '', back: 'D-01' }, icon: 'ban', tone: 'warn', title: 'Account inactive', body: 'Your account is suspended. Please contact support.', buttons: [['Back to login', 'D-01'], ['Contact support', 'D-29', 'secondary']] });
  s = Screen('D-10', 'Forgot Password', 'NEW', { app: { title: '', back: 'D-01' }, gap: 16 });
  s.add(heading('Forgot password?', 'We will send a reset link.'), input('Email', { icon: 'mail', value: 'sara.khan@clinic.test' }), btn('Send reset link', { to: 'D-11' }), btn('Back to login', { v: 'text', to: 'D-01' }));
  s.finish();
  s = Screen('D-11', 'Reset Password', 'NEW', { app: { title: '', close: true, back: 'D-01' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: dots, suffix: 'eye' }), input('Confirm password', { icon: 'lock', value: dots }), btn('Update password', { to: 'D-01' }));
  s.finish();

  // ---------- Profile setup ----------
  wizard('D-12', 'Profile Setup', 'NEW', {
    title: 'Set up your profile', back: 'D-01', finish: 'Preview', done: 'D-13', steps: [
      { title: 'Basics', head: 'The basics', sub: 'Patients see this on your profile.', build: function (s) { s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), input('Phone', { value: '+92 300 0000000' }), input('City', { value: 'Karachi' }), input('Languages', { value: 'English, Urdu' })); } },
      { title: 'Expertise', head: 'Your expertise', sub: 'Pick at least 1 tag.', build: function (s) { s.add(chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Ankle', 'Neck', 'Post-surgery', 'Sports injury'], [0, 6]), input('Years of experience', { value: '8' })); } },
      { title: 'About', head: 'About you', sub: 'At least 30 characters.', build: function (s) { s.add(area('Bio', 'I help patients return to daily life after knee surgery with clear, gradual plans.', 120), area('Your approach', 'Small steps, honest feedback and regular check-ins.', 96), txt('78 / 500', 'caption', C.textSecondary, { align: 'RIGHT' })); } },
      { title: 'Availability', head: 'Availability', sub: 'You can change this any time.', build: function (s) { s.add(card([toggleRow('Accepting new patients', true)]), input('Max patients', { value: '30' }), overline('Working days'), chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], [0, 1, 2, 3, 4])); } }]
  });
  s = Screen('D-13', 'Preview and Go Live', 'NEW', { app: { title: 'Preview', back: 'D-12d' }, action: [{ label: 'Edit', v: 'secondary', to: 'D-12' }, { label: 'Go live', to: 'D-14' }], gap: 14 });
  s.add(banner('info', 'This is how patients will see your profile.'), card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 8 yrs', 'small', C.textSecondary), status('correct', 'Accepting patients')], { gap: 4, grow: true })], { gap: 12 }), chips(['Knee', 'Post-surgery']), txt('I help patients return to daily life after knee surgery.', 'small', C.textSecondary)]),
    card([txt('Listing checklist', 'bodyStrong'), checkRow('Approved by admin', true), checkRow('At least 1 expertise tag', true), checkRow('Bio of 30+ characters', true), checkRow('Clinic added', true), checkRow('Accepting patients', true)], { gap: 10 }));
  s.finish();

  // ---------- Main ----------
  s = Screen('D-14', 'Home', 'NEW', { nav: 'doctor', active: 0, gap: 16 });
  s.add(row([col([txt('Good morning, Dr. Khan', 'h3'), txt('Here is what needs you today.', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'D-25')], { gap: 4 }),
    statRow([['New requests', '3'], ['Active patients', '12']]), statRow([['Pain alerts', '1', null, false], ['Inactive 3d+', '2']]),
    card([row([iconCircle('alert', 40, C.errorTint, C.error), col([txt('Pain alert', 'bodyStrong'), txt('Ali R. reported pain 8 after Mini Squat', 'small', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { stroke: C.error, to: 'D-23' }),
    sectionTitle('New requests', 'See all', 'D-15'), listItem('Alex Morgan', 'Right knee \u00B7 after surgery', { avatar: 'AM', chip: status('pending', 'New'), to: 'D-16' }), listItem('Hira Aslam', 'Shoulder \u00B7 6 weeks', { avatar: 'HA', chip: status('pending', 'New'), to: 'D-16' }),
    sectionTitle('Recent sessions'), listItem('Ali R. \u00B7 Mini Squat', 'Today \u00B7 score 78', { avatar: 'AR', to: 'D-23' }));
  s.finish();
  s = Screen('D-15', 'Requests', 'NEW', { nav: 'doctor', active: 1, gap: 12 });
  s.add(heading('Requests', '3 waiting for your answer.'), seg(['Pending', 'Accepted', 'Declined'], 0), listItem('Alex Morgan', 'Right knee \u00B7 expires in 6 d', { avatar: 'AM', chip: status('pending', 'Pending'), to: 'D-16' }), listItem('Hira Aslam', 'Shoulder \u00B7 expires in 4 d', { avatar: 'HA', chip: status('pending', 'Pending'), to: 'D-16' }), listItem('Bilal Noor', 'Hip \u00B7 expires in 1 d', { avatar: 'BN', chip: status('incomplete', '1 d left'), to: 'D-16' }), btn('View my patients', { v: 'text', to: 'D-17' }));
  s.finish();
  s = Screen('D-16', 'Request Detail', 'NEW', { app: { title: 'Request', back: 'D-15' }, action: [{ label: 'Decline', v: 'secondary', to: 'D-16D' }, { label: 'Accept', to: 'D-18' }], gap: 14 });
  s.add(card([row([avatar('AM', 56), col([txt('Alex Morgan', 'h3'), txt('Request sent today \u00B7 expires in 7 d', 'caption', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 })]), sectionTitle('Condition summary'),
    card([kv('Area', 'Right knee'), kv('Duration', '2-6 weeks'), kv('Pain now', '4 / 10'), kv('Goal', 'Walk without pain'), kv('Red flags', 'None reported')], { gap: 10 }), area('Message from patient', 'Hello doctor, I would like help after my surgery.', 80), infoBox('Condition details are visible to you only while this request is pending or accepted.'));
  s.finish();
  dialogScreen('D-16D', 'Decline Request', 'NEW', { sheet: true, icon: 'x', destructive: true, title: 'Decline this request?', body: 'The patient will be told and can choose another doctor.', extra: [chips(['Not my specialty', 'No capacity', 'Other'], 0)], primary: ['Decline request', 'D-15'], secondary: ['Cancel', 'BACK'] });
  s = Screen('D-17', 'My Patients', 'NEW', { nav: 'doctor', active: 1, gap: 12 });
  s.add(heading('My patients', '12 active'), input('Search patients', { icon: 'search', hint: 'Search by name' }), chips(['All', 'Active today', 'Needs attention'], 0), listItem('Alex Morgan', 'Right knee \u00B7 last session today', { avatar: 'AM', chip: status('correct', 'On track'), to: 'D-18' }), listItem('Ali Raza', 'Left knee \u00B7 pain 8 reported', { avatar: 'AR', chip: status('incorrect', 'Pain'), to: 'D-18' }), listItem('Sana Iqbal', 'Shoulder \u00B7 no session for 3 d', { avatar: 'SI', chip: status('incomplete', 'Inactive'), to: 'D-18' }), btn('Requests', { v: 'text', to: 'D-15' }));
  s.finish();

  const patientTabs = ['D-18', 'D-18b', 'D-18c', 'D-18d'];
  const pHead = function (s, active) { s.add(card([row([avatar('AM', 56), col([txt('Alex Morgan', 'h3'), txt('Right knee \u00B7 connected 3 weeks', 'caption', C.textSecondary)], { gap: 0, grow: true }), status('correct', 'Active')], { gap: 12 })]), seg(['Overview', 'Plan', 'Sessions', 'Condition'], active, patientTabs)); };
  s = Screen('D-18', 'Patient Detail - Overview', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 14 }); pHead(s, 0);
  s.add(statRow([['Adherence', '86%', '+8%'], ['Avg score', '82', '+4']]), statRow([['Sessions', '9'], ['Avg pain', '3.1']]), card([txt('Score trend', 'bodyStrong'), barChart([60, 72, 66, 80, 86, 84, 90])]), btn('Assign exercise', { to: 'D-19' })); s.finish();
  s = Screen('D-18b', 'Patient Detail - Plan', 'NEW', { app: { title: 'Patient', back: 'D-17' }, action: { label: 'Assign exercise', to: 'D-19' }, gap: 12 }); pHead(s, 1);
  s.add(listItem('Mini Squat', '3 x 10 \u00B7 Mon, Wed, Fri', { icon: 'activity', chip: status('correct', 'Active') }), listItem('Straight-Leg Raise', '2 x 12 \u00B7 Tue, Thu', { icon: 'activity', chip: status('correct', 'Active') }), listItem('Wall Sit hold', '3 x 30 s \u00B7 Mon, Fri', { icon: 'activity', chip: status('neutral', 'Ended') })); s.finish();
  s = Screen('D-18c', 'Patient Detail - Sessions', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 12 }); pHead(s, 2);
  s.add(listItem('Mini Squat', 'Today \u00B7 pain 3 \u00B7 score 86', { chip: status('correct', 'Reviewed'), to: 'D-23' }), listItem('Straight-Leg Raise', 'Yesterday \u00B7 pain 2 \u00B7 score 79', { chip: status('pending', 'Needs feedback'), to: 'D-23' }), listItem('Mini Squat', 'Mon \u00B7 pain 8 \u00B7 score 64', { chip: status('incorrect', 'Pain'), to: 'D-23' })); s.finish();
  s = Screen('D-18d', 'Patient Detail - Condition', 'NEW', { app: { title: 'Patient', back: 'D-17' }, gap: 12 }); pHead(s, 3);
  s.add(card([kv('Area', 'Right knee'), kv('Diagnosis', 'ACL repair'), kv('Duration', '6 weeks'), kv('Pain at start', '4 / 10'), kv('Goal', 'Walk without pain')], { gap: 10 }), area('Patient notes', 'Right knee after ACL surgery 6 weeks ago.', 80), btn('End connection', { v: 'destructiveOutline', to: 'D-17' })); s.finish();

  wizard('D-19', 'Assign Exercise', 'NEW', {
    title: 'Assign exercise', back: 'D-18b', finish: 'Assign', done: 'D-18b', steps: [
      { title: 'Choose', head: 'Choose an exercise', sub: 'From the library.', build: function (s) { s.add(input('Search', { icon: 'search', hint: 'Search exercises' }), listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 side view', { icon: 'activity', chip: status('correct', 'Tested') }), listItem('Straight-Leg Raise', 'Rehab \u00B7 rep \u00B7 side view', { icon: 'activity', chip: status('correct', 'Tested') }), listItem('Wall Sit hold', 'Rehab \u00B7 hold \u00B7 side view', { icon: 'activity', chip: status('pending', 'Untested') })); } },
      { title: 'Dose', head: 'Sets and reps', sub: 'How much, and how often.', build: function (s) { s.add(input('Sets', { value: '3' }), input('Reps', { value: '10' }), input('Rest (seconds)', { value: '45' })); } },
      { title: 'Schedule', head: 'Schedule', sub: 'Pick days and dates.', build: function (s) { s.add(chips(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], [0, 2, 4]), input('Start date', { icon: 'calendar', value: '3 Nov 2026' }), input('End date', { icon: 'calendar', value: '30 Nov 2026' }), area('Note to patient', 'Go slowly and stop if pain goes above 5.', 80)); } }]
  });

  s = Screen('D-20', 'Exercise Library', 'NEW', { nav: 'doctor', active: 2, gap: 12 });
  s.add(row([txt('Exercises', 'h1', C.brandGreen), btn('New', { v: 'primary', size: 'M', icon: 'plus', to: 'D-21', full: false })], { main: 'SPACE_BETWEEN' }), input('Search', { icon: 'search', hint: 'Search exercises' }), chips(['All', 'Rehab', 'Yoga', 'Mine'], 0),
    listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 side', { icon: 'activity', chip: status('correct', 'Tested'), to: 'D-22' }), listItem('Wall Sit hold', 'Rehab \u00B7 hold \u00B7 side \u00B7 Private', { icon: 'activity', chip: status('pending', 'Untested'), to: 'D-22' }), listItem('Warrior II hold', 'Yoga \u00B7 hold \u00B7 front', { icon: 'activity', chip: status('correct', 'Tested'), to: 'D-22' }));
  s.finish();
  wizard('D-21', 'Exercise Builder', 'NEW', {
    title: 'New exercise', back: 'D-20', finish: 'Save exercise', done: 'D-20', steps: [
      { title: 'Basics', head: 'Basics', sub: 'Name and category. Doctor exercises are always private.', build: function (s) { s.add(input('Name', { value: 'Wall Sit' }), overline('Category'), chips(['Rehab', 'Yoga', 'General'], 0), area('Steps for the patient', 'Lean against a wall and slide down until knees are bent.', 96), banner('info', 'Visibility: Private. Only you and assigned patients can see it.')); } },
      { title: 'Camera and kind', head: 'Camera and kind', sub: 'How the patient will be tracked.', build: function (s) { s.add(overline('Type'), seg(['Rep', 'Hold'], 1), overline('Camera view'), seg(['Side', 'Front'], 0), banner('info', 'Tracking uses 2D angles only. No video or images are stored.')); } },
      { title: 'Tracking config', head: 'Tracking config', sub: 'Angle range and hold time.', build: function (s) { s.add(input('Joint', { value: 'Right knee' }), input('Angle range (degrees)', { value: '80 to 100' }), input('Hold time (seconds)', { value: '30' }), input('Grace period (seconds)', { value: '2' }), btn('Test on camera', { v: 'secondary', to: 'D-22' })); } },
      { title: 'Review', head: 'Review', sub: 'Check everything before saving.', build: function (s) { s.add(card([kv('Name', 'Wall Sit'), kv('Category', 'Rehab'), kv('Type', 'Hold'), kv('Camera', 'Side'), kv('Range', '80 to 100\u00B0'), kv('Hold', '30 s'), kv('Visibility', 'Private')], { gap: 10 }), status('pending', 'Untested - run a test on camera')); } }]
  });
  s = Screen('D-22', 'Test Exercise on Camera', 'NEW', { camera: true });
  skeleton(s, { color: '#FFFFFF' }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'x', 8, 32, 'D-20'); pill(s, 'TEST MODE \u00B7 nothing is saved', 60, 40, 240);
  const tc = mk('Counter', { dir: 'V', cross: 'CENTER', w: 360 }); A(tc, txt('0:22', 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt('Hold 30 s \u00B7 Wall Sit', 'bodyStrong', C.textOnDarkSoft, { hug: true })); s.abs(tc, 0, 96);
  pill(s, 'Angle in range: 92\u00B0', 60, 560, 240);
  const td = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 }); A(td, btn('Mark as tested', { v: 'onDarkFilled', size: 'M', to: 'D-20' }), btn('Back to builder', { v: 'onDarkOutline', size: 'M', to: 'D-21c' })); s.abs(td, 0, 800 - td.height); s.finish();

  s = Screen('D-23', 'Session Review and Feedback', 'NEW', { app: { title: 'Session review', back: 'D-18c' }, action: { label: 'Send feedback', to: 'D-18c' }, gap: 14 });
  s.add(card([row([ring(78, 96), col([txt('Mini Squat', 'h3'), txt('Ali Raza \u00B7 Today 10:30 AM', 'small', C.textSecondary), status('incorrect', 'Pain 8')], { gap: 4, grow: true })], { gap: 16 })]),
    banner('error', 'Patient reported pain 8 of 10: "Sharp pain on the last reps".'), statRow([['Reps', '10'], ['Correct', '6']]), sectionTitle('Rep by rep'), repRow(1, 'correct', 'Correct', '42\u00B0'), repRow(2, 'incomplete', 'Incomplete', '28\u00B0'), repRow(3, 'incorrect', 'Incorrect', '55\u00B0'),
    area('Your feedback', 'Thanks for reporting this. Please pause squats and call the clinic.', 96), txt('72 / 500', 'caption', C.textSecondary, { align: 'RIGHT' }));
  s.finish();

  s = Screen('D-25', 'Notifications', 'NEW', { app: { title: 'Notifications', back: 'D-14' }, gap: 12 });
  s.add(listItem('New request', 'Alex Morgan wants to connect \u00B7 5 min ago', { icon: 'users', to: 'D-16' }), listItem('Pain alert', 'Ali Raza reported pain 8 \u00B7 1 h ago', { icon: 'alert', to: 'D-23' }), listItem('Request expiring', 'Bilal Noor\u2019s request expires in 24 h', { icon: 'clock', to: 'D-16' }), listItem('Patient inactive', 'Sana Iqbal has not trained for 3 days', { icon: 'bell', to: 'D-18' }), listItem('Application approved', 'You are now listed for patients', { icon: 'check', to: 'D-14' }));
  s.finish();
  s = Screen('D-26', 'Profile', 'NEW', { nav: 'doctor', active: 3, gap: 16 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Listed')], { gap: 4, grow: true })], { gap: 12 })]),
    menu([{ icon: 'edit', title: 'Edit profile and expertise', to: 'D-27' }, { icon: 'file', title: 'Update credentials', to: 'D-28' }, { icon: 'settings', title: 'Settings', to: 'D-29' }, { icon: 'bell', title: 'Notifications', to: 'D-25' }]), menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'D-30' }]));
  s.finish();
  s = Screen('D-27', 'Edit Profile and Expertise', 'NEW', { app: { title: 'Edit profile', back: 'D-26' }, action: { label: 'Save changes', to: 'D-26' }, gap: 14 });
  s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), overline('Expertise'), chips(['Knee', 'Shoulder', 'Hip', 'Back', 'Post-surgery'], [0, 4]), area('Bio', 'I help patients return to daily life after knee surgery.', 96), card([toggleRow('Accepting new patients', true)]), input('Max patients', { value: '30' }));
  s.finish();
  s = Screen('D-28', 'Update Credentials', 'NEW', { app: { title: 'Credentials', back: 'D-26' }, action: { label: 'Submit for review', to: 'D-26' }, gap: 14 });
  s.add(banner('info', 'Changing credentials sends your profile back to review. You stay listed until a decision.'), input('Licence number', { value: 'PMDC-48213' }), input('Degree', { value: 'DPT, Physiotherapy' }), docTile('Medical licence', 'licence.pdf', true), docTile('Degree certificate', 'degree.jpg', true));
  s.finish();
  s = Screen('D-29', 'Settings', 'NEW', { app: { title: 'Settings', back: 'D-26' }, gap: 14 });
  s.add(menu([{ icon: 'lock', title: 'Change password', to: 'D-11' }, { icon: 'bell', title: 'Notification preferences', to: 'D-25' }, { icon: 'help', title: 'Help and support' }]), card([toggleRow('Email alerts for requests', true), divider(), toggleRow('Pain alerts', true), divider(), toggleRow('Inactive patient alerts', true)], { gap: 12 }));
  s.finish();
  dialogScreen('D-30', 'Logout Dialog', 'NEW', { icon: 'logout', title: 'Log out?', body: 'You can log back in any time.', primary: ['Log out', 'D-01'], secondary: ['Cancel', 'BACK'] });
  s = Screen('D-24', 'Invite Code (optional)', 'NEW', { app: { title: 'Invite code', back: 'D-26' }, action: { label: 'Generate code', to: 'D-24' }, gap: 16 });
  s.add(heading('Invite a patient', 'Optional. Hidden until invite codes are approved (D-07).'), card([col([txt('RS48-K2P9', 'displayMedium', C.brandGreen, { align: 'CENTER' }), txt('Expires in 7 days', 'caption', C.textSecondary, { align: 'CENTER' })], { gap: 4 })]));
  s.finish();
}
