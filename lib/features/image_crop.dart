// Обрезаем изображение
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:ocr_test/screens/display_pictures_screen.dart';

Future<void> captureAndCropImage(CameraController controller, int imgWidth,
    int imgHeight, BuildContext context) async {
  try {
    await controller.initialize();
    if (!controller.value.isInitialized || !context.mounted) return;

    final image = await controller.takePicture();
    if (!context.mounted) return;
    img.Image originalImage =
        img.decodeImage(File(image.path).readAsBytesSync())!;

    int x = (originalImage.width - imgWidth) ~/ 2;
    int y = (originalImage.height - imgHeight) ~/ 2;
    int w = imgWidth;
    int h = imgHeight;

    // Обратите внимание, что файл будет доступен только в пределах вашего приложения и не будет виден в галерее устройства, поскольку он сохраняется в приватной директории вашего приложения.
    // Если вам необходимо сохранить изображение в общедоступном месте, чтобы пользователь мог просматривать его в галерее, вам нужно рассмотреть сохранение файла в публичной директории, доступной для просмотра другими приложениями.

    img.Image croppedImage = img.copyCrop(originalImage, x, y, w, h);
    File croppedFile = File('${image.path}_cropped.jpg')
      ..writeAsBytesSync(img.encodeJpg(croppedImage));

    if (!context.mounted) return;
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
