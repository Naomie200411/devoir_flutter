import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:extract_texte/display_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late List<CameraDescription> cameras;
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String> extractTextFromImage(XFile imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = GoogleMlkitTextRecognizer.instance;

    try {
      final RecognisedText recognizedText = await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      for (TextBlock block in recognizedText.blocks) {
        final Rect rect = block.boundingBox!;
        final List<Point<int>> cornerPoints = block.cornerPoints!;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages!;

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
          }
        }
      }
      return text;
    } catch (e) {
      print('Error extracting text: $e');
      return 'Error extracting text';
    }
  }

  Future<void> _onCapturePressed() async {
    try {
      XFile imageFile = await controller.takePicture();
      String text = await extractTextFromImage(imageFile);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayScreen(text),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Capture Image')),
      body: CameraPreview(controller),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCapturePressed,
        child: Icon(Icons.camera),
      ),
    );
  }
}
