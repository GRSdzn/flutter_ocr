import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ocr_test/features/neural_network_processor.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late Future<dynamic> _inferenceResult;
  final _processor = NeuralNetworkProcessor();

  @override
  void initState() {
    super.initState();
    _inferenceResult = _processor.processImage(File(widget.imagePath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: FutureBuilder<dynamic>(
        future: _inferenceResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(child: Image.file(File(widget.imagePath))),
                Text('Result: ${snapshot.data.toString()}'),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
