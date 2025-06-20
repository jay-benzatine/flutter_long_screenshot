// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_long_screenshot_example/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts with the LongScreenshotDemo
    expect(find.byType(LongScreenshotDemo), findsOneWidget);

    // Verify that the screenshot button is present
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Verify that the content is displayed
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Text), findsWidgets);
  });
}
