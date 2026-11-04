enum AssignmentStatus { active, completed, paused }

class RSAssignment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientId;
  final String exerciseId;
  final String exerciseName;
  final int targetReps;
  final int targetSets;
  final int? holdSeconds;
  final int frequencyDaysPerWeek;
  final String scheduleDescription;
  final String? doctorNotes;
  final AssignmentStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;

  const RSAssignment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientId,
    required this.exerciseId,
    required this.exerciseName,
    required this.targetReps,
    required this.targetSets,
    this.holdSeconds,
    this.frequencyDaysPerWeek = 3,
    this.scheduleDescription = 'Mon, Wed, Fri',
    this.doctorNotes,
    this.status = AssignmentStatus.active,
    required this.startDate,
    this.endDate,
    required this.createdAt,
  });

  factory RSAssignment.fromJson(Map<String, dynamic> json) {
    AssignmentStatus parseStatus(String? s) {
      switch (s) {
        case 'completed':
          return AssignmentStatus.completed;
        case 'paused':
          return AssignmentStatus.paused;
        case 'active':
        default:
          return AssignmentStatus.active;
      }
    }

    return RSAssignment(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String? ?? '',
      doctorName: json['doctor_name'] as String? ?? 'Dr. Sara Khan',
      patientId: json['patient_id'] as String? ?? '',
      exerciseId: json['exercise_id'] as String? ?? '',
      exerciseName: json['exercise_name'] as String? ?? 'Prescribed Exercise',
      targetReps: (json['target_reps'] as num?)?.toInt() ?? 10,
      targetSets: (json['target_sets'] as num?)?.toInt() ?? 3,
      holdSeconds: (json['hold_seconds'] as num?)?.toInt(),
      frequencyDaysPerWeek: (json['frequency_days_per_week'] as num?)?.toInt() ?? 3,
      scheduleDescription: json['schedule_description'] as String? ?? 'Mon, Wed, Fri',
      doctorNotes: json['doctor_notes'] as String?,
      status: parseStatus(json['status'] as String?),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'patient_id': patientId,
        'exercise_id': exerciseId,
        'exercise_name': exerciseName,
        'target_reps': targetReps,
        'target_sets': targetSets,
        'hold_seconds': holdSeconds,
        'frequency_days_per_week': frequencyDaysPerWeek,
        'schedule_description': scheduleDescription,
        'doctor_notes': doctorNotes,
        'status': status.name,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };
}

