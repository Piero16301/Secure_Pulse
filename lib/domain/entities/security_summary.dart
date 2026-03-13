class SecurityFinding {
  SecurityFinding({
    required this.title,
    required this.description,
    required this.severity,
  });

  final String title;
  final String description;
  final String severity;
}

class SecuritySummary {
  SecuritySummary({
    required this.scanDate,
    required this.apkHash,
    required this.status,
    required this.score,
    required this.findings,
  });

  final DateTime scanDate;
  final String apkHash;
  final String status;
  final int score;
  final List<SecurityFinding> findings;
}
