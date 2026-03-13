import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> veoElIconoDeError(WidgetTester tester) async {
  expect(find.byIcon(Icons.error), findsOneWidget);
}
