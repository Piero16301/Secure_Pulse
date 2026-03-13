import 'package:flutter_test/flutter_test.dart';

Future<void> veoElTexto(WidgetTester tester, String texto) async {
  expect(find.text(texto), findsWidgets);
}
