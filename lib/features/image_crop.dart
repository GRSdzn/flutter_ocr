// Обрезаем изображение
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:ocr_test/features/img_to_array.dart';
import 'package:ocr_test/screens/display_pictures_screen.dart';

Future<void> captureAndCropImage(CameraController controller, int imgWidth,
    int imgHeight, BuildContext context) async {
  try {
    await controller.initialize();
    final image = await controller.takePicture();

    if (!controller.value.isInitialized) return;

    img.Image originalImage =
        img.decodeImage(File(image.path).readAsBytesSync())!;

    int x = (originalImage.width - imgWidth) ~/ 2;
    int y = (originalImage.height - imgHeight) ~/ 2;
    int w = imgWidth;
    int h = imgHeight;

    img.Image croppedImage = img.copyCrop(originalImage, x, y, w, h);

    File croppedFile = File('${image.path}_cropped.jpg')
      ..writeAsBytesSync(img.encodeJpg(croppedImage));

    imgToRGBMatrix(croppedFile);

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
