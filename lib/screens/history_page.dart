import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  List<FileSystemEntity>? _images;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final List<FileSystemEntity> images = directory.listSync();
      setState(() {
        _images = images;
      });
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate standard width and height based on screen size
    final double itemSize = MediaQuery.of(context).size.width / 3.5;

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
                return _buildImage(File(_images![index].path), itemSize);
              },
            ),
    );
  }

  Widget _buildImage(File imageFile, double itemSize) {
    return FutureBuilder(
      future: imageFile.exists(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              width: itemSize,
              height: itemSize,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
