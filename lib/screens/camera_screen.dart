import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:ocr_test/screens/display_pictures_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  final imgWidth = 300;
  final imgHeight = 100;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// получаем rgb матрицу изображения
  Future<void> readImage(File croppedImageFile) async {
    final bytes = await croppedImageFile.readAsBytes();
    final decoder = img.JpegDecoder();
    final decodedImg = decoder.decodeImage(bytes);
    final decodedBytes = decodedImg!.getBytes(format: img.Format.rgb);

    List<List<int>> imgArray = [];

    for (int y = 0; y < imgHeight; y++) {
      List<int> row = [];
      for (int x = 0; x < imgWidth; x++) {
        int index = (y * imgWidth + x) * 3;
        int red = decodedBytes[index];
        int green = decodedBytes[index + 1];
        int blue = decodedBytes[index + 2];
        row.add(red);
        row.add(green);
        row.add(blue);
      }
      imgArray.add(row);
    }

    if (kDebugMode) {
      print(imgArray);
    }
  }

// Вырезаем изображение
  Future<void> _captureAndCrop() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) return;

      img.Image originalImage =
          img.decodeImage(File(image.path).readAsBytesSync())!;

      int x = (originalImage.width - imgWidth) ~/ 2;
      int y = (originalImage.height - imgHeight) ~/ 2;
      int w = imgWidth;
      int h = imgHeight;

      img.Image croppedImage = img.copyCrop(originalImage, x, y, w, h);

      File croppedFile = File('${image.path}_cropped.jpg')
        ..writeAsBytesSync(img.encodeJpg(croppedImage));

      readImage(croppedFile);

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: croppedFile.path,
          ),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Камера')),
        body: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Center(
              child: Container(
                width: imgWidth.toDouble(),
                height: imgHeight.toDouble(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 2.0),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _captureAndCrop,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
