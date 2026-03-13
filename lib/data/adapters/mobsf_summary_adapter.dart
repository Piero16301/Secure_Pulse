import '../../domain/entities/security_summary.dart';

class MobSfSummaryAdapter {
  static SecuritySummary fromJson(Map<String, dynamic> json) {
    final findingsList = json['findings'] as List<dynamic>? ?? [];

    final findings = findingsList
        .map(
          (f) => SecurityFinding(
            title: f['title'] ?? 'Hallazgo desconocido',
            description: f['description'] ?? '',
            severity: f['severity'] ?? 'info',
          ),
        )
        .toList();

    return SecuritySummary(
      scanDate: DateTime.parse(json['scan_date']),
      apkHash: json['apk_hash'] ?? 'N/A',
      status: json['status'] ?? 'UNKNOWN',
      score: json['score'] ?? 0,
      findings: findings,
    );
  }

  static List<SecuritySummary> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
