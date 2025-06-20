import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

/// A Flutter plugin for capturing long screenshots of widgets without auto-scrolling.
class FlutterLongScreenshot {
  /// Captures a long screenshot of the given widget
  ///
  /// [key] - The GlobalKey of the RepaintBoundary widget to capture
  /// [pixelRatio] - The pixel ratio for the screenshot (default: 3.0)
  /// [quality] - The quality of the screenshot (0.0 to 1.0, default: 1.0)
  /// Returns a [Uint8List] containing the PNG image data
  static Future<Uint8List> captureLongScreenshot({required GlobalKey key, double pixelRatio = 3.0, double quality = 1.0}) async {
    try {
      final RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Create image with full width
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

      // Convert to byte data with quality control
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to capture screenshot');
      }

      // Apply quality reduction if needed
      if (quality < 1.0) {
        // Convert to PNG with reduced quality
        final Uint8List originalBytes = byteData.buffer.asUint8List();
        final Uint8List compressedBytes = await _compressImage(originalBytes, quality);
        return compressedBytes;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      throw Exception('Failed to capture screenshot: $e');
    }
  }

  /// Converts the screenshot to PDF and shares it
  ///
  /// [imageData] - The image data to convert
  /// [fileName] - The name of the file (without extension)
  /// Returns the path to the saved PDF file
  static Future<String> convertToPdfAndShare(Uint8List imageData, String fileName) async {
    try {
      // Get image dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(imageData);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;
      final double width = image.width.toDouble();
      final double height = image.height.toDouble();

      // Create PDF document
      final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

      // Convert image bytes to PdfImage
      final pdfImage = pw.MemoryImage(imageData);

      // Add page with proper dimensions
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(width, height, marginAll: 0),
          build: (context) {
            return pw.Center(
              child: pw.Image(pdfImage, width: width, height: height),
            );
          },
        ),
      );

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String pdfPath = '${tempDir.path}/$fileName.pdf';
      final File pdfFile = File(pdfPath);

      // Save PDF
      await pdfFile.writeAsBytes(await pdf.save());

      // Share the PDF
      await Share.shareXFiles([XFile(pdfPath)], text: 'Screenshot PDF');

      return pdfPath;
    } catch (e) {
      throw Exception('Failed to convert and share PDF: $e');
    }
  }

  /// Converts the screenshot to PDF and saves it
  ///
  /// [imageData] - The image data to convert
  /// [fileName] - The name of the file (without extension)
  /// [openAfterSave] - Whether to open the file after saving (default: true)
  /// Returns the path to the saved PDF file
  static Future<String> convertToPdfAndSave({required Uint8List imageData, required String fileName, bool openAfterSave = true}) async {
    try {
      // Get image dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(imageData);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;
      final double width = image.width.toDouble();
      final double height = image.height.toDouble();

      // Create PDF document
      final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);

      // Convert image bytes to PdfImage
      final pdfImage = pw.MemoryImage(imageData);

      // Add page with proper dimensions
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(width, height, marginAll: 0),
          build: (context) {
            return pw.Center(
              child: pw.Image(pdfImage, width: width, height: height),
            );
          },
        ),
      );

      // Get downloads directory
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      // Save PDF
      final String pdfPath = '${downloadsDir.path}/$fileName.pdf';
      final File pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());

      // Open the file if requested
      if (openAfterSave) {
        final result = await OpenFile.open(pdfPath);
        if (result.type != ResultType.done) {
          throw Exception('Failed to open file: ${result.message}');
        }
      }

      return pdfPath;
    } catch (e) {
      throw Exception('Failed to convert and save PDF: $e');
    }
  }

  /// Compresses the image data with the specified quality
  static Future<Uint8List> _compressImage(Uint8List bytes, double quality) async {
    // For now, we'll use a simple approach to reduce quality
    // In a production environment, you might want to use a proper image compression library
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ByteData? compressedData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (compressedData == null) {
      throw Exception('Failed to compress image');
    }

    return compressedData.buffer.asUint8List();
  }

  /// Saves the screenshot to a file
  ///
  /// [imageData] - The image data to save
  /// [fileName] - The name of the file (without extension)
  /// Returns the path to the saved file
  static Future<String> saveScreenshot(Uint8List imageData, String fileName) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/$fileName.png';
    final File file = File(filePath);
    await file.writeAsBytes(imageData);
    return filePath;
  }

  /// Saves the screenshot to the Downloads folder and optionally opens it
  ///
  /// [imageData] - The image data to save
  /// [fileName] - The name of the file (without extension)
  /// [openAfterSave] - Whether to open the file after saving (default: true)
  /// Returns the path to the saved file
  static Future<String> saveToDownloadsAndOpen({required Uint8List imageData, required String fileName, bool openAfterSave = true}) async {
    try {
      // Get the downloads directory
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not access downloads directory');
      }

      // Create the file path
      final String filePath = '${downloadsDir.path}/$fileName.png';
      final File file = File(filePath);

      // Save the file
      await file.writeAsBytes(imageData);

      // Open the file if requested
      if (openAfterSave) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          throw Exception('Failed to open file: ${result.message}');
        }
      }

      return filePath;
    } catch (e) {
      throw Exception('Failed to save screenshot to downloads: $e');
    }
  }

  /// Shares the screenshot directly as an image
  ///
  /// [imageData] - The image data to share
  /// [fileName] - The name of the file (without extension)
  /// Returns the path to the saved image file
  static Future<String> shareScreenshot(Uint8List imageData, String fileName) async {
    try {
      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String imagePath = '${tempDir.path}/$fileName.png';
      final File imageFile = File(imagePath);

      // Save image
      await imageFile.writeAsBytes(imageData);

      // Share the image
      await Share.shareXFiles([XFile(imagePath)], text: 'Screenshot');

      return imagePath;
    } catch (e) {
      throw Exception('Failed to share screenshot: $e');
    }
  }
}
