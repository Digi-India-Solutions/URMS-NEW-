import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';


Future<File?> addWatermarkToImage(File imageFile) async {
  try {
    final bytes = await imageFile.readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return null;

    // Resize to reduce memory usage
    const int maxDimension = 480;
    img.Image resized;
    if (decoded.width > decoded.height) {
      resized = img.copyResize(decoded, width: maxDimension);
    } else {
      resized = img.copyResize(decoded, height: maxDimension);
    }

    final List<int> compressedBytes = img.encodeJpg(resized, quality: 60);
    final dir = await getTemporaryDirectory();
    final outputPath = '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(compressedBytes);
    return outputFile;
  } catch (e) {
    print("Compression error: $e");
    return null;
  }
}




















// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart' as ui;
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image/image.dart' as img;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
//
// Future<File?> addWatermarkToImage(File originalImageFile) async {
//   try {
//     // ✅ Handle location permission
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }
//
//     // Load image bytes
//     final Uint8List imageBytes = await originalImageFile.readAsBytes();
//     final img.Image? originalImg = img.decodeImage(imageBytes);
//     if (originalImg == null) throw Exception('Image decoding failed.');
//
//     // Get current location
//     final position = await Geolocator.getCurrentPosition();
//     final lat = position.latitude.toStringAsFixed(5);
//     final lon = position.longitude.toStringAsFixed(5);
//
//     // Get current time
//     final now = DateTime.now();
//     final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//
//     // Create a new image canvas using Flutter's ui to draw watermark
//     final ui.PictureRecorder recorder = ui.PictureRecorder();
//     final canvas = ui.Canvas(recorder);
//     final paint = ui.Paint();
//
//     final uiImage = await decodeImageFromList(imageBytes);
//     final size = ui.Size(uiImage.width.toDouble(), uiImage.height.toDouble());
//
//     // Draw original image
//     canvas.drawImage(uiImage, Offset.zero, paint);
//
//     // Prepare watermark text
//     final text = 'Time: $formattedDateTime\nLat: $lat, Lon: $lon';
//     final textSpan = ui.TextSpan(
//       text: text,
//       style: ui.TextStyle(
//         color: const ui.Color(0xFFFFFFFF),
//         fontSize: 60,
//         background: Paint()..color = const ui.Color(0x80000000),
//       ),
//     );
//
//     final textPainter = ui.TextPainter(
//       text: textSpan,
//       textAlign: TextAlign.center,
//       textDirection: ui.TextDirection.ltr,
//     );
//
//     textPainter.layout(
//       minWidth: 0,
//       maxWidth: size.width - 20,
//     );
//
//     final offsetX = (size.width - textPainter.width) / 2;
//     final offsetY = size.height * 0.7;
//
//     textPainter.paint(canvas, Offset(offsetX, offsetY));
//
//     // Complete drawing
//     final picture = recorder.endRecording();
//     final uiImageWithWatermark = await picture.toImage(uiImage.width, uiImage.height);
//     final byteData = await uiImageWithWatermark.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData == null) throw Exception("ByteData conversion failed");
//
//     // Decode image to package 'image' for compression
//     final img.Image? imageForCompression = img.decodeImage(byteData.buffer.asUint8List());
//     if (imageForCompression == null) throw Exception("Image re-decoding failed");
//
//     int quality = 90;
//     List<int> compressedBytes = [];
//
//     // Compress repeatedly until under 1MB or quality is too low
//     while (true) {
//       compressedBytes = img.encodeJpg(imageForCompression, quality: quality);
//       final sizeInKB = compressedBytes.length / 1024;
//       if (sizeInKB < 1024 || quality <= 30) {
//         break;
//       }
//       quality -= 10; // decrease quality by 10%
//     }
//
//     // Save to file
//     final outputDir = await getTemporaryDirectory();
//     final outputPath = '${outputDir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final outputFile = File(outputPath);
//     await outputFile.writeAsBytes(compressedBytes);
//
//     return outputFile;
//   } catch (e) {
//     print("Error: $e");
//     return null;
//   }
// }







