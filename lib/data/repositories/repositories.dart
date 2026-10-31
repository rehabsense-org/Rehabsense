// ---------------------------------------------------------------------------
// FAKE IN-MEMORY REPOSITORIES — RehabSense
// ---------------------------------------------------------------------------

import 'dart:convert';

import '../../domain/models/models.dart';
import '../seed/seed_data.dart';

// ─── AUTH REPOSITORY ────────────────────────────────────────────────────────

class AuthRepository {
  RSUser? currentUser;
  bool isLoggedIn = false;
  bool onboardingSeen = false;
  bool emailVerified = false;
  bool profileComplete = false;
  bool cameraConsent = false;

  Future<RSUser> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = RSUser(
      id: 'user_001',
      name: 'Alex Rehabber',
      email: email,
      emailVerified: true,
      ageRange: '25-34',
      goal: 'Recover from knee surgery',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );
    currentUser = user;
    isLoggedIn = true;
    emailVerified = true;
    profileComplete = true;
    return user;
  }

  Future<RSUser> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = RSUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    currentUser = user;
    isLoggedIn = true;
    emailVerified = false;
    profileComplete = false;
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    currentUser = null;
    isLoggedIn = false;
  }

  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    currentUser = null;
    isLoggedIn = false;
    emailVerified = false;
    profileComplete = false;
    cameraConsent = false;
  }

  Future<void> verifyEmail() async {
    await Future.delayed(const Duration(seconds: 1));
    emailVerified = true;
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(emailVerified: true);
    }
  }

  Future<void> resendVerification() async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake: verification email "sent"
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake: password-reset email "sent"
  }

  Future<void> resetPassword(String token, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake: password "reset"
  }

  Future<void> updateProfile(String name, String ageRange, String goal) async {
    await Future.delayed(const Duration(seconds: 1));
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(
        name: name,
        ageRange: ageRange,
        goal: goal,
      );
    }
    profileComplete = true;
  }

  Future<void> changePassword(String current, String newPwd) async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake: password "changed"
  }
}

// ─── SESSION REPOSITORY ─────────────────────────────────────────────────────

class SessionRepository {
  final List<RSSession> _sessions = _buildSampleSessions();
  RSSession? _draft;

  List<RSSession> getRecentSessions() {
    return List.unmodifiable(_sessions);
  }

