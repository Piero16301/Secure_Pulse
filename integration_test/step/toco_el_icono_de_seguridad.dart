import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tocoElIconoDeSeguridad(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.security));
  await tester.pumpAndSettle();
}
