import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class Predictor {
  static Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        // Add labels if your model has them
        // labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print('Failed to load the model.');
    }
  }

  static Future<List<dynamic>?> predictImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 2, // number of categories your model can predict
      threshold: 0.5, // confidence threshold
      asynch: true,
    );
    return recognitions;
  }

  static Future<void> close() async {
    await Tflite.close();
  }
}
