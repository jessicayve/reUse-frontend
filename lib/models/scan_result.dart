class ScanResult {
  final String objectName;
  final String condition;
  final String decision;
  final String reason;
  final List<String> reuseIdeas;
  final String recyclingTip;
  final double confidence;

  ScanResult({
    required this.objectName,
    required this.condition,
    required this.decision,
    required this.reason,
    required this.reuseIdeas,
    required this.recyclingTip,
    required this.confidence,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      objectName: json['objectName']?.toString() ?? '',
      condition: json['condition']?.toString() ?? '',
      decision: json['decision']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      reuseIdeas: (json['reuseIdeas'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      recyclingTip: json['recyclingTip']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}