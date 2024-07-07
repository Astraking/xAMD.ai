import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// Import DateFormat from intl package

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class ImageData {
  final File file;
  final DateTime dateTime;

  ImageData({required this.file, required this.dateTime});
}

class HistoryPageState extends State<HistoryPage> {
  List<ImageData>? _images;
  bool _isFullScreen = false;
  late File _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> entities = directory.listSync();
    List<ImageData> images = [];

    for (var entity in entities) {
      if (entity is File) {
        DateTime lastModified = await entity.lastModified();
        images.add(ImageData(file: entity, dateTime: lastModified));
      }
    }

    setState(() {
      _images = images;
    });
  }

  void _toggleFullScreen(File imageFile) {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        _selectedImage = imageFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _isFullScreen
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isFullScreen = false;
                });
              },
              child: Center(
                child: Image.file(
                  _selectedImage,
                  fit: BoxFit.contain,
                ),
              ),
            )
          : _images == null
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: _images!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _toggleFullScreen(_images![index].file);
                      },
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _images![index].file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
