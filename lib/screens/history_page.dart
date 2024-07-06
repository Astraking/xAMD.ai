import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _images == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _images!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Image.file(
                      _images![index].file,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      '${_images![index].dateTime}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
