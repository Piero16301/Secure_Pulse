import 'package:flutter/foundation.dart';
import '../../domain/entities/security_item.dart';
import '../../domain/repositories/items_repository.dart';

class ItemsController extends ChangeNotifier {
  final ItemsRepository _repository;

  List<SecurityItem> _items = [];
  bool _isLoading = false;
  ItemStatus? _currentFilter;

  List<SecurityItem> get items => _items;
  bool get isLoading => _isLoading;
  ItemStatus? get currentFilter => _currentFilter;

  ItemsController(this._repository) {
    loadItems();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _repository.getItems();
    } catch (e) {
      debugPrint("Error loading items: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createItem(String title, String description) async {
    if (title.isEmpty) return;

    final newItem = SecurityItem(
      id: DateTime.now().toString(),
      title: title,
      description: description,
    );

    await _repository.addItem(newItem);
    await loadItems();
  }

  Future<void> toggleStatus(SecurityItem item) async {
    final newStatus = item.status == ItemStatus.pending
        ? ItemStatus.resolved
        : ItemStatus.pending;

    final updatedItem = item.copyWith(status: newStatus);
    await _repository.updateItem(updatedItem);
    await loadItems();
  }

  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
    await loadItems();
  }

  List<SecurityItem> get filteredItems {
    if (_currentFilter == null) return _items;
    return _items.where((item) => item.status == _currentFilter).toList();
  }

  void setFilter(ItemStatus? newFilter) {
    _currentFilter = newFilter;
    notifyListeners();
  }
}
