import 'package:flutter_test/flutter_test.dart';

Future<void> tocoElTexto(WidgetTester tester, String texto) async {
  await tester.tap(find.text(texto));
  await tester.pumpAndSettle();
}