  Future<List<RSSession>> getSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.unmodifiable(_sessions);
  }

  Future<RSSession?> getSessionById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<RSSession>> getSessionsForExercise(String exerciseId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _sessions.where((s) => s.exerciseId == exerciseId).toList();
  }

  Future<void> saveSession(RSSession session) async {
    await Future.delayed(const Duration(seconds: 1));
    _sessions.removeWhere((s) => s.id == session.id);
    _sessions.add(session);
  }

  Future<void> deleteSession(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _sessions.removeWhere((s) => s.id == id);
  }

  /// Returns a draft session for interrupted-session recovery, or null.
  Future<RSSession?> getDraftSession() async {
    await Future.delayed(const Duration(seconds: 1));
    return _draft;
  }

  Future<void> saveDraft(RSSession session) async {
    await Future.delayed(const Duration(seconds: 1));
    _draft = session;
  }

  Future<void> clearDraft() async {
    await Future.delayed(const Duration(seconds: 1));
    _draft = null;
  }

  /// Returns aggregate stats for a time period.
  /// [period] is one of 'week', 'month', 'all'.
  Future<Map<String, dynamic>> getStats(String period) async {
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    late final DateTime since;
    switch (period) {
      case 'week':
        since = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        since = now.subtract(const Duration(days: 30));
        break;
      default:
        since = DateTime(2000);
    }

    final filtered =
        _sessions.where((s) => s.startedAt.isAfter(since)).toList();
    final totalReps =
        filtered.fold<int>(0, (sum, s) => sum + s.reps.length);
    final avgScore = filtered.isEmpty
        ? 0.0
        : filtered.fold<int>(0, (sum, s) => sum + s.score) /
            filtered.length;

    // Streak: consecutive days with at least one session
    int streak = 0;
    var day = DateTime(now.year, now.month, now.day);
    while (true) {
      final hasSession = _sessions.any((s) =>
          s.startedAt.year == day.year &&
          s.startedAt.month == day.month &&
          s.startedAt.day == day.day);
      if (!hasSession) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }

    return {
      'sessions': filtered.length,
      'reps': totalReps,
      'avgScore': avgScore,
      'streak': streak,
    };
  }

  /// Returns a list of {date, score} maps for charting.
  Future<List<Map<String, dynamic>>> getScoreHistory(String period) async {
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    late final DateTime since;
    switch (period) {
      case 'week':
        since = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        since = now.subtract(const Duration(days: 30));
        break;
      default:
        since = DateTime(2000);
    }

    return _sessions
        .where((s) => s.startedAt.isAfter(since))
        .map((s) => {'date': s.startedAt, 'score': s.score})
        .toList()
      ..sort((a, b) =>
          (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  }
}

// ─── COURSE REPOSITORY ──────────────────────────────────────────────────────

class CourseRepository {
  final List<RSCourse> _courses = List.of(seedCourses);
  final List<RSExercise> _exercises = List.of(seedExercises);

  Future<List<RSCourse>> getCourses() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.unmodifiable(_courses);
  }

  Future<RSCourse?> getCourseById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<RSExercise?> getExercise(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<RSExercise>> getExercisesForCourse(String courseId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _exercises
        .where((e) => e.courseId == courseId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Returns exercise-level progress: best score, average score, attempts.
  Future<Map<String, dynamic>> getExerciseProgress(String exerciseId) async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake progress based on exercise ordering
    final ex = _exercises.where((e) => e.id == exerciseId).firstOrNull;
    if (ex == null) {
      return {'bestScore': 0, 'avgScore': 0.0, 'attempts': 0};
    }
    // Deterministic fake data keyed off exercise order
    final attempts = (ex.order * 3) + 1;
    final bestScore = 70 + (ex.order * 5);
    final avgScore = bestScore - 8.0;
    return {
      'bestScore': bestScore.clamp(0, 100),
      'avgScore': avgScore.clamp(0.0, 100.0),
      'attempts': attempts,
    };
  }

  /// Returns course-level progress: completed exercises, total exercises.
  Future<Map<String, int>> getCourseProgress(String courseId) async {
    await Future.delayed(const Duration(seconds: 1));
    final course = _courses.where((c) => c.id == courseId).firstOrNull;
    if (course == null) return {'completed': 0, 'total': 0};
    // Fake: first 2 exercises are "completed"
    return {
      'completed': 2,
      'total': course.exerciseIds.length,
    };
  }
}

// ─── NOTIFICATION REPOSITORY ────────────────────────────────────────────────

class NotificationRepository {
  final List<RSNotification> _notifications = _buildSampleNotifications();

  bool get hasUnread => _notifications.any((n) => !n.read);

  List<RSNotification> getNotificationsSync() => List.unmodifiable(_notifications);

  Future<List<RSNotification>> getNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.unmodifiable(_notifications);
  }

  Future<void> markRead(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].markRead();
    }
  }

  Future<void> dismiss(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    _notifications.removeWhere((n) => n.id == id);
  }
}

// ─── USER REPOSITORY ────────────────────────────────────────────────────────

class UserRepository {
  RSPreferences _preferences = const RSPreferences();

  Future<RSPreferences> getPreferences() async {
    await Future.delayed(const Duration(seconds: 1));
    return _preferences;
  }

  Future<void> savePreferences(RSPreferences prefs) async {
    await Future.delayed(const Duration(seconds: 1));
    _preferences = prefs;
  }

