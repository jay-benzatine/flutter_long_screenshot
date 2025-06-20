#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_long_screenshot.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_long_screenshot'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for capturing long screenshots of widgets without auto-scrolling.'
  s.description      = <<-DESC
A Flutter plugin for capturing long screenshots of widgets without auto-scrolling, with support for PDF conversion and sharing.
                       DESC
  s.homepage         = 'https://github.com/jay-benzatine/flutter_long_screenshot'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jay Benzatine' => 'your-email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_long_screenshot_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
