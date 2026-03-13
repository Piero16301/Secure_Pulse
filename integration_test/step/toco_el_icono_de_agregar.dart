import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tocoElIconoDeAgregar(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
}
