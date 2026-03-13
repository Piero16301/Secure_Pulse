import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> tocoElIconoDeFiltro(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.filter_list));
  await tester.pumpAndSettle();
}
