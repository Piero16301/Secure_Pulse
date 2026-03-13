import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> marcoLaCasillaDelItem(WidgetTester tester, String texto) async {
  final listTileFinder = find.ancestor(
    of: find.text(texto),
    matching: find.byType(ListTile),
  );

  final checkboxFinder = find.descendant(
    of: listTileFinder,
    matching: find.byType(Checkbox),
  );

  await tester.tap(checkboxFinder);
  await tester.pumpAndSettle();
}
