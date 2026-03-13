import 'package:flutter/foundation.dart';
import '../../domain/entities/security_item.dart';
import '../../domain/repositories/items_repository.dart';

class LoggingItemsRepositoryDecorator implements ItemsRepository {
  LoggingItemsRepositoryDecorator(this._innerRepository);

  final ItemsRepository _innerRepository;

  @override
  Future<List<SecurityItem>> getItems() async {
    debugPrint('[LOG - DB] 📝 Obteniendo ítems...');
    final stopwatch = Stopwatch()..start();

    try {
      final result = await _innerRepository.getItems();
      stopwatch.stop();
      debugPrint(
        '[LOG - DB] ✅ getItems() completado en '
        '${stopwatch.elapsedMilliseconds}ms. Retornó ${result.length} ítems.',
      );
      return result;
    } catch (e) {
      debugPrint('[LOG - DB] ❌ Error en getItems(): $e');
      rethrow;
    }
  }

  @override
  Future<void> addItem(SecurityItem item) async {
    debugPrint('[LOG - DB] 📝 Añadiendo ítem: ${item.id} - ${item.title}');
    await _innerRepository.addItem(item);
    debugPrint('[LOG - DB] ✅ addItem() completado.');
  }

  @override
  Future<void> updateItem(SecurityItem item) async {
    debugPrint('[LOG - DB] 📝 Actualizando ítem: ${item.id}');
    await _innerRepository.updateItem(item);
    debugPrint('[LOG - DB] ✅ updateItem() completado.');
  }

  @override
  Future<void> deleteItem(String id) async {
    debugPrint('[LOG - DB] 📝 Eliminando ítem: $id');
    await _innerRepository.deleteItem(id);
    debugPrint('[LOG - DB] ✅ deleteItem() completado.');
  }
}
