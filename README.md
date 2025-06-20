# Flutter Long Screenshot

A Flutter plugin for capturing long screenshots of widgets without auto-scrolling, with support for PDF conversion and sharing.

## Features

- Capture long screenshots of any widget
- Save screenshots as images or PDFs
- Share screenshots directly as images or PDFs
- Quality control for captured screenshots
- Support for both Android and iOS
- **Platform-optimized file handling** (Downloads on Android, Documents on iOS)
- **Automatic fallback to sharing** on iOS when file opening fails

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_long_screenshot: ^1.0.1
```

## Usage

1. Add a `RepaintBoundary` widget with a `GlobalKey`:

```dart
final GlobalKey _screenshotKey = GlobalKey();

// In your build method:
RepaintBoundary(
  key: _screenshotKey,
  child: YourWidget(),
)
```

2. Capture and save a screenshot:

```dart
// Capture screenshot
final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(
  key: _screenshotKey,
  pixelRatio: 3.0,
  quality: 1.0,
);

// Save as image (platform-optimized)
final String imagePath = await FlutterLongScreenshot.saveToDownloadsAndOpen(
  imageData: imageData,
  fileName: 'screenshot_${DateTime.now().millisecondsSinceEpoch}',
);

// Save as PDF (platform-optimized)
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

## Platform Differences

### Android

- Files are saved to the Downloads directory
- Files can be opened directly with system apps
- Full file path access

### iOS

- Files are saved to the Documents directory
- If file opening fails, automatically falls back to sharing
- Uses iOS-native sharing mechanisms
- Better integration with iOS file management

## Required Permissions

### Android

Add these permissions to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS

Add these keys to your `Info.plist`:

```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to save screenshots to your photo library</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to save screenshots to your photo library</string>
```

## Example

Check out the [example](https://github.com/jay-benzatine/flutter_long_screenshot/tree/main/example) directory for a complete working example.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
