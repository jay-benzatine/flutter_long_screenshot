# Developer Setup Guide

This guide will help you set up and use the Flutter Long Screenshot plugin in your project.

## Prerequisites

- Flutter SDK >= 3.32.0
- Dart SDK >= 3.8.0
- Android Studio / VS Code
- Android SDK (API 21+)
- iOS development tools (for iOS development)

## Installation

### 1. Add Dependency

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_long_screenshot: ^1.0.0
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Platform Configuration

#### Android

The plugin automatically adds the required permissions to your Android manifest. No additional configuration needed.

#### iOS

Add these keys to your `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to save screenshots to your photo library</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to save screenshots to your photo library</string>
```

## Usage

### 1. Import the Plugin

```dart
import 'package:flutter_long_screenshot/flutter_long_screenshot.dart';
```

### 2. Create a GlobalKey

```dart
final GlobalKey _screenshotKey = GlobalKey();
```

### 3. Wrap Your Widget

```dart
RepaintBoundary(
  key: _screenshotKey,
  child: YourWidget(),
)
```

### 4. Capture Screenshot

```dart
// Capture screenshot
final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(
  key: _screenshotKey,
  pixelRatio: 3.0, // Optional: default is 3.0
  quality: 1.0,    // Optional: default is 1.0
);
```

### 5. Save or Share

```dart
// Save as image
final String imagePath = await FlutterLongScreenshot.saveToDownloadsAndOpen(
  imageData: imageData,
  fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}',
);

// Save as PDF
final String pdfPath = await FlutterLongScreenshot.convertToPdfAndSave(
  imageData: imageData,
  fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}',
);

// Share as image
final String sharedImagePath = await FlutterLongScreenshot.shareScreenshot(
  imageData,
  'screenshot_${DateTime.now().millisecondsSinceEpoch}',
);

// Share as PDF
final String sharedPdfPath = await FlutterLongScreenshot.convertToPdfAndShare(
  imageData,
  'screenshot_${DateTime.now().millisecondsSinceEpoch}',
);
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_long_screenshot/flutter_long_screenshot.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final GlobalKey _screenshotKey = GlobalKey();

  Future<void> _captureScreenshot() async {
    try {
      final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(
        key: _screenshotKey,
        pixelRatio: 3.0,
        quality: 1.0,
      );

      final String imagePath = await FlutterLongScreenshot.saveToDownloadsAndOpen(
        imageData: imageData,
        fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved: $imagePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screenshot Example')),
      body: Column(
        children: [
          RepaintBoundary(
            key: _screenshotKey,
            child: Container(
              height: 500,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'This content will be captured',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _captureScreenshot,
            child: Text('Capture Screenshot'),
          ),
        ],
      ),
    );
  }
}
```

## Troubleshooting

### Common Issues

1. **Build Errors**: Ensure you're using Flutter >= 3.32.0 and Dart >= 3.8.0
2. **Permission Errors**: Make sure you've added the required permissions for your platform
3. **File Access Errors**: The plugin requires storage permissions to save files

### Build Configuration

The plugin is configured with:

- Android Gradle Plugin: 8.3.0
- Kotlin: 1.9.22
- Gradle: 8.7
- compileSdk: 35
- minSdk: 21

### Testing

Run the example app to test all features:

```bash
cd example
flutter run
```

## Support

If you encounter any issues:

1. Check the [example](https://github.com/jay-benzatine/flutter_long_screenshot/tree/main/example) directory
2. Review the [README](README.md) for detailed documentation
3. Open an issue on GitHub with detailed error information

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request
