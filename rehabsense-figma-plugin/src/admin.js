// ADMIN PORTAL - all screens NEW (UPDATE_BRIEF section 6)
function buildAdmin() {
  GROUP = 'ADMIN PORTAL';
  let s;
  const dots = '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022';

  s = Screen('A-01', 'Admin Login', 'NEW', { app: { title: '', back: 'P-02' }, gap: 16 });
  s.add(col([iconCircle('shield', 72)], { cross: 'CENTER' }), heading('Staff login', 'Admin accounts are created by the team. There is no sign up.'), input('Email', { icon: 'mail', value: 'admin@rehabsense.test' }), input('Password', { icon: 'lock', value: dots, suffix: 'eye' }),
    btn('Forgot password?', { v: 'text', size: 'M', to: 'A-02', full: false }), btn('Log in', { to: 'A-04' }), btn('Prototype: wrong portal (not an admin)', { v: 'text', size: 'M', to: 'A-25' }));
  s.finish();
  s = Screen('A-02', 'Forgot Password', 'NEW', { app: { title: '', back: 'A-01' }, gap: 16 });
  s.add(heading('Forgot password?', 'We will send a reset link.'), input('Email', { icon: 'mail', value: 'admin@rehabsense.test' }), btn('Send reset link', { to: 'A-03' }), btn('Back to login', { v: 'text', to: 'A-01' }));
  s.finish();
  s = Screen('A-03', 'Reset Password', 'NEW', { app: { title: '', close: true, back: 'A-01' }, gap: 16 });
  s.add(heading('Create new password'), input('New password', { icon: 'lock', value: dots, suffix: 'eye' }), input('Confirm password', { icon: 'lock', value: dots }), btn('Update password', { to: 'A-01' }));
  s.finish();

  s = Screen('A-04', 'Dashboard', 'NEW', { nav: 'admin', active: 0, gap: 16 });
  s.add(row([col([txt('Dashboard', 'h1', C.brandGreen), txt('Overview of RehabSense', 'small', C.textSecondary)], { gap: 0, grow: true }), iconBtn('bell', 'A-20')], { gap: 4 }),
    statRow([['Pending applications', '4', null], ['Active doctors', '18']]), statRow([['Patients', '246', '+12'], ['Sessions today', '83']]),
    sectionTitle('Pending applications', 'See all', 'A-05'), listItem('Sara Khan', 'Physiotherapist \u00B7 submitted today', { avatar: 'SK', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Omar Sheikh', 'Sports physio \u00B7 submitted 2 d ago', { avatar: 'OS', chip: status('pending', 'Pending'), to: 'A-06' }),
    sectionTitle('Quick links'), menu([{ icon: 'heart', title: 'Manage doctors', to: 'A-10' }, { icon: 'users', title: 'Manage patients', to: 'A-15' }, { icon: 'file', title: 'Audit log', to: 'A-21' }]));
  s.finish();

  s = Screen('A-05', 'Applications List', 'NEW', { app: { title: 'Applications', back: 'A-04' }, gap: 12 });
  s.add(seg(['Pending', 'Rejected', 'Approved'], 0), listItem('Sara Khan', 'PMDC-48213 \u00B7 attempt 1 of 3', { avatar: 'SK', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Omar Sheikh', 'PMDC-39120 \u00B7 attempt 1 of 3', { avatar: 'OS', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Hina Malik', 'PMDC-51007 \u00B7 attempt 2 of 3', { avatar: 'HM', chip: status('pending', 'Pending'), to: 'A-06' }), listItem('Zaid Ahmed', 'PMDC-22764 \u00B7 attempt 1 of 3', { avatar: 'ZA', chip: status('pending', 'Pending'), to: 'A-06' }));
  s.finish();
  s = Screen('A-06', 'Application Detail', 'NEW', { app: { title: 'Application', back: 'A-05' }, action: [{ label: 'Reject', v: 'destructiveOutline', to: 'A-09' }, { label: 'Approve', to: 'A-08' }], gap: 14 });
  s.add(card([row([avatar('SK', 56), col([txt('Dr. Sara Khan', 'h3'), txt('sara.khan@clinic.test', 'caption', C.textSecondary), status('pending', 'Pending')], { gap: 4, grow: true })], { gap: 12 })]),
    card([kv('Licence', 'PMDC-48213'), kv('Degree', 'DPT, Physiotherapy'), kv('Attempt', '1 of 3'), kv('Submitted', 'Today, 9:12 AM')], { gap: 10 }), sectionTitle('Documents'),
    card([row([iconCircle('file', 40), col([txt('Medical licence', 'bodyStrong'), txt('PDF \u00B7 1.2 MB', 'caption', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { to: 'A-07' }),
    card([row([iconCircle('file', 40), col([txt('Degree certificate', 'bodyStrong'), txt('JPG \u00B7 2.4 MB', 'caption', C.textSecondary)], { gap: 0, grow: true }), icon('right', 20, C.textSecondary)], { gap: 12 })], { to: 'A-07' }),
    btn('Resend decision email', { v: 'text', size: 'M', to: 'A-05' }));
  s.finish();
  s = Screen('A-07', 'Document Viewer', 'NEW', { app: { title: 'Medical licence', back: 'A-06', dark: false }, gap: 14 });
  const page = mk('Document', { dir: 'V', gap: 10, pad: [24, 24, 24, 24], fill: C.surfaceCard, r: R.card, shadow: true }); flag(page, { st: true });
  A(page, txt('MEDICAL LICENCE', 'captionStrong', C.textSecondary), txt('Dr. Sara Khan', 'h3'), txt('Licence no. PMDC-48213', 'small'), txt('Valid until 2029', 'small', C.textSecondary), divider(), skel(160, 8));
  s.add(banner('info', 'This secure link expires in 60 seconds. Reopen the document if it stops loading.'), page, btn('Reopen secure link', { v: 'secondary', to: 'A-07' }), btn('Back to application', { v: 'text', to: 'A-06' }));
  s.finish();
  dialogScreen('A-08', 'Approve Dialog', 'NEW', { icon: 'check', title: 'Approve Dr. Sara Khan?', body: 'She will be able to log in and set up her profile. This is saved in the audit log.', primary: ['Approve', 'A-05'], secondary: ['Cancel', 'BACK'] });
  dialogScreen('A-09', 'Reject Sheet', 'NEW', { sheet: true, icon: 'x', destructive: true, title: 'Reject application', body: 'Choose a reason. The doctor will see it and can resubmit.', extra: [chips(['Unreadable document', 'Licence not found', 'Mismatch', 'Other'], 0), area('Note to doctor', 'The licence photo is not readable. Please upload a clearer copy.', 72)], primary: ['Reject application', 'A-05'], secondary: ['Cancel', 'BACK'] });

  s = Screen('A-10', 'Doctors List', 'NEW', { nav: 'admin', active: 1, gap: 12 });
  s.add(row([txt('Doctors', 'h1', C.brandGreen), btn('Add', { size: 'M', icon: 'plus', to: 'A-14', full: false, v: 'secondary' })], { main: 'SPACE_BETWEEN' }), input('Search doctors', { icon: 'search', hint: 'Name or licence' }), chips(['All', 'Active', 'Suspended'], 0),
    listItem('Dr. Sara Khan', '12 patients \u00B7 Knee', { avatar: 'SK', chip: status('correct', 'Active'), to: 'A-11' }), listItem('Dr. Omar Sheikh', '8 patients \u00B7 Sports', { avatar: 'OS', chip: status('correct', 'Active'), to: 'A-11' }), listItem('Dr. Hina Malik', '0 patients \u00B7 Shoulder', { avatar: 'HM', chip: status('incomplete', 'Suspended'), to: 'A-11' }));
  s.finish();
  s = Screen('A-11', 'Doctor Detail', 'NEW', { app: { title: 'Doctor', back: 'A-10' }, action: [{ label: 'Suspend', v: 'destructiveOutline', to: 'A-13' }, { label: 'Edit', to: 'A-12' }], gap: 14 });
  s.add(card([row([avatar('SK', 64), col([txt('Dr. Sara Khan', 'h3'), txt('Physiotherapist \u00B7 City Rehab Clinic', 'small', C.textSecondary), status('correct', 'Active and listed')], { gap: 4, grow: true })], { gap: 12 })]),
    statRow([['Patients', '12'], ['Exercises', '5']]), card([kv('Licence', 'PMDC-48213'), kv('Expertise', 'Knee, Post-surgery'), kv('Accepting patients', 'Yes'), kv('Joined', '12 Oct 2026')], { gap: 10 }), infoBox('Admins cannot see patient sessions, pain or conditions.'));
  s.finish();
  s = Screen('A-12', 'Edit Doctor', 'NEW', { app: { title: 'Edit doctor', back: 'A-11' }, action: { label: 'Save changes', to: 'A-11' }, gap: 14 });
  s.add(input('Title', { value: 'Physiotherapist' }), input('Clinic', { icon: 'pin', value: 'City Rehab Clinic' }), overline('Expertise'), chips(['Knee', 'Shoulder', 'Hip', 'Post-surgery'], [0, 3]), card([toggleRow('Listed to patients', true)]), banner('info', 'Every change is written to the audit log.'));
  s.finish();
  dialogScreen('A-13', 'Suspend or Reactivate', 'NEW', { icon: 'ban', destructive: true, title: 'Suspend Dr. Sara Khan?', body: 'She will be signed out and her patients will be told she is not available. You can reactivate her any time.', primary: ['Suspend doctor', 'A-10'], secondary: ['Cancel', 'BACK'] });
  s = Screen('A-14', 'Add Doctor (optional)', 'NEW', { app: { title: 'Add doctor', back: 'A-10' }, action: { label: 'Create doctor', to: 'A-10' }, gap: 14 });
  s.add(banner('info', 'Optional. Creates an approved doctor who sets a password by email.'), input('Full name', { icon: 'user', hint: 'Dr. name' }), input('Work email', { icon: 'mail', hint: 'name@clinic.com' }), input('Licence number', { icon: 'file', hint: 'PMDC-00000' }));
  s.finish();

  s = Screen('A-15', 'Patients List', 'NEW', { nav: 'admin', active: 2, gap: 12 });
  s.add(heading('Patients', '246 accounts'), input('Search patients', { icon: 'search', hint: 'Name or email' }), chips(['All', 'Active', 'Disabled'], 0), listItem('Alex Morgan', 'alex@rehab.test', { avatar: 'AM', chip: status('correct', 'Active'), to: 'A-16' }), listItem('Ali Raza', 'ali.raza@mail.test', { avatar: 'AR', chip: status('correct', 'Active'), to: 'A-16' }), listItem('Sana Iqbal', 'sana@mail.test', { avatar: 'SI', chip: status('incomplete', 'Disabled'), to: 'A-16' }));
  s.finish();
  s = Screen('A-16', 'Patient Detail (account only)', 'NEW', { app: { title: 'Patient', back: 'A-15' }, action: { label: 'Disable account', v: 'destructive', to: 'A-13' }, gap: 14 });
  s.add(card([row([avatar('AM', 64), col([txt('Alex Morgan', 'h3'), txt('alex@rehab.test', 'small', C.textSecondary), status('correct', 'Active')], { gap: 4, grow: true })], { gap: 12 })]), card([kv('Joined', '2 Nov 2026'), kv('Last active', 'Today'), kv('Email verified', 'Yes'), kv('Connected doctor', 'Yes')], { gap: 10 }),
    banner('info', 'Account info only. Sessions, pain and conditions are private and not shown to admins.'));
  s.finish();

  s = Screen('A-17', 'Exercise Library', 'NEW', { nav: 'admin', active: 3, gap: 12 });
  s.add(row([txt('Exercises', 'h1', C.brandGreen), btn('New', { size: 'M', icon: 'plus', to: 'A-18', full: false })], { main: 'SPACE_BETWEEN' }), chips(['All', 'Public', 'Private', 'Archived'], 0), listItem('Mini Squat', 'Rehab \u00B7 rep \u00B7 Public', { icon: 'activity', chip: status('correct', 'Tested'), to: 'A-19' }), listItem('Warrior II hold', 'Yoga \u00B7 hold \u00B7 Public', { icon: 'activity', chip: status('correct', 'Tested'), to: 'A-19' }), listItem('Tree pose hold', 'Yoga \u00B7 hold \u00B7 Public', { icon: 'activity', chip: status('pending', 'Untested'), to: 'A-19' }), listItem('Wall Sit', 'Rehab \u00B7 hold \u00B7 Private (Dr. Khan)', { icon: 'activity', chip: status('pending', 'Untested'), to: 'A-19' }));
  s.finish();
  wizard('A-18', 'Exercise Builder', 'NEW', {
    title: 'New exercise', back: 'A-17', finish: 'Publish', done: 'A-17', steps: [
      { title: 'Basics', head: 'Basics', sub: 'Name, category and visibility.', build: function (s) { s.add(input('Name', { value: 'Tree pose' }), overline('Category'), chips(['Rehab', 'Yoga', 'General'], 1), overline('Visibility'), seg(['Public', 'Private'], 0), area('Steps for the patient', 'Stand tall and lift one foot to the opposite thigh.', 80)); } },
      { title: 'Camera and kind', head: 'Camera and kind', sub: 'How patients will be tracked.', build: function (s) { s.add(overline('Type'), seg(['Rep', 'Hold'], 1), overline('Camera view'), seg(['Side', 'Front'], 1), banner('info', 'No video or images are stored.')); } },
      { title: 'Tracking config', head: 'Tracking config', sub: 'Angle range and hold time.', build: function (s) { s.add(input('Joint', { value: 'Standing knee' }), input('Angle range (degrees)', { value: '60 to 90' }), input('Hold time (seconds)', { value: '20' }), btn('Test on camera', { v: 'secondary', to: 'A-19' })); } },
      { title: 'Review', head: 'Review', sub: 'Publishing is saved in the audit log.', build: function (s) { s.add(card([kv('Name', 'Tree pose'), kv('Category', 'Yoga'), kv('Type', 'Hold'), kv('Camera', 'Front'), kv('Visibility', 'Public')], { gap: 10 })); } }]
  });
  s = Screen('A-19', 'Test on Camera', 'NEW', { camera: true });
  skeleton(s, { color: '#FFFFFF' }); s.abs(statusBar(true), 0, 0); glassBtn(s, 'x', 8, 32, 'A-17'); pill(s, 'TEST MODE \u00B7 nothing is saved', 60, 40, 240);
  const ac = mk('Counter', { dir: 'V', cross: 'CENTER', w: 360 }); A(ac, txt('0:14', 'displayMetric', C.textOnDark, { hug: true, align: 'CENTER' }), txt('Hold 20 s \u00B7 Tree pose', 'bodyStrong', C.textOnDarkSoft, { hug: true })); s.abs(ac, 0, 96);
  const ad = mk('Dock', { dir: 'V', gap: 8, pad: [12, 16, 24, 16], fill: C.glass, w: 360 }); A(ad, btn('Mark as tested', { v: 'onDarkFilled', size: 'M', to: 'A-17' }), btn('Back to builder', { v: 'onDarkOutline', size: 'M', to: 'A-18c' })); s.abs(ad, 0, 800 - ad.height); s.finish();

  s = Screen('A-20', 'Notifications', 'NEW', { app: { title: 'Notifications', back: 'A-04' }, gap: 12 });
  s.add(listItem('New application', 'Sara Khan submitted documents \u00B7 5 min ago', { icon: 'file', to: 'A-06' }), listItem('Resubmission', 'Hina Malik resubmitted (attempt 2 of 3)', { icon: 'refresh', to: 'A-06' }), listItem('Credentials changed', 'Omar Sheikh updated his licence', { icon: 'alert', to: 'A-11' }));
  s.finish();
  s = Screen('A-21', 'Audit Log', 'NEW', { app: { title: 'Audit log', back: 'A-22' }, gap: 12 });
  s.add(banner('info', 'Read-only. Every admin action is recorded here.'), chips(['All', 'Approvals', 'Suspensions', 'Exercises'], 0),
    listItem('Approved doctor', 'admin@rehabsense.test \u00B7 Sara Khan \u00B7 today 9:30', { icon: 'check' }), listItem('Rejected application', 'admin@rehabsense.test \u00B7 Hina Malik \u00B7 yesterday', { icon: 'x' }), listItem('Published exercise', 'admin@rehabsense.test \u00B7 Tree pose \u00B7 2 d ago', { icon: 'zap' }), listItem('Suspended doctor', 'admin@rehabsense.test \u00B7 Zaid Ahmed \u00B7 5 d ago', { icon: 'ban' }));
  s.finish();
  s = Screen('A-22', 'Profile (More)', 'NEW', { nav: 'admin', active: 4, gap: 16 });
  s.add(card([row([avatar('AD', 64), col([txt('Admin', 'h3'), txt('admin@rehabsense.test', 'small', C.textSecondary)], { gap: 0, grow: true })], { gap: 12 })]),
    menu([{ icon: 'bell', title: 'Notifications', to: 'A-20' }, { icon: 'file', title: 'Audit log', to: 'A-21' }, { icon: 'lock', title: 'Change password', to: 'A-23' }]), menu([{ icon: 'logout', title: 'Log out', danger: true, to: 'A-24' }]));
  s.finish();
  s = Screen('A-23', 'Change Password', 'NEW', { app: { title: 'Change password', back: 'A-22' }, action: { label: 'Update password', to: 'A-22' }, gap: 14 });
  s.add(input('Current password', { icon: 'lock', value: dots }), input('New password', { icon: 'lock', value: dots }), input('Confirm new password', { icon: 'lock', value: dots }));
  s.finish();
  dialogScreen('A-24', 'Logout Dialog', 'NEW', { icon: 'logout', title: 'Log out?', body: 'You will return to the welcome screen.', primary: ['Log out', 'P-02'], secondary: ['Cancel', 'BACK'] });
  stateScreen('A-25', 'Blocked or Wrong Portal', 'NEW', { app: { title: '', back: 'A-01' }, icon: 'ban', tone: 'error', title: 'No access', body: 'This account is not an admin account. Use the patient or doctor app instead.', buttons: [['Back to welcome', 'P-02'], ['Try another account', 'A-01', 'secondary']] });
}
