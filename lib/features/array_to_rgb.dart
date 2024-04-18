// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart'; // Добавлен импорт для использования kDebugMode
// import 'package:image/image.dart' as img;

// class ImageToRgb extends StatefulWidget {
//   final int imgWidth;
//   final int imgHeight;
//   const ImageToRgb({
//     super.key,
//     required this.imgWidth,
//     required this.imgHeight,
//   });

//   @override
//   State<ImageToRgb> createState() => _ImageToRgbState();
// }

// class _ImageToRgbState extends State<ImageToRgb> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }

//   Future<void> readImage(File croppedImageFile) async {
//     final bytes = await croppedImageFile.readAsBytes();
//     final decoder = img.JpegDecoder();
//     final decodedImg = decoder.decodeImage(bytes);
//     final decodedBytes = decodedImg!.getBytes(format: img.Format.rgb);

//     List<List<int>> imgArray = [];

//     for (int y = 0; y < imgHeight; y++) {
//       List<int> row = [];
//       for (int x = 0; x < imgWidth; x++) {
//         int index = (y * imgWidth + x) * 3;
//         int red = decodedBytes[index];
//         int green = decodedBytes[index + 1];
//         int blue = decodedBytes[index + 2];
//         row.addAll([red, green, blue]);
//       }
//       imgArray.add(row);
//     }

//     if (kDebugMode) {
//       print(imgArray);
//     }
//   }
// }
