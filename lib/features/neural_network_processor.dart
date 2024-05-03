import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:ocr_test/features/img_to_array.dart';

class NeuralNetworkProcessor {
  late tfl.Interpreter interpreter;

  NeuralNetworkProcessor() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    interpreter = await tfl.Interpreter.fromAsset('assets/model.tflite');
  }

  Future<dynamic> processImage(File imageFile) async {
    List<List<List<List<double>>>> input = await imgToRGBMatrix(imageFile);

    // Initialize the output tensor with the correct shape
    var output =
        List.generate(1, (i) => List.generate(11, (j) => List.filled(10, 0.0)));

    // Run model on image
    interpreter.run(input, output);

    // Convert output to readable format
    return convertCategoricalToNumber(output[0]);
  }
}
