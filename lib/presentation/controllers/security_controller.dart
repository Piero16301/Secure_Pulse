import 'package:flutter/foundation.dart';
import '../../domain/entities/security_summary.dart';
import '../../domain/repositories/security_repository.dart';

class SecurityController extends ChangeNotifier {
  SecurityController(this._repository) {
    loadSummary();
  }

  final SecurityRepository _repository;

  SecuritySummary? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  SecuritySummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSummary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _summary = await _repository.getLastScan();
    } catch (e) {
      _errorMessage = "Error al cargar el reporte de MobSF: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
