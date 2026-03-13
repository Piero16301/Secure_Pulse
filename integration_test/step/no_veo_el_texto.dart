import 'package:flutter_test/flutter_test.dart';

Future<void> noVeoElTexto(WidgetTester tester, String texto) async {
  expect(find.text(texto), findsNothing);
}
