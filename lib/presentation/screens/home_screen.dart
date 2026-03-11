import 'package:flutter/material.dart';
import '../../domain/entities/security_item.dart';
import '../controllers/items_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final ItemsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecurePulse'),
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (String value) {
                  if (value == 'all') {
                    controller.setFilter(null);
                  } else if (value == 'pending') {
                    controller.setFilter(ItemStatus.pending);
                  } else if (value == 'resolved') {
                    controller.setFilter(ItemStatus.resolved);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'all', child: Text('Todos')),
                  const PopupMenuItem(
                    value: 'pending',
                    child: Text('Pendientes'),
                  ),
                  const PopupMenuItem(
                    value: 'resolved',
                    child: Text('Resueltos'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = controller.filteredItems;

          if (items.isEmpty) {
            return const Center(child: Text('No hay elementos'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isResolved = item.status == ItemStatus.resolved;

              return ListTile(
                title: Text(
                  item.title,
                  style: TextStyle(
                    decoration: isResolved ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  'Prioridad ${item.severity} - ${item.description}',
                ),
                leading: Checkbox(
                  value: isResolved,
                  onChanged: (_) => controller.toggleStatus(item),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteItem(item.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value != null && value.trim().isEmpty
                    ? 'El título no puede estar vacío'
                    : null,
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.createItem(
                  titleController.text.trim(),
                  descController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
