import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> veoElBannerRojoDeError(WidgetTester tester) async {
  final bannerFinder = find.byKey(const Key('fail_banner'));
  expect(bannerFinder, findsOneWidget);

  final container = tester.widget<Container>(bannerFinder);
  expect(container.color, Colors.red.shade100);
}
