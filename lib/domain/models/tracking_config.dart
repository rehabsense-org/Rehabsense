enum TrackingType { rep, hold }

class TrackingConfig {
  final String joint;
  final TrackingType type;
  final double startAngle;
  final double targetAngle;
  final double tolerance;
  final double minAngle;
  final double maxAngle;
  final int holdSeconds;
  final int graceSeconds;
  final List<int>? leftLandmarks;
  final List<int>? rightLandmarks;

  const TrackingConfig({
    required this.joint,
    required this.type,
    this.startAngle = 170.0,
    this.targetAngle = 120.0,
    this.tolerance = 15.0,
    this.minAngle = 80.0,
    this.maxAngle = 100.0,
    this.holdSeconds = 30,
    this.graceSeconds = 2,
    this.leftLandmarks,
    this.rightLandmarks,
  });

  bool get isValid {
    if (joint.isEmpty) return false;
    if (type == TrackingType.rep) {
      return (startAngle - targetAngle).abs() >= 10.0;
    } else {
      return minAngle < maxAngle && holdSeconds > 0;
    }
  }

  // Squat default fallback (preserves original behavior 100%)
  static const TrackingConfig defaultSquat = TrackingConfig(
    joint: 'knee',
    type: TrackingType.rep,
    startAngle: 160.0,
    targetAngle: 110.0,
    tolerance: 15.0,
    leftLandmarks: [23, 25, 27],
    rightLandmarks: [24, 26, 28],
  );

  // Wall sit / yoga hold default fallback
  static const TrackingConfig defaultHold = TrackingConfig(
    joint: 'knee',
    type: TrackingType.hold,
    minAngle: 80.0,
    maxAngle: 100.0,
    holdSeconds: 20,
    graceSeconds: 2,
    leftLandmarks: [23, 25, 27],
    rightLandmarks: [24, 26, 28],
  );

  factory TrackingConfig.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String? ?? 'rep').toLowerCase();
    final type = typeStr == 'hold' ? TrackingType.hold : TrackingType.rep;

    List<int>? parseLandmarks(dynamic raw) {
      if (raw is List) {
        return raw.map((e) => (e as num).toInt()).toList();
      }
      return null;
    }

    final landmarksMap = json['landmarks'] as Map<String, dynamic>?;

    return TrackingConfig(
      joint: json['joint'] as String? ?? 'knee',
      type: type,
      startAngle: (json['start_angle'] as num?)?.toDouble() ?? 170.0,
      targetAngle: (json['target_angle'] as num?)?.toDouble() ?? 120.0,
      tolerance: (json['tolerance'] as num?)?.toDouble() ?? 15.0,
      minAngle: (json['min_angle'] as num?)?.toDouble() ?? 80.0,
      maxAngle: (json['max_angle'] as num?)?.toDouble() ?? 100.0,
      holdSeconds: (json['hold_seconds'] as num?)?.toInt() ?? 30,
      graceSeconds: (json['grace_seconds'] as num?)?.toInt() ?? 2,
      leftLandmarks: parseLandmarks(landmarksMap?['left']),
      rightLandmarks: parseLandmarks(landmarksMap?['right']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joint': joint,
      'type': type == TrackingType.hold ? 'hold' : 'rep',
      'start_angle': startAngle,
      'target_angle': targetAngle,
      'tolerance': tolerance,
      'min_angle': minAngle,
      'max_angle': maxAngle,
      'hold_seconds': holdSeconds,
      'grace_seconds': graceSeconds,
      'landmarks': {
        if (leftLandmarks != null) 'left': leftLandmarks,
        if (rightLandmarks != null) 'right': rightLandmarks,
      },
    };
  }
}

