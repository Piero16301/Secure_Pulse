import 'package:flutter/material.dart';
import 'data/factories/repo_factory.dart';
import 'presentation/controllers/items_controller.dart';
import 'presentation/controllers/security_controller.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/security_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const currentEnv = Environment.local;

  final itemsRepository = RepoFactory.createItemsRepository(currentEnv);
  final itemsController = ItemsController(itemsRepository);

  final securityRepository = RepoFactory.createSecurityRepository(currentEnv);
  final securityController = SecurityController(securityRepository);

  runApp(
    SecurePulseApp(
      itemsController: itemsController,
      securityController: securityController,
    ),
  );
}

class SecurePulseApp extends StatelessWidget {
  const SecurePulseApp({
    super.key,
    required this.itemsController,
    required this.securityController,
  });

  final ItemsController itemsController;
  final SecurityController securityController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SecurePulse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerColor: Colors.transparent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(controller: itemsController),
        '/security': (context) =>
            SecurityScreen(controller: securityController),
      },
    );
  }
}
