import 'package:flutter_test/flutter_test.dart';
import 'package:secure_pulse/main.dart' as app;
import 'package:secure_pulse/data/factories/repo_factory.dart';
import 'package:secure_pulse/presentation/controllers/items_controller.dart';
import 'package:secure_pulse/presentation/controllers/security_controller.dart';

Future<void> laAplicacionEstaIniciada(WidgetTester tester) async {
  final itemsRepository = RepoFactory.createItemsRepository(Environment.mock);
  final itemsController = ItemsController(itemsRepository);

  final securityRepository = RepoFactory.createSecurityRepository(
    Environment.mock,
  );
  final securityController = SecurityController(securityRepository);

  await tester.pumpWidget(
    app.SecurePulseApp(
      itemsController: itemsController,
      securityController: securityController,
    ),
  );
  await tester.pumpAndSettle();
}
