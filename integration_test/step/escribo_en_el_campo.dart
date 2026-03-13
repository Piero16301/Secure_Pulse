import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> escriboEnElCampo(
  WidgetTester tester,
  String texto,
  String label,
) async {
  final finder = find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );
  await tester.enterText(finder, texto);
  await tester.pumpAndSettle();
}
