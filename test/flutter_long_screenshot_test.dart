import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_long_screenshot/flutter_long_screenshot.dart';

void main() {
  testWidgets('Screenshot capture test', (WidgetTester tester) async {
    // Create a test widget with a GlobalKey
    final GlobalKey screenshotKey = GlobalKey();

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: screenshotKey,
            child: Container(width: 100, height: 100, color: Colors.blue),
          ),
        ),
      ),
    );

    // Verify the widget is built
    expect(find.byType(Container), findsOneWidget);

    // Test screenshot capture
    try {
      final Uint8List imageData =
          await FlutterLongScreenshot.captureLongScreenshot(
            key: screenshotKey,
            pixelRatio: 1.0,
          );
      expect(imageData, isNotEmpty);
    } catch (e) {
      fail('Screenshot capture failed: $e');
    }
  });
}
