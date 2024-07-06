import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class Predictor {
  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  static Future<List?> runModelOnImage(File image) async {
    final imageBytes = await image.readAsBytes();
    img.Image originalImage = img.decodeImage(imageBytes)!;

    img.Image resizedImage =
        img.copyResize(originalImage, width: 224, height: 224);

    return await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
    );
  }

  static Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  static Future<img.Image> generateGradCAM(File image) async {
    final imageBytes = await image.readAsBytes();
    img.Image originalImage = img.decodeImage(imageBytes)!;
    img.Image resizedImage =
        img.copyResize(originalImage, width: 224, height: 224);

    var gradcamResult = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
      numResults: 1,
      threshold: 0.05,
    );

    // Assuming gradcamResult[0]['heatmap'] is the Grad-CAM heatmap
    List heatmap = gradcamResult![0]['heatmap'];

    // Create an image from the heatmap data
    img.Image gradcamImage = img.Image(224, 224);
    for (int i = 0; i < 224; i++) {
      for (int j = 0; j < 224; j++) {
        int colorValue = (heatmap[i * 224 + j] * 255).toInt();
        gradcamImage.setPixel(j, i, img.getColor(255, colorValue, 0));
      }
    }

    // Overlay the Grad-CAM heatmap on the original image
    img.Image overlayedImage =
        img.copyResize(originalImage, width: 224, height: 224);
    for (int i = 0; i < 224; i++) {
      for (int j = 0; j < 224; j++) {
        int heatmapPixel = gradcamImage.getPixel(j, i);
        int originalPixel = overlayedImage.getPixel(j, i);
        int overlayedPixel = img.getColor(
          (img.getRed(originalPixel) + img.getRed(heatmapPixel)) ~/ 2,
          (img.getGreen(originalPixel) + img.getGreen(heatmapPixel)) ~/ 2,
          (img.getBlue(originalPixel) + img.getBlue(heatmapPixel)) ~/ 2,
        );
        overlayedImage.setPixel(j, i, overlayedPixel);
      }
    }

    return overlayedImage;
  }
}
