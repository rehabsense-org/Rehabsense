// ---------------------------------------------------------------------------
// SEED DATA — RehabSense
// ---------------------------------------------------------------------------

import '../../domain/models/models.dart';

// ─── COURSES ────────────────────────────────────────────────────────────────

final List<RSCourse> seedCourses = const [
  RSCourse(
    id: 'knee_rehab',
    name: 'Knee Rehabilitation',
    description:
        'A progressive programme to rebuild knee strength, stability and '
        'range of motion after injury or surgery.',
    level: 'Beginner',
    exerciseIds: [
      'knee_mini_squat',
      'knee_straight_leg_raise',
      'knee_seated_extension',
      'knee_heel_slide',
      'knee_step_up',
    ],
    icon: 'activity',
  ),
  RSCourse(
    id: 'shoulder_mobility',
    name: 'Shoulder Mobility',
    description:
        'Gentle exercises designed to restore shoulder range of motion, '
        'reduce stiffness and improve daily function.',
    level: 'Beginner',
    exerciseIds: [
      'shoulder_pendulum_swing',
      'shoulder_flexion',
      'shoulder_external_rotation',
      'shoulder_wall_slide',
      'shoulder_scapular_squeeze',
    ],
    icon: 'stretch_horizontal',
  ),
];

// ─── EXERCISES — Knee Rehabilitation ────────────────────────────────────────

