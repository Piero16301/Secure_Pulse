import '../../domain/entities/security_summary.dart';

class MobSfSummaryAdapter {
  static SecuritySummary fromJson(Map<String, dynamic> json) {
    final findingsList = json['findings'] as List<dynamic>? ?? [];

    final findings = findingsList
        .map(
          (f) => SecurityFinding(
            title: f['title'] ?? 'Hallazgo desconocido',
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
}