  /// Exports all local data as a JSON string.
  Future<String> exportData() async {
    await Future.delayed(const Duration(seconds: 1));
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'preferences': {
        'audio': _preferences.audio,
        'haptics': _preferences.haptics,
        'showSkeleton': _preferences.showSkeleton,
        'remindersEnabled': _preferences.remindersEnabled,
        'weeklySummary': _preferences.weeklySummary,
        'tips': _preferences.tips,
      },
      'note': 'This is a demo export — real app would include full session data.',
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> clearLocalSessions() async {
    await Future.delayed(const Duration(seconds: 1));
    // Fake: local session cache "cleared"
  }
}

// ─── SAMPLE DATA BUILDERS ───────────────────────────────────────────────────

List<RSSession> _buildSampleSessions() {
  final now = DateTime.now();
  return [
    // Today's session
    RSSession(
      id: 'session_001',
      userId: 'user_001',
      exerciseId: 'knee_mini_squat',
      startedAt: now.subtract(const Duration(hours: 2)),
      endedAt: now.subtract(const Duration(hours: 1, minutes: 45)),
      status: SessionStatus.saved,
      score: 85,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 42.0, durationMs: 3200),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 40.5, durationMs: 3100),
        RSRep(index: 3, outcome: RepOutcome.incorrect, peakAngle: 28.0, durationMs: 2800, feedbackKey: 'too_shallow'),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 44.0, durationMs: 3400),
        RSRep(index: 5, outcome: RepOutcome.correct, peakAngle: 41.0, durationMs: 3000),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 43.0, durationMs: 3300),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 39.5, durationMs: 3150),
        RSRep(index: 8, outcome: RepOutcome.incomplete, peakAngle: 15.0, durationMs: 1200, feedbackKey: 'not_finished'),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 42.5, durationMs: 3250),
        RSRep(index: 10, outcome: RepOutcome.correct, peakAngle: 41.0, durationMs: 3100),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 15),
        avgRom: 41.2,
        tempo: 3.15,
        symmetry: 0.92,
      ),
    ),

    // Yesterday
    RSSession(
      id: 'session_002',
      userId: 'user_001',
      exerciseId: 'knee_straight_leg_raise',
      startedAt: now.subtract(const Duration(days: 1, hours: 3)),
      endedAt: now.subtract(const Duration(days: 1, hours: 2, minutes: 48)),
      status: SessionStatus.saved,
      score: 90,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 55.0, durationMs: 2900),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 53.0, durationMs: 3000),
        RSRep(index: 3, outcome: RepOutcome.correct, peakAngle: 56.0, durationMs: 3100),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 54.0, durationMs: 2950),
        RSRep(index: 5, outcome: RepOutcome.incorrect, peakAngle: 35.0, durationMs: 2600, feedbackKey: 'knee_bent'),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 55.5, durationMs: 3050),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 54.0, durationMs: 2900),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 56.5, durationMs: 3200),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 53.5, durationMs: 2850),
        RSRep(index: 10, outcome: RepOutcome.correct, peakAngle: 55.0, durationMs: 3000),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 12),
        avgRom: 52.8,
        tempo: 2.96,
        symmetry: 0.95,
      ),
    ),

    // 2 days ago
    RSSession(
      id: 'session_003',
      userId: 'user_001',
      exerciseId: 'knee_seated_extension',
      startedAt: now.subtract(const Duration(days: 2, hours: 5)),
      endedAt: now.subtract(const Duration(days: 2, hours: 4, minutes: 46)),
      status: SessionStatus.saved,
      score: 78,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 160.0, durationMs: 3500),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 158.0, durationMs: 3400),
        RSRep(index: 3, outcome: RepOutcome.incorrect, peakAngle: 130.0, durationMs: 3000, feedbackKey: 'limited_extension'),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 162.0, durationMs: 3600),
        RSRep(index: 5, outcome: RepOutcome.correct, peakAngle: 155.0, durationMs: 3350),
        RSRep(index: 6, outcome: RepOutcome.incorrect, peakAngle: 128.0, durationMs: 2900, feedbackKey: 'limited_extension'),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 159.0, durationMs: 3450),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 161.0, durationMs: 3500),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 157.0, durationMs: 3300),
        RSRep(index: 10, outcome: RepOutcome.incomplete, peakAngle: 90.0, durationMs: 1500, feedbackKey: 'not_finished'),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 14),
        avgRom: 148.0,
        tempo: 3.15,
        symmetry: 0.88,
      ),
    ),

    // 4 days ago
    RSSession(
      id: 'session_004',
      userId: 'user_001',
      exerciseId: 'knee_mini_squat',
      startedAt: now.subtract(const Duration(days: 4, hours: 1)),
      endedAt: now.subtract(const Duration(days: 4, minutes: 48)),
      status: SessionStatus.saved,
      score: 72,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 38.0, durationMs: 3500),
        RSRep(index: 2, outcome: RepOutcome.incorrect, peakAngle: 22.0, durationMs: 2600, feedbackKey: 'too_shallow'),
        RSRep(index: 3, outcome: RepOutcome.correct, peakAngle: 40.0, durationMs: 3200),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 37.0, durationMs: 3300),
        RSRep(index: 5, outcome: RepOutcome.incorrect, peakAngle: 20.0, durationMs: 2500, feedbackKey: 'too_shallow'),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 41.0, durationMs: 3400),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 39.0, durationMs: 3100),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 42.0, durationMs: 3350),
        RSRep(index: 9, outcome: RepOutcome.incomplete, peakAngle: 10.0, durationMs: 900, feedbackKey: 'not_finished'),
        RSRep(index: 10, outcome: RepOutcome.correct, peakAngle: 38.5, durationMs: 3200),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 12),
        avgRom: 32.7,
        tempo: 3.01,
        symmetry: 0.85,
      ),
    ),

    // 6 days ago — shoulder exercise
    RSSession(
      id: 'session_005',
      userId: 'user_001',
      exerciseId: 'shoulder_pendulum_swing',
      startedAt: now.subtract(const Duration(days: 6, hours: 4)),
      endedAt: now.subtract(const Duration(days: 6, hours: 3, minutes: 50)),
      status: SessionStatus.saved,
      score: 92,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, durationMs: 4000),
        RSRep(index: 2, outcome: RepOutcome.correct, durationMs: 4100),
        RSRep(index: 3, outcome: RepOutcome.correct, durationMs: 3900),
        RSRep(index: 4, outcome: RepOutcome.correct, durationMs: 4050),
        RSRep(index: 5, outcome: RepOutcome.correct, durationMs: 4200),
        RSRep(index: 6, outcome: RepOutcome.correct, durationMs: 3950),
        RSRep(index: 7, outcome: RepOutcome.incorrect, durationMs: 3500, feedbackKey: 'too_fast'),
        RSRep(index: 8, outcome: RepOutcome.correct, durationMs: 4100),
        RSRep(index: 9, outcome: RepOutcome.correct, durationMs: 4000),
        RSRep(index: 10, outcome: RepOutcome.correct, durationMs: 4150),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 10),
        avgRom: 0.0,
        tempo: 3.99,
        symmetry: 0.97,
      ),
    ),

    // 10 days ago
    RSSession(
      id: 'session_006',
      userId: 'user_001',
      exerciseId: 'knee_heel_slide',
      startedAt: now.subtract(const Duration(days: 10, hours: 2)),
      endedAt: now.subtract(const Duration(days: 10, hours: 1, minutes: 46)),
      status: SessionStatus.saved,
      score: 65,
      syncState: SyncState.synced,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 95.0, durationMs: 3800),
        RSRep(index: 2, outcome: RepOutcome.incorrect, peakAngle: 60.0, durationMs: 3000, feedbackKey: 'limited_flexion'),
        RSRep(index: 3, outcome: RepOutcome.correct, peakAngle: 100.0, durationMs: 4000),
        RSRep(index: 4, outcome: RepOutcome.incorrect, peakAngle: 55.0, durationMs: 2800, feedbackKey: 'limited_flexion'),
        RSRep(index: 5, outcome: RepOutcome.correct, peakAngle: 98.0, durationMs: 3900),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 102.0, durationMs: 4100),
        RSRep(index: 7, outcome: RepOutcome.incomplete, peakAngle: 40.0, durationMs: 1500, feedbackKey: 'not_finished'),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 97.0, durationMs: 3850),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 99.0, durationMs: 3950),
        RSRep(index: 10, outcome: RepOutcome.incorrect, peakAngle: 58.0, durationMs: 2900, feedbackKey: 'limited_flexion'),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 14),
        avgRom: 80.4,
        tempo: 3.38,
        symmetry: 0.82,
      ),
    ),
  ];
}

