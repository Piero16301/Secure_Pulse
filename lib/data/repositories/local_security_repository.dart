import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/repositories/security_repository.dart';
import '../../domain/entities/security_summary.dart';
import '../adapters/mobsf_summary_adapter.dart';

class LocalSecurityRepository implements SecurityRepository {
  @override
  Future<List<SecuritySummary>> getScanHistory() async {
    final String response = await rootBundle.loadString(
      'assets/security_history.json',
    );
    final List<dynamic> data = json.decode(response);

    return MobSfSummaryAdapter.fromJsonList(data);
  }
}
