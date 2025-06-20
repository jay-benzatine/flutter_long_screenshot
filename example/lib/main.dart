import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_long_screenshot/flutter_long_screenshot.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Long Screenshot Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LongScreenshotDemo(),
    );
  }
}

class LongScreenshotDemo extends StatefulWidget {
  const LongScreenshotDemo({super.key});

  @override
  State<LongScreenshotDemo> createState() => _LongScreenshotDemoState();
}

class _LongScreenshotDemoState extends State<LongScreenshotDemo> {
  final GlobalKey _screenshotKey = GlobalKey();
  double _quality = 1.0;
  bool _isCapturing = false;

  Future<void> _showSaveOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text('Save Screenshot', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Image Quality', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _quality,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: '${(_quality * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _quality = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          '${(_quality * 100).round()}%',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildOptionButton(
                    context,
                    icon: Icons.image,
                    label: 'Save as Image',
                    onTap: () {
                      Navigator.pop(context);
                      _captureAndSaveToDownloads();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    context,
                    icon: Icons.share,
                    label: 'Share as Image',
                    onTap: () {
                      Navigator.pop(context);
                      _captureAndShareImage();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    context,
                    icon: Icons.picture_as_pdf,
                    label: 'Save as PDF',
                    onTap: () {
                      Navigator.pop(context);
                      _captureAndSaveAsPdf();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildOptionButton(
                    context,
                    icon: Icons.share,
                    label: 'Share as PDF',
                    onTap: () {
                      Navigator.pop(context);
                      _captureAndSharePdf();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndSharePdf() async {
    _setCapturing(true);
    try {
      // Capture the screenshot
      final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(key: _screenshotKey, pixelRatio: 3.0, quality: _quality);

      // Convert to PDF and share
      final String pdfPath = await FlutterLongScreenshot.convertToPdfAndShare(imageData, 'long_screenshot_${DateTime.now().millisecondsSinceEpoch}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF shared: $pdfPath'), duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      _setCapturing(false);
    }
  }

  Future<void> _captureAndSaveAsPdf() async {
    _setCapturing(true);
    try {
      // Capture the screenshot
      final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(key: _screenshotKey, pixelRatio: 3.0, quality: _quality);

      // Convert to PDF and save
      final String pdfPath = await FlutterLongScreenshot.convertToPdfAndSave(
        imageData: imageData,
        fileName: 'long_screenshot_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        final String platformMessage = Platform.isIOS ? 'PDF saved to Documents and shared' : 'PDF saved: $pdfPath';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(platformMessage), duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      _setCapturing(false);
    }
  }

  Future<void> _captureAndSaveToDownloads() async {
    _setCapturing(true);
    try {
      // Capture the screenshot
      final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(key: _screenshotKey, pixelRatio: 3.0, quality: _quality);

      // Save using platform-appropriate method
      final String filePath = await FlutterLongScreenshot.saveToDownloadsAndOpen(
        imageData: imageData,
        fileName: 'long_screenshot_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        final String platformMessage = Platform.isIOS ? 'Screenshot saved to Documents and shared' : 'Screenshot saved to Downloads: $filePath';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(platformMessage), duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      _setCapturing(false);
    }
  }

  Future<void> _captureAndShareImage() async {
    _setCapturing(true);
    try {
      // Capture the screenshot
      final Uint8List imageData = await FlutterLongScreenshot.captureLongScreenshot(key: _screenshotKey, pixelRatio: 3.0, quality: _quality);

      // Share the image
      final String imagePath = await FlutterLongScreenshot.shareScreenshot(imageData, 'screenshot_${DateTime.now().millisecondsSinceEpoch}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Screenshot shared: $imagePath'), duration: const Duration(seconds: 3)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      _setCapturing(false);
    }
  }

  void _setCapturing(bool value) {
    setState(() {
      _isCapturing = value;
    });
  }

  Widget _buildLongContent() {
    // Sample user data
    final List<Map<String, dynamic>> users = [
      {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'role': 'Software Engineer',
        'company': 'Tech Solutions Inc.',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'status': 'Active',
        'lastActive': '2 hours ago',
      },
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@example.com',
        'role': 'Product Designer',
        'company': 'Creative Studios',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'status': 'Online',
        'lastActive': 'Just now',
      },
      {
        'name': 'Michael Chen',
        'email': 'm.chen@example.com',
        'role': 'Data Scientist',
        'company': 'AI Research Lab',
        'avatar': 'https://i.pravatar.cc/150?img=8',
        'status': 'Away',
        'lastActive': '30 minutes ago',
      },
      {
        'name': 'Emma Wilson',
        'email': 'emma.w@example.com',
        'role': 'Marketing Manager',
        'company': 'Global Brands',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'status': 'Active',
        'lastActive': '1 hour ago',
      },
      {
        'name': 'David Brown',
        'email': 'd.brown@example.com',
        'role': 'UX Researcher',
        'company': 'User Experience Co.',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'status': 'Offline',
        'lastActive': 'Yesterday',
      },
      {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'role': 'Software Engineer',
        'company': 'Tech Solutions Inc.',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'status': 'Active',
        'lastActive': '2 hours ago',
      },
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@example.com',
        'role': 'Product Designer',
        'company': 'Creative Studios',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'status': 'Online',
        'lastActive': 'Just now',
      },
      {
        'name': 'Michael Chen',
        'email': 'm.chen@example.com',
        'role': 'Data Scientist',
        'company': 'AI Research Lab',
        'avatar': 'https://i.pravatar.cc/150?img=8',
        'status': 'Away',
        'lastActive': '30 minutes ago',
      },
      {
        'name': 'Emma Wilson',
        'email': 'emma.w@example.com',
        'role': 'Marketing Manager',
        'company': 'Global Brands',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'status': 'Active',
        'lastActive': '1 hour ago',
      },
      {
        'name': 'David Brown',
        'email': 'd.brown@example.com',
        'role': 'UX Researcher',
        'company': 'User Experience Co.',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'status': 'Offline',
        'lastActive': 'Yesterday',
      },
      {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'role': 'Software Engineer',
        'company': 'Tech Solutions Inc.',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'status': 'Active',
        'lastActive': '2 hours ago',
      },
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@example.com',
        'role': 'Product Designer',
        'company': 'Creative Studios',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'status': 'Online',
        'lastActive': 'Just now',
      },
      {
        'name': 'Michael Chen',
        'email': 'm.chen@example.com',
        'role': 'Data Scientist',
        'company': 'AI Research Lab',
        'avatar': 'https://i.pravatar.cc/150?img=8',
        'status': 'Away',
        'lastActive': '30 minutes ago',
      },
      {
        'name': 'Emma Wilson',
        'email': 'emma.w@example.com',
        'role': 'Marketing Manager',
        'company': 'Global Brands',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'status': 'Active',
        'lastActive': '1 hour ago',
      },
      {
        'name': 'David Brown',
        'email': 'd.brown@example.com',
        'role': 'UX Researcher',
        'company': 'User Experience Co.',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'status': 'Offline',
        'lastActive': 'Yesterday',
      },
      {
        'name': 'John Smith',
        'email': 'john.smith@example.com',
        'role': 'Software Engineer',
        'company': 'Tech Solutions Inc.',
        'avatar': 'https://i.pravatar.cc/150?img=1',
        'status': 'Active',
        'lastActive': '2 hours ago',
      },
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@example.com',
        'role': 'Product Designer',
        'company': 'Creative Studios',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'status': 'Online',
        'lastActive': 'Just now',
      },
      {
        'name': 'Michael Chen',
        'email': 'm.chen@example.com',
        'role': 'Data Scientist',
        'company': 'AI Research Lab',
        'avatar': 'https://i.pravatar.cc/150?img=8',
        'status': 'Away',
        'lastActive': '30 minutes ago',
      },
      {
        'name': 'Emma Wilson',
        'email': 'emma.w@example.com',
        'role': 'Marketing Manager',
        'company': 'Global Brands',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'status': 'Active',
        'lastActive': '1 hour ago',
      },
      {
        'name': 'David Brown',
        'email': 'd.brown@example.com',
        'role': 'UX Researcher',
        'company': 'User Experience Co.',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'status': 'Offline',
        'lastActive': 'Yesterday',
      },
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Icon(Icons.people, color: Theme.of(context).colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Text(
                  'User Directory',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                const Spacer(),
                Text(
                  '${users.length} Users',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
          // User list
          ...users.map((user) => _buildUserCard(user)),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle user card tap
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected ${user['name']}'), duration: const Duration(seconds: 1)));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile photo
                CircleAvatar(radius: 30, backgroundImage: NetworkImage(user['avatar'])),
                const SizedBox(width: 16),
                // User details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(user['name'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          _buildStatusIndicator(user['status']),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['role'],
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.business, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 4),
                          Text(
                            user['company'],
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 4),
                          Text(
                            user['email'],
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'online':
        color = Colors.green;
        break;
      case 'away':
        color = Colors.orange;
        break;
      case 'offline':
        color = Colors.grey;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Long Screenshot Demo'), centerTitle: true, elevation: 0),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.screenshot, size: 48, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('Capture Long Screenshots', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(
                        'Scroll through the content below and tap the button to capture a screenshot of the entire content.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                RepaintBoundary(key: _screenshotKey, child: _buildLongContent()),
              ],
            ),
          ),
          if (_isCapturing)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Capturing screenshot...', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isCapturing ? null : _showSaveOptions,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Capture'),
      ),
    );
  }
}
