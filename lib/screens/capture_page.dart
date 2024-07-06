import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logging/logging.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  CapturePageState createState() => CapturePageState();
}

class CapturePageState extends State<CapturePage> {
  File? _image;
  final picker = ImagePicker();
  final Logger _logger = Logger('CapturePageState');

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _logger.warning('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: const Text('Capture Image'),
            ),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: const Text('Select from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
