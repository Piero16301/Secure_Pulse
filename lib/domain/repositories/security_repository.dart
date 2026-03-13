import '../entities/security_summary.dart';

abstract class SecurityRepository {
  Future<List<SecuritySummary>> getScanHistory();
}
