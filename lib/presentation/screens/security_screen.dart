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
        title: const Text('Último Escaneo MobSF'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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

          final summary = controller.summary;
          if (summary == null) {
            return const Center(child: Text('No hay datos de escaneo'));
          }

          final isFail = summary.status == 'FAIL';

          return Column(
            children: [
              if (isFail)
                Container(
                  key: const Key('fail_banner'),
                  width: double.infinity,
                  color: Colors.red.shade100,
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESTADO: ${summary.status}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Score: ${summary.score}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Hash: ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: summary.apkHash,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Fecha: ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat(
                                'dd/MM/yyyy HH:mm:ss',
                              ).format(summary.scanDate.toLocal()),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Hallazgos Principales',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: summary.findings.length,
                  itemBuilder: (context, index) {
                    final finding = summary.findings[index];
                    return ListTile(
                      title: Text(
                        finding.title,
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(
                            finding.severity,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getSeverityColor(finding.severity),
                          ),
                        ),
                        child: Text(
                          finding.severity.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getSeverityColor(finding.severity),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
