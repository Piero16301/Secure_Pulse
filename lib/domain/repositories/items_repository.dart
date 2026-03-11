import '../entities/security_item.dart';

abstract class ItemsRepository {
  Future<List<SecurityItem>> getItems();
  Future<void> addItem(SecurityItem item);
  Future<void> updateItem(SecurityItem item);
  Future<void> deleteItem(String id);
}
