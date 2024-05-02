// Обрезаем изображение
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:ocr_test/features/img_to_array.dart';
import 'package:ocr_test/screens/display_pictures_screen.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

Future<void> captureAndCropImage(CameraController controller, int imgWidth,
    int imgHeight, BuildContext context) async {
  final interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');

  try {
    await controller.initialize();
    if (!controller.value.isInitialized) return;

    final image = await controller.takePicture();

    img.Image originalImage =
        img.decodeImage(File(image.path).readAsBytesSync())!;

    int x = (originalImage.width - imgWidth) ~/ 2;
    int y = (originalImage.height - imgHeight) ~/ 2;
    int w = imgWidth;
    int h = imgHeight;

    img.Image croppedImage = img.copyCrop(originalImage, x, y, w, h);
    File croppedFile = File('${image.path}_cropped.jpg')
      ..writeAsBytesSync(img.encodeJpg(croppedImage));

    List<List<List<List<double>>>> resultToMatrix =
        await imgToRGBMatrix(croppedFile);

    // Инициализация выходного тензора правильной формой
    var output1 =
        List.generate(1, (i) => List.generate(11, (j) => List.filled(10, 0.0)));

    // Запуск модели
    interpreter.run(resultToMatrix, output1);

    // Преобразование результатов
    dynamic result = convertCategoricalToNumber(output1[0]);
    print('Полученное число: $result');

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
