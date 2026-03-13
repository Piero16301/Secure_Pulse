import 'package:flutter/foundation.dart';
import '../../domain/entities/security_item.dart';
import '../../domain/repositories/items_repository.dart';

class CacheItemsRepositoryDecorator implements ItemsRepository {
  CacheItemsRepositoryDecorator(this._innerRepository);

  final ItemsRepository _innerRepository;

  List<SecurityItem>? _cachedItems;

  @override
  Future<List<SecurityItem>> getItems() async {
    if (_cachedItems != null) {
      debugPrint('[CACHE] ⚡ Devolviendo datos en memoria (0ms)');
      return _cachedItems!;
    }

    debugPrint('[CACHE] 🐌 Caché vacía. Delegando al repositorio interno...');
    _cachedItems = await _innerRepository.getItems();
    return _cachedItems!;
  }

  @override
  Future<void> addItem(SecurityItem item) async {
    await _innerRepository.addItem(item);
    _invalidateCache();
  }

  @override
  Future<void> updateItem(SecurityItem item) async {
    await _innerRepository.updateItem(item);
    _invalidateCache();
  }

  @override
  Future<void> deleteItem(String id) async {
    await _innerRepository.deleteItem(id);
    _invalidateCache();
  }

  void _invalidateCache() {
    debugPrint('[CACHE] 🧹 Caché invalidada por cambio en los datos');
    _cachedItems = null;
  }
}
