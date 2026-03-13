import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/security_controller.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key, required this.controller});

  final SecurityController controller;

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red.shade700;
      case 'warning':
        return Colors.orange.shade800;
      case 'info':
        return Colors.blue.shade600;
      case 'secure':
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Seguridad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadHistory(),
            tooltip: 'Refrescar historial',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.history.isEmpty) {
            return const Center(child: Text('No hay historial disponible.'));
          }

          return ListView.builder(
            itemCount: controller.history.length,
            itemBuilder: (context, index) {
              final summary = controller.history[index];
              final isFail = summary.status == 'FAIL';

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        isFail ? Icons.error : Icons.check_circle,
                        color: isFail ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Escaneo: '
                        '${DateFormat('dd/MM/yyyy hh:mm:ss aa').format(summary.scanDate.toLocal())}',
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Score: ${summary.score} | Hash: ${summary.apkHash}',
                  ),
                  children: summary.findings
                      .map(
                        (finding) => ListTile(
                          title: Text(
                            finding.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          trailing: Tooltip(
                            message: finding.description,
                            margin: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: _getSeverityColor(
                                  finding.severity,
                                ).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                finding.severity.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
