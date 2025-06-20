// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_long_screenshot_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('screenshot capture test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the app is running
      expect(find.byType(app.LongScreenshotDemo), findsOneWidget);

      // Find the screenshot button and tap it
      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pumpAndSettle();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for screenshot process to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify success message is shown
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
