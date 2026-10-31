// ---------------------------------------------------------------------------
// REPOSITORIES — RehabSense
// Connects to Supabase for Auth & Sync with in-memory fallbacks.
// ---------------------------------------------------------------------------

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase_config.dart';
import '../../domain/models/models.dart';
import '../seed/seed_data.dart';

// ─── AUTH REPOSITORY ────────────────────────────────────────────────────────

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;
  AuthRepository._internal();

  SupabaseClient get _client => SupabaseConfig.client;

  bool onboardingSeen = false;
  bool cameraConsent = false;
  bool profileComplete = false;

  bool get isLoggedIn => _client.auth.currentUser != null;

  RSUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final metadata = user.userMetadata ?? {};
    return RSUser(
      id: user.id,
      name: (metadata['name'] as String?) ??
          user.email?.split('@').first ??
          'Alex Rehabber',
      email: user.email ?? '',
      emailVerified: user.emailConfirmedAt != null,
      ageRange: metadata['age_range'] as String?,
      goal: metadata['goal'] as String?,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }

  Future<RSUser> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthException('No user account found.');
      }
      return RSUser(
        id: user.id,
        name: (user.userMetadata?['name'] as String?) ??
            user.email?.split('@').first ??
            'User',
        email: user.email ?? email,
        emailVerified: user.emailConfirmedAt != null,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('Supabase login error: $e');
      throw AuthException(e.toString());
    }
  }

  Future<RSUser> register(String name, String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      final user = response.user;
      if (user == null) {
        throw const AuthException('Could not create user account.');
      }
      return RSUser(
        id: user.id,
        name: name,
        email: user.email ?? email,
        emailVerified: user.emailConfirmedAt != null,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      debugPrint('Supabase register error: $e');
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('Supabase logout error: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid != null) {
        await _client.from('profiles').delete().eq('id', uid);
      }
      await _client.auth.signOut();
    } catch (e) {
      debugPrint('Supabase delete account error: $e');
    }
  }

  Future<void> verifyEmail() async {
    // In Supabase, verification is done through the email link or code
    await _client.auth.refreshSession();
  }

  Future<void> resendVerification(String email) async {
    try {
      await _client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      debugPrint('Resend verification error: $e');
    }
  }

  Future<void> forgotPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> resetPassword(String newPassword) async {
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> updateProfile(String name, String ageRange, String goal) async {
    final uid = _client.auth.currentUser?.id;
    if (uid != null) {
      try {
        await _client.from('profiles').upsert({
          'id': uid,
          'name': name,
          'age_range': ageRange,
          'goal': goal,
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('Update profile error: $e');
      }
      try {
        await _client.auth.updateUser(
          UserAttributes(
            data: {'name': name, 'age_range': ageRange, 'goal': goal},
          ),
        );
      } catch (e) {
        debugPrint('Update auth user metadata error: $e');
      }
    }
    profileComplete = true;
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
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_sessions);
  }

  Future<RSSession?> getSessionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<RSSession>> getSessionsForExercise(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _sessions.where((s) => s.exerciseId == exerciseId).toList();
  }

  Future<void> saveSession(RSSession session) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessions.removeWhere((s) => s.id == session.id);
    _sessions.add(session);
  }

  Future<void> deleteSession(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _sessions.removeWhere((s) => s.id == id);
  }

  Future<RSSession?> getDraftSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _draft;
  }

  Future<void> saveDraft(RSSession session) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _draft = session;
  }

  Future<void> clearDraft() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _draft = null;
  }

  Future<Map<String, dynamic>> getStats(String period) async {
    await Future.delayed(const Duration(milliseconds: 300));
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

    final filtered = _sessions.where((s) => s.startedAt.isAfter(since)).toList();
    final totalReps = filtered.fold<int>(0, (sum, s) => sum + s.reps.length);
    final avgScore = filtered.isEmpty
        ? 0
        : (filtered.fold<int>(0, (sum, s) => sum + s.score) / filtered.length).round();

    return {
      'sessions': filtered.length,
      'reps': totalReps,
      'avgScore': avgScore,
      'streak': 5,
    };
  }

  Future<List<Map<String, dynamic>>> getScoreHistory(String period) async {
    await Future.delayed(const Duration(milliseconds: 300));
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
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_courses);
  }

  Future<RSCourse?> getCourseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<RSExercise?> getExercise(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<RSExercise>> getExercisesForCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _exercises
        .where((e) => e.courseId == courseId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<Map<String, dynamic>> getExerciseProgress(String exerciseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final ex = _exercises.where((e) => e.id == exerciseId).firstOrNull;
    if (ex == null) {
      return {'bestScore': 0, 'avgScore': 0.0, 'attempts': 0};
    }
    final attempts = (ex.order * 3) + 1;
    final bestScore = 70 + (ex.order * 5);
    final avgScore = bestScore - 8.0;
    return {
      'bestScore': bestScore.clamp(0, 100),
      'avgScore': avgScore.clamp(0.0, 100.0),
      'attempts': attempts,
    };
  }

  Future<Map<String, int>> getCourseProgress(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final course = _courses.where((c) => c.id == courseId).firstOrNull;
    if (course == null) return {'completed': 0, 'total': 0};
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
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_notifications);
  }

  Future<void> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].markRead();
    }
  }

  Future<void> dismiss(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.removeWhere((n) => n.id == id);
  }
}

// ─── USER REPOSITORY ────────────────────────────────────────────────────────

class UserRepository {
  RSPreferences _preferences = const RSPreferences();