final List<RSExercise> seedExercises = const [
  // ── 1. Mini Squat ─────────────────────────────────────────────────────────
  RSExercise(
    id: 'knee_mini_squat',
    courseId: 'knee_rehab',
    order: 1,
    name: 'Mini Squat',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['knee', 'hip', 'ankle'],
    steps: [
      'Stand with feet shoulder-width apart, toes pointing forward.',
      'Slowly bend your knees to about 30–45 degrees as if sitting back.',
      'Keep your weight on your heels and your back straight.',
      'Hold for 1–2 seconds at the bottom.',
      'Return to standing by pressing through your heels.',
    ],
    watchOutFor: [
      'Do not let your knees travel past your toes.',
      'Avoid rounding your lower back.',
    ],
    whatItHelps:
        'Strengthens the quadriceps, glutes and hamstrings while '
        'improving knee stability and functional movement patterns.',
  ),

  // ── 2. Straight-Leg Raise ─────────────────────────────────────────────────
  RSExercise(
    id: 'knee_straight_leg_raise',
    courseId: 'knee_rehab',
    order: 2,
    name: 'Straight-Leg Raise',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['knee', 'hip'],
    steps: [
      'Lie flat on your back with the unaffected knee bent and foot flat.',
      'Tighten the thigh muscles of your straight leg.',
      'Lift the straight leg to the height of the opposite knee.',
      'Hold for 2 seconds at the top, then slowly lower.',
    ],
    watchOutFor: [
      'Keep the raised leg fully straight — do not bend the knee.',
      'Avoid arching your lower back off the surface.',
    ],
    whatItHelps:
        'Activates the quadriceps without bending the knee, helping '
        'maintain muscle tone during early rehabilitation.',
  ),

  // ── 3. Seated Knee Extension ──────────────────────────────────────────────
  RSExercise(
    id: 'knee_seated_extension',
    courseId: 'knee_rehab',
    order: 3,
    name: 'Seated Knee Extension',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['knee'],
    steps: [
      'Sit on a firm chair with your feet flat on the floor.',
      'Slowly straighten your affected leg until it is parallel with the floor.',
      'Hold for 2 seconds, squeezing your quadriceps at the top.',
      'Slowly lower back to the starting position.',
    ],
    watchOutFor: [
      'Do not swing the leg — use a slow, controlled motion.',
    ],
    whatItHelps:
        'Isolates the quadriceps to rebuild strength and improve knee '
        'extension range of motion.',
  ),

  // ── 4. Heel Slide ────────────────────────────────────────────────────────
  RSExercise(
    id: 'knee_heel_slide',
    courseId: 'knee_rehab',
    order: 4,
    name: 'Heel Slide',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['knee', 'hip'],
    steps: [
      'Lie on your back with both legs extended.',
      'Slowly slide your heel toward your buttock, bending the knee.',
      'Go as far as comfortable without pain.',
      'Slide the heel back to the starting position.',
    ],
    watchOutFor: [
      'Keep the movement smooth — avoid jerking.',
      'Stop if you feel sharp pain in the knee joint.',
    ],
    whatItHelps:
        'Gently improves knee flexion range of motion and reduces '
        'post-operative stiffness.',
  ),

  // ── 5. Step-Up ───────────────────────────────────────────────────────────
  RSExercise(
    id: 'knee_step_up',
    courseId: 'knee_rehab',
    order: 5,
    name: 'Step-Up',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['knee', 'hip', 'ankle'],
    steps: [
      'Stand facing a low step or sturdy platform.',
      'Place your affected foot fully on the step.',
      'Press through the heel to step up, bringing the other foot beside it.',
      'Step back down leading with the unaffected leg.',
    ],
    watchOutFor: [
      'Keep your knee aligned over your second toe as you step up.',
      'Use a handrail or wall for balance if needed.',
    ],
    whatItHelps:
        'Builds functional leg strength and improves balance, mimicking '
        'everyday stair climbing.',
  ),

  // ─── EXERCISES — Shoulder Mobility ──────────────────────────────────────

  // ── 1. Pendulum Swing ─────────────────────────────────────────────────────
  RSExercise(
    id: 'shoulder_pendulum_swing',
    courseId: 'shoulder_mobility',
    order: 1,
    name: 'Pendulum Swing',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['shoulder'],
    steps: [
      'Lean forward with your unaffected hand resting on a table for support.',
      'Let the affected arm hang straight down, relaxed.',
      'Gently swing the arm in small circles (clockwise then counter-clockwise).',
      'Gradually increase the circle size as tolerated.',
    ],
    watchOutFor: [
      'Do not use muscle effort — let gravity and momentum create the motion.',
      'Keep your shoulders relaxed; avoid shrugging.',
    ],
    whatItHelps:
        'Provides gentle traction and movement to the shoulder joint, '
        'reducing stiffness and promoting early mobility.',
  ),

  // ── 2. Shoulder Flexion ───────────────────────────────────────────────────
  RSExercise(
    id: 'shoulder_flexion',
    courseId: 'shoulder_mobility',
    order: 2,
    name: 'Shoulder Flexion',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['shoulder', 'elbow'],
    steps: [
      'Stand or sit upright with your arm at your side.',
      'Slowly raise your arm forward and upward as high as comfortable.',
      'Keep your elbow straight and thumb pointing to the ceiling.',
      'Hold for 1–2 seconds at the top, then slowly lower.',
    ],
    watchOutFor: [
      'Do not arch your back to gain extra height.',
    ],
    whatItHelps:
        'Improves forward elevation range of motion in the shoulder, '
        'essential for reaching overhead activities.',
  ),

  // ── 3. External Rotation ──────────────────────────────────────────────────
  RSExercise(
    id: 'shoulder_external_rotation',
    courseId: 'shoulder_mobility',
    order: 3,
    name: 'External Rotation',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['shoulder'],
    steps: [
      'Stand with your elbow bent to 90 degrees, tucked against your side.',
      'Hold a light resistance band or towel in the affected hand.',
      'Rotate your forearm outward, away from your body.',
      'Hold for 1–2 seconds, then slowly return.',
    ],
    watchOutFor: [
      'Keep your elbow glued to your side throughout the movement.',
      'Do not rotate your trunk to cheat the motion.',
    ],
    whatItHelps:
        'Strengthens the rotator cuff muscles that stabilise the '
        'shoulder joint during daily activities.',
  ),

  // ── 4. Wall Slide ─────────────────────────────────────────────────────────
  RSExercise(
    id: 'shoulder_wall_slide',
    courseId: 'shoulder_mobility',
    order: 4,
    name: 'Wall Slide',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['shoulder', 'elbow'],
    steps: [
      'Stand facing a wall with both palms flat against it at shoulder height.',
      'Slowly slide your hands upward along the wall as far as comfortable.',
      'Hold the top position for 2 seconds.',
      'Slowly slide your hands back down to shoulder height.',
    ],
    watchOutFor: [
      'Keep your palms and forearms in contact with the wall.',
      'Do not shrug your shoulders as you slide up.',
    ],
    whatItHelps:
        'Improves overhead shoulder mobility in a supported position, '
        'reducing the risk of impingement.',
  ),

  // ── 5. Scapular Squeeze ───────────────────────────────────────────────────
  RSExercise(
    id: 'shoulder_scapular_squeeze',
    courseId: 'shoulder_mobility',
    order: 5,
    name: 'Scapular Squeeze',
    targetReps: 10,
    targetSets: 2,
    restSeconds: 30,
    joints: ['shoulder', 'thoracic_spine'],
    steps: [
      'Sit or stand with your arms relaxed at your sides.',
      'Pull your shoulder blades together as if pinching a pencil between them.',
      'Hold the squeeze for 3–5 seconds.',
      'Release slowly and repeat.',
    ],
    watchOutFor: [
      'Do not arch your lower back — keep your core engaged.',
    ],
    whatItHelps:
        'Strengthens the mid-back muscles (rhomboids and middle trapezius), '
        'improving posture and shoulder blade stability.',
  ),
];
