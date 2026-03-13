import 'package:flutter_test/flutter_test.dart';
import 'package:secure_pulse/main.dart' as app;
import 'package:secure_pulse/data/factories/repo_factory.dart';
import 'package:secure_pulse/presentation/controllers/items_controller.dart';

Future<void> laAplicacionEstaIniciada(WidgetTester tester) async {
  final repository = RepoFactory.createItemsRepository(Environment.mock);
  final controller = ItemsController(repository);
  await tester.pumpWidget(app.SecurePulseApp(controller: controller));
  await tester.pumpAndSettle();
}
