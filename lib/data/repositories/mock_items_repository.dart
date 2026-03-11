import '../../domain/entities/security_item.dart';
import '../../domain/repositories/items_repository.dart';

class MockItemsRepository implements ItemsRepository {
  final List<SecurityItem> _items = [];

  @override
  Future<List<SecurityItem>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _items.toList();
  }

  @override
  Future<void> addItem(SecurityItem item) async {
    _items.add(item);
  }

  @override
  Future<void> updateItem(SecurityItem item) async {
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((e) => e.id == id);
  }
}