// import 'dart:io';
// import 'package:flutter/cupertino.dart' as ui;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image/image.dart' as img;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
//
// Future<File?> addWatermarkToImage(File originalImageFile) async {
//   try {
//     // Handle location permission
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }
//
//     // Load image bytes
//     final Uint8List imageBytes = await originalImageFile.readAsBytes();
//     final img.Image? originalImg = img.decodeImage(imageBytes);
//     if (originalImg == null) throw Exception('Image decoding failed.');
//
//     // Get current location
//     final position = await Geolocator.getCurrentPosition();
//     final lat = position.latitude.toStringAsFixed(5);
//     final lon = position.longitude.toStringAsFixed(5);
//
//     // Get current time
//     final now = DateTime.now();
//     final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
//
//     // Draw watermark on image using Flutter's ui library
//     final ui.PictureRecorder recorder = ui.PictureRecorder();
//     final canvas = ui.Canvas(recorder);
//     final paint = ui.Paint();
//
//     // Decode original image as ui.Image
//     final uiImage = await decodeImageFromList(imageBytes);
//     final size = ui.Size(uiImage.width.toDouble(), uiImage.height.toDouble());
//
//     // Draw original image
//     canvas.drawImage(uiImage, Offset.zero, paint);
//
//     // Prepare watermark text
//     final text = 'Time: $formattedDateTime\nLat: $lat, Lon: $lon';
//     final textSpan = ui.TextSpan(
//       text: text,
//       style: ui.TextStyle(
//         color: const ui.Color(0xFFFFFFFF),
//         fontSize: 60,
//         background: Paint()..color = const ui.Color(0x80000000),
//       ),
//     );
//
//     final textPainter = ui.TextPainter(
//       text: textSpan,
//       textAlign: TextAlign.center,
//       textDirection: ui.TextDirection.ltr,
//     );
//
//     textPainter.layout(
//       minWidth: 0,
//       maxWidth: size.width - 20,
//     );
//
//     final offsetX = (size.width - textPainter.width) / 2;
//     final offsetY = size.height * 0.7;
//
//     textPainter.paint(canvas, Offset(offsetX, offsetY));
//
//     // Complete drawing
//     final picture = recorder.endRecording();
//     final uiImageWithWatermark = await picture.toImage(uiImage.width, uiImage.height);
//     final byteData = await uiImageWithWatermark.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData == null) throw Exception("ByteData conversion failed");
//
//     // Decode image to 'image' package format for resizing/compression
//     img.Image? imageForProcessing = img.decodeImage(byteData.buffer.asUint8List());
//     if (imageForProcessing == null) throw Exception("Image re-decoding failed");
//
//     // Resize image if larger than max dimensions (e.g. max 1080px width or height)
//     const int maxDimension = 1080;
//     if (imageForProcessing.width > maxDimension || imageForProcessing.height > maxDimension) {
//       imageForProcessing = img.copyResize(imageForProcessing,
//           width: imageForProcessing.width > imageForProcessing.height ? maxDimension : null,
//           height: imageForProcessing.height >= imageForProcessing.width ? maxDimension : null);
//     }
//
//     int quality = 90;
//     List<int> compressedBytes = [];
//
//     // Compress until under 100KB or quality limit
//     while (true) {
//       compressedBytes = img.encodeJpg(imageForProcessing, quality: quality);
//       final sizeInKB = compressedBytes.length / 1024;
//       if (sizeInKB < 100 || quality <= 30) {
//         break;
//       }
//       quality -= 5;
//     }
//
//     // Save compressed file
//     final outputDir = await getTemporaryDirectory();
//     final outputPath = '${outputDir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final outputFile = File(outputPath);
//     await outputFile.writeAsBytes(compressedBytes);
//
//     return outputFile;
//   } catch (e) {
//     print("Error: $e");
//     return null;
//   }
// }
