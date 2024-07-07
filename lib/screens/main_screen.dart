import 'package:flutter/material.dart';
import 'info_page.dart';
import 'help_page.dart';
import 'history_page.dart';
import '../widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:amd_app/predictor.dart';
import 'results_page.dart';
import 'test_images_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Future<void> _showSourceBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _getImage(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Gallery'),
              onTap: () => _getImage(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      await _processImage(context, image);
    }
  }

  Future<void> _processImage(BuildContext context, File image) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
      );

      await Predictor.loadModel();
      final results = await Predictor.runModelOnImage(image);
      final gradcamImage = await Predictor.generateGradCAM(image);

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultsPage(results: results, gradcamImage: gradcamImage),
        ),
      );
    } catch (e) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while processing the image.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AMD Screening'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the next generation of AMD care!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontFamily: 'Readex Pro'),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/pic1.jpg', // Ensure this image exists in your assets folder
                width: 400,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                CustomButton(
                  text: 'Capture',
                  icon: Icons.camera_alt,
                  onPressed: () => _showSourceBottomSheet(context),
                ),
                CustomButton(
                  text: 'Info',
                  icon: Icons.info,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InfoPage())),
                ),
                CustomButton(
                  text: 'Help',
                  icon: Icons.help,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpPage())),
                ),
                CustomButton(
                  text: 'History',
                  icon: Icons.history,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryPage())),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Test Images',
              icon: Icons.image,
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TestImagesPage())),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