  Future<RSPreferences> getPreferences() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _preferences;
  }

  Future<void> savePreferences(RSPreferences prefs) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _preferences = prefs;
  }

  Future<String> exportData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '{"export": "RehabSense User Data", "version": "2.0"}';
  }

  Future<void> clearLocalSessions() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

// ─── SAMPLE DATA GENERATORS ─────────────────────────────────────────────────

List<RSSession> _buildSampleSessions() {
  final now = DateTime.now();
  return [
    RSSession(
      id: 'sess_001',
      userId: 'user_001',
      exerciseId: 'knee_mini_squat',
      startedAt: now.subtract(const Duration(hours: 2)),
      endedAt: now.subtract(const Duration(hours: 1, minutes: 57)),
      status: SessionStatus.saved,
      score: 86,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 88, durationMs: 2100),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 91, durationMs: 2300),
        RSRep(index: 3, outcome: RepOutcome.correct, peakAngle: 89, durationMs: 2200),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 90, durationMs: 2150),
        RSRep(index: 5, outcome: RepOutcome.incorrect, peakAngle: 72, durationMs: 1900, feedbackKey: 'valgus'),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 92, durationMs: 2400),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 90, durationMs: 2200),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 89, durationMs: 2100),
        RSRep(index: 9, outcome: RepOutcome.incorrect, peakAngle: 68, durationMs: 1800, feedbackKey: 'trunk_lean'),
        RSRep(index: 10, outcome: RepOutcome.incomplete, durationMs: 1000, feedbackKey: 'interrupted'),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 2, seconds: 45),
        avgRom: 88.0,
        tempo: 2.8,
        symmetry: 0.94,
      ),
    ),
    RSSession(
      id: 'sess_002',
      userId: 'user_001',
      exerciseId: 'shoulder_pendulum_swing',
      startedAt: now.subtract(const Duration(days: 1, hours: 3)),
      endedAt: now.subtract(const Duration(days: 1, hours: 2, minutes: 56)),
      status: SessionStatus.saved,
      score: 92,
      reps: List.generate(
        10,
        (i) => RSRep(
          index: i + 1,
          outcome: RepOutcome.correct,
          peakAngle: 45,
          durationMs: 3000,
        ),
      ),
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 3, seconds: 30),
        avgRom: 45.0,
        tempo: 3.0,
        symmetry: 0.98,
      ),
    ),
    RSSession(
      id: 'sess_003',
      userId: 'user_001',
      exerciseId: 'knee_straight_leg_raise',
      startedAt: now.subtract(const Duration(days: 2, hours: 5)),
      endedAt: now.subtract(const Duration(days: 2, hours: 4, minutes: 57)),
      status: SessionStatus.saved,
      score: 78,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 45, durationMs: 2500),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 44, durationMs: 2600),
        RSRep(index: 3, outcome: RepOutcome.incorrect, peakAngle: 30, durationMs: 2100, feedbackKey: 'range'),
        RSRep(index: 4, outcome: RepOutcome.correct, peakAngle: 46, durationMs: 2700),
        RSRep(index: 5, outcome: RepOutcome.incorrect, peakAngle: 32, durationMs: 2000, feedbackKey: 'range'),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 45, durationMs: 2500),
        RSRep(index: 7, outcome: RepOutcome.correct, peakAngle: 43, durationMs: 2400),
        RSRep(index: 8, outcome: RepOutcome.incorrect, peakAngle: 35, durationMs: 2200, feedbackKey: 'range'),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 45, durationMs: 2500),
        RSRep(index: 10, outcome: RepOutcome.correct, peakAngle: 44, durationMs: 2600),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 2, seconds: 50),
        avgRom: 42.0,
        tempo: 2.5,
        symmetry: 0.88,
      ),
    ),
    RSSession(
      id: 'sess_004',
      userId: 'user_001',
      exerciseId: 'shoulder_flexion',
      startedAt: now.subtract(const Duration(days: 4, hours: 2)),
      endedAt: now.subtract(const Duration(days: 4, hours: 1, minutes: 56)),
      status: SessionStatus.saved,
      score: 80,
      reps: const [
        RSRep(index: 1, outcome: RepOutcome.correct, peakAngle: 140, durationMs: 2800),
        RSRep(index: 2, outcome: RepOutcome.correct, peakAngle: 142, durationMs: 2900),
        RSRep(index: 3, outcome: RepOutcome.correct, peakAngle: 138, durationMs: 2700),
        RSRep(index: 4, outcome: RepOutcome.incorrect, peakAngle: 120, durationMs: 2400, feedbackKey: 'range'),
        RSRep(index: 5, outcome: RepOutcome.correct, peakAngle: 145, durationMs: 3000),
        RSRep(index: 6, outcome: RepOutcome.correct, peakAngle: 140, durationMs: 2800),
        RSRep(index: 7, outcome: RepOutcome.incorrect, peakAngle: 115, durationMs: 2300, feedbackKey: 'shrug'),
        RSRep(index: 8, outcome: RepOutcome.correct, peakAngle: 141, durationMs: 2900),
        RSRep(index: 9, outcome: RepOutcome.correct, peakAngle: 143, durationMs: 2950),
        RSRep(index: 10, outcome: RepOutcome.correct, peakAngle: 139, durationMs: 2850),
      ],
      metrics: const RSSessionMetrics(
        duration: Duration(minutes: 3, seconds: 10),
        avgRom: 136.0,
        tempo: 2.9,
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
