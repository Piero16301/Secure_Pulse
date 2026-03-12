import 'package:flutter/material.dart';
import 'data/factories/repo_factory.dart';
import 'presentation/controllers/items_controller.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const currentEnv = Environment.local;

  final repository = RepoFactory.createItemsRepository(currentEnv);
  final controller = ItemsController(repository);

  runApp(SecurePulseApp(controller: controller));
}

class SecurePulseApp extends StatelessWidget {
  const SecurePulseApp({super.key, required this.controller});

  final ItemsController controller;

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
      ),
      home: HomeScreen(controller: controller),
    );
  }
}
