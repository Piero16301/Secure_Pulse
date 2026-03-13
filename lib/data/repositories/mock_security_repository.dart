import 'package:secure_pulse/domain/repositories/security_repository.dart';

import '../../domain/entities/security_summary.dart';

class MockSecurityRepository implements SecurityRepository {
  @override
  Future<SecuritySummary> getLastScan() async {
    await Future.delayed(const Duration(seconds: 1));
    return SecuritySummary(
      scanDate: DateTime.now(),
      apkHash: 'test_hash_123',
      status: 'FAIL',
      score: 40,
      findings: [
        SecurityFinding(
          title: "Vulnerabilidad inyectada para testing",
          severity: "high",
        ),
      ],
    );
  }
}