List<RSNotification> _buildSampleNotifications() {
  final now = DateTime.now();
  return [
    RSNotification(
      id: 'notif_001',
      type: NotificationType.reminder,
      title: 'Time to exercise!',
      body: "You haven't completed today's knee rehabilitation session yet. "
          'A quick 15-minute workout will keep you on track.',
      createdAt: now.subtract(const Duration(hours: 3)),
    ),
    RSNotification(
      id: 'notif_002',
      type: NotificationType.milestone,
      title: '🎉 5-session streak!',
      body: "Congratulations! You've completed exercises 5 days in a row. "
          'Keep up the great work!',
      createdAt: now.subtract(const Duration(days: 1)),
      read: true,
    ),
    RSNotification(
      id: 'notif_003',
      type: NotificationType.tip,
      title: 'Tip: Watch your knee alignment',
      body: 'During mini squats, focus on keeping your knees aligned over '
          'your second toe. This helps protect the joint and improves form.',
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    RSNotification(
      id: 'notif_004',
      type: NotificationType.milestone,
      title: '🏅 New best score!',
      body: 'You scored 92 on Pendulum Swing — your highest yet! '
          'Your consistency is paying off.',
      createdAt: now.subtract(const Duration(days: 3)),
      read: true,
    ),
    RSNotification(
      id: 'notif_005',
      type: NotificationType.reminder,
      title: 'Weekly summary ready',
      body: 'You completed 4 sessions this week with an average score of 81. '
          'Tap to view your full progress report.',
      createdAt: now.subtract(const Duration(days: 5)),
      read: true,
    ),
    RSNotification(
      id: 'notif_006',
      type: NotificationType.tip,
      title: 'Tip: Breathe through the motion',
      body: 'Remember to exhale during the effort phase and inhale during '
          'the release. Proper breathing improves performance and reduces '
          'tension.',
      createdAt: now.subtract(const Duration(days: 7)),
    ),
  ];
}
