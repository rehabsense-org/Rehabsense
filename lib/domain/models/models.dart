// ---------------------------------------------------------------------------
// DOMAIN MODELS — RehabSense
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';

// ─── USER ───────────────────────────────────────────────────────────────────
class RSUser {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? ageRange;
  final String? goal;
  final DateTime createdAt;

  const RSUser({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerified = false,
    this.ageRange,
    this.goal,
    required this.createdAt,
  });

  RSUser copyWith({
    String? name,
    String? email,
    bool? emailVerified,
    String? ageRange,
    String? goal,
  }) =>
      RSUser(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
        ageRange: ageRange ?? this.ageRange,
        goal: goal ?? this.goal,
        createdAt: createdAt,
      );
}

// ─── PREFERENCES ────────────────────────────────────────────────────────────
class RSPreferences {
  final bool audio;
  final bool haptics;
  final bool showSkeleton;
  final bool remindersEnabled;
  final TimeOfDay? reminderTime;
  final List<int> reminderDays; // 1=Mon..7=Sun
  final bool weeklySummary;
  final bool tips;

  const RSPreferences({
    this.audio = true,
    this.haptics = true,
    this.showSkeleton = true,
    this.remindersEnabled = false,
    this.reminderTime,
    this.reminderDays = const [1, 3, 5],
    this.weeklySummary = true,
    this.tips = true,
  });

  RSPreferences copyWith({
    bool? audio,
    bool? haptics,
    bool? showSkeleton,
    bool? remindersEnabled,
    TimeOfDay? reminderTime,
    List<int>? reminderDays,
    bool? weeklySummary,
    bool? tips,
  }) =>
      RSPreferences(
        audio: audio ?? this.audio,
        haptics: haptics ?? this.haptics,
        showSkeleton: showSkeleton ?? this.showSkeleton,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        reminderTime: reminderTime ?? this.reminderTime,
        reminderDays: reminderDays ?? this.reminderDays,
        weeklySummary: weeklySummary ?? this.weeklySummary,
        tips: tips ?? this.tips,
      );
}

// ─── COURSE ─────────────────────────────────────────────────────────────────
class RSCourse {
  final String id;
  final String name;
  final String description;
  final String level;
  final List<String> exerciseIds;
  final String icon; // Lucide icon name

  const RSCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.exerciseIds,
    required this.icon,
  });
}

// ─── EXERCISE ───────────────────────────────────────────────────────────────
class RSExercise {
  final String id;
  final String courseId;
  final int order;
  final String name;
  final int targetReps;
  final int targetSets;
  final int restSeconds;
  final List<String> joints;
  final List<String> steps;
  final List<String> watchOutFor;
  final String whatItHelps;

  const RSExercise({
    required this.id,
    required this.courseId,
    required this.order,
    required this.name,
    required this.targetReps,
    required this.targetSets,
    required this.restSeconds,
    required this.joints,
    required this.steps,
    required this.watchOutFor,
    required this.whatItHelps,
  });
}

// ─── REP OUTCOME ────────────────────────────────────────────────────────────
enum RepOutcome { correct, incorrect, incomplete }

class RSRep {
  final int index;
  final RepOutcome outcome;
  final double? peakAngle;
  final int durationMs;
  final String? feedbackKey;

  const RSRep({
    required this.index,
    required this.outcome,
    this.peakAngle,
    required this.durationMs,
    this.feedbackKey,
  });
}

// ─── SESSION ────────────────────────────────────────────────────────────────
enum SessionStatus { draft, saved, interrupted }

enum SyncState { local, pending, synced }

class RSSession {
  final String id;
  final String userId;
  final String exerciseId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final SessionStatus status;
  final int score;
  final List<RSRep> reps;
  final RSSessionMetrics? metrics;
  final SyncState syncState;

  const RSSession({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.startedAt,
    this.endedAt,
    this.status = SessionStatus.draft,
    this.score = 0,
    this.reps = const [],
    this.metrics,
    this.syncState = SyncState.local,
  });

  int get correctCount => reps.where((r) => r.outcome == RepOutcome.correct).length;
  int get incorrectCount => reps.where((r) => r.outcome == RepOutcome.incorrect).length;
  int get incompleteCount => reps.where((r) => r.outcome == RepOutcome.incomplete).length;
}

class RSSessionMetrics {
  final Duration duration;
  final double avgRom;
  final double tempo;
  final double symmetry;

  const RSSessionMetrics({
    required this.duration,
    required this.avgRom,
    required this.tempo,
    required this.symmetry,
  });
}

// ─── NOTIFICATION ───────────────────────────────────────────────────────────
enum NotificationType { reminder, milestone, tip }

class RSNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  const RSNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  RSNotification markRead() => RSNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        createdAt: createdAt,
        read: true,
      );
}
