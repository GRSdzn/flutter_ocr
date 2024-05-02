import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

// Функция для нахождения индекса максимального элемента в списке
int argMax(List<double> list) {
  if (list.isEmpty) return -1;
  int indexMax = 0;
  double maxVal = list[0];
  for (int i = 1; i < list.length; i++) {
    if (list[i] > maxVal) {
      maxVal = list[i];
      indexMax = i;
    }
  }
  return indexMax;
}

Future<List<List<List<List<double>>>>> imgToRGBMatrix(
    File croppedImageFile) async {
  final bytes = await croppedImageFile.readAsBytes();
  final decoder = img.JpegDecoder();
  final decodedImg = decoder.decodeImage(bytes);
  final decodedBytes = decodedImg!.getBytes(format: img.Format.rgb);

  const imgWidth = 300; // ширина изображения
  const imgHeight = 100; // высота изображения

  List<List<List<double>>> imgArray = [];

  for (int y = 0; y < imgHeight; y++) {
    List<List<double>> row = [];
    for (int x = 0; x < imgWidth; x++) {
      List<double> pixel = [];
      int index = (y * imgWidth + x) * 3;
      double red = (decodedBytes[index] / 255).roundToDouble();
      double green = (decodedBytes[index + 1] / 255).roundToDouble();
      double blue = (decodedBytes[index + 2] / 255).roundToDouble();
      pixel.add(red);
      pixel.add(green);
      pixel.add(blue);
      row.add(pixel);
    }
    imgArray.add(row);
  }

  // Добавляем дополнительное измерение размера партии
  List<List<List<List<double>>>> batchedImgArray = [imgArray];

  if (kDebugMode) {
    print(
        'Размер матрицы: ${batchedImgArray.length} x ${batchedImgArray[0].length} x ${batchedImgArray[0][0].length} x ${batchedImgArray[0][0][0].length}');
  }

  return batchedImgArray;
}

// Функция для преобразования категориальных данных в числовое значение
dynamic convertCategoricalToNumber(List<List<double>> array) {
  if (array.isEmpty || array[0].isEmpty) return null;

  // Находим индекс максимального элемента в первой строке
  int dotIndex = argMax(array[0]);
  // Удаляем первую строку массива
  array = array.sublist(1);

  List<String> numbers = [];
  // Проходим по оставшимся строкам массива
  for (List<double> row in array) {
    // Добавляем в список строковое представление индекса максимального элемента каждой строки
    numbers.add(argMax(row).toString());
  }

  // Если точка должна быть установлена, превращаем число в double
  if (dotIndex > 0 && numbers.length > 1) {
    numbers.insert(numbers.length - dotIndex, ".");
    return double.parse(numbers.join());
  } else {
    // Возвращаем число как int
    return int.parse(numbers.join());
  }
}
