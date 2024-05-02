// экран камеры
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ocr_test/features/image_crop.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  final imgWidth = 300; // Image height
  final imgHeight = 100; // Image width

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late final ValueNotifier<bool> _isFlashOn = ValueNotifier<bool>(true);

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

  void _toggleFlash() {
    _isFlashOn.value = !_isFlashOn.value;
    _controller.setFlashMode(
      _isFlashOn.value ? FlashMode.torch : FlashMode.off,
    );
  }

  void _captureAndCrop() {
    captureAndCropImage(_controller, imgWidth, imgHeight, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.center,
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(
                _isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                color: Colors.black,
              ),
              onPressed: _toggleFlash,
            ),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: _captureAndCrop,
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
