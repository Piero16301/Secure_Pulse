import 'package:flutter/foundation.dart';
import '../../domain/entities/security_summary.dart';
import '../../domain/repositories/security_repository.dart';

class SecurityController extends ChangeNotifier {
  SecurityController(this._repository) {
    loadHistory();
  }

  final SecurityRepository _repository;

  List<SecuritySummary> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SecuritySummary> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _history = await _repository.getScanHistory();
    } catch (e) {
      _errorMessage = "Error al cargar el historial: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
