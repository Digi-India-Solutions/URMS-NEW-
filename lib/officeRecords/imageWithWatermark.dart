import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart' as ui;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> addWatermarkToImage(File originalImageFile) async {
  try {
    // ✅ Handle location permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Load image bytes
    final Uint8List imageBytes = await originalImageFile.readAsBytes();
    final img.Image? originalImg = img.decodeImage(imageBytes);
    if (originalImg == null) throw Exception('Image decoding failed.');

    // Get current location
    final position = await Geolocator.getCurrentPosition();
    final lat = position.latitude.toStringAsFixed(5);
    final lon = position.longitude.toStringAsFixed(5);

    // Get current time
    final now = DateTime.now();
    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    // Create a new image canvas
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();

    final uiImage = await decodeImageFromList(imageBytes);
    final size = ui.Size(uiImage.width.toDouble(), uiImage.height.toDouble());

    // Draw original image
    canvas.drawImage(uiImage, Offset.zero, paint);

    // Prepare watermark text
    final text = 'Time: $formattedDateTime\nLat: $lat, Lon: $lon';
    final textSpan = ui.TextSpan(
      text: text,
      style: ui.TextStyle(
        color: const ui.Color(0xFFFFFFFF),
        fontSize: 60, // Adjusted for larger text (~14px+)
        background: Paint()..color = const ui.Color(0x80000000),
      ),
    );

    final textPainter = ui.TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width - 20,
    );

    // Center horizontally, and move vertically below center (~60px down)
    final offsetX = (size.width - textPainter.width) / 2;
    // final offsetY = (size.height - textPainter.height) / 2 + 100;
    final offsetY = size.height * 0.7;


    textPainter.paint(canvas, Offset(offsetX, offsetY));

    // Complete drawing
    final picture = recorder.endRecording();
    final uiImageWithWatermark = await picture.toImage(uiImage.width, uiImage.height);
    final byteData = await uiImageWithWatermark.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception("ByteData conversion failed");

    // Save to file
    final outputBytes = byteData.buffer.asUint8List();
    final outputDir = await getTemporaryDirectory();
    final outputPath = '${outputDir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.png';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(outputBytes);

    return outputFile;
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
