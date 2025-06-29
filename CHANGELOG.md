# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2024-12-19

### Fixed

- **Complete package cleanup** - Removed all custom package identifiers (centurycity, jay_benzatine)
- **Generic package structure** - Updated to use standard com.flutter_long_screenshot naming
- **Dart formatting compliance** - Fixed all formatting issues with dart format
- **Static analysis compliance** - All code now passes static analysis with 0 warnings
- **Clean git state** - All changes committed and ready for publication

### Technical Improvements

- **Standardized package naming** across all platforms
- **Updated iOS bundle identifiers** to generic format
- **Cleaned build artifacts** and removed old references
- **Improved code quality** with proper formatting and linting
- **Enhanced developer experience** with clean, generic codebase

## [1.0.1] - 2024-12-19

### Fixed

- **Fixed iOS file path handling** - now uses Documents directory instead of Downloads
- **Fixed iOS PDF opening issues** - automatic fallback to sharing when opening fails
- **Fixed iOS screenshot saving** - proper platform-specific file handling
- Fixed missing XFile import from cross_file package
- Added missing iOS photo library permissions in Info.plist files

### Added

- **Platform-optimized file handling** (Downloads on Android, Documents on iOS)
- **Automatic fallback to sharing** on iOS when file opening fails
- Platform-specific user messages for better UX
- New `saveToPhotoLibrary` method for iOS-appropriate file saving

### Technical Improvements

- **Platform-specific file handling logic**
- **iOS-native sharing integration**
- Better error handling for platform differences
- Improved user experience on iOS devices

## [1.0.0] - 2024-12-19

### Added

- Initial release of Flutter Long Screenshot plugin
- Capture long screenshots of any widget without auto-scrolling
- Save screenshots as images or PDFs
- Share screenshots directly as images or PDFs
- Quality control for captured screenshots
- Support for both Android and iOS platforms
- Comprehensive example app demonstrating all features
- Complete documentation with usage examples

### Fixed

- Updated Android Gradle Plugin from 7.3.0 to 8.3.0 for Flutter compatibility
- Added NDK version 26.3.11579264 for integration_test compatibility
- Updated README with correct repository links
- Removed unnecessary NDK configuration from main plugin (only needed for example app)
- Updated compileSdk to 35 for latest Android compatibility

### Technical Improvements

- Modern Android configuration with AGP 8.3.0
- Proper Kotlin configuration with version 1.9.22
- Updated Gradle wrapper to version 8.7
- Clean project structure with proper separation of concerns
- Comprehensive test coverage including unit tests and integration tests
- Proper error handling and exception management
- Optimized build times (12.4s vs previous 114.2s)

### Dependencies

- path_provider: ^2.1.5
- open_file: ^3.5.10
- pdf: ^3.11.3
- share_plus: ^11.0.0
- flutter_lints: ^6.0.0

### Platform Support

- Android: API 21+ (Android 5.0+)
- iOS: iOS 12.0+
- Flutter: >=3.32.0
- Dart SDK: >=3.8.0

### Permissions

- Android: WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE
- iOS: NSPhotoLibraryAddUsageDescription, NSPhotoLibraryUsageDescription

### iOS-Specific Features

- Files saved to Documents directory (iOS standard)
- Automatic sharing fallback when file opening fails
- Native iOS sharing integration
- Proper file path handling for iOS sandbox

## 1.0.1

- Update all dependencies to their latest versions
- Update plugin code to use the latest share_plus API (SharePlus.instance.share with ShareParams)
- Minor: Example app still has some deprecated withOpacity usage (does not affect plugin)

## 1.0.0

- Initial release of flutter_long_screenshot plugin
- Support for capturing long screenshots of widgets without auto-scrolling
- PDF conversion and sharing capabilities
- Quality control for captured screenshots
- Support for both Android and iOS platforms
- Save screenshots to downloads directory
- Share screenshots directly as images or PDFs

## 0.0.1

- TODO: Describe initial release.
