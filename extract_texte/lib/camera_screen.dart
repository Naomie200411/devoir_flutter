import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:extract_texte/display_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<String> scanText(XFile imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String extractedText = '';
      for (TextBlock block in recognizedText.blocks) {
        extractedText += block.text + '\n';
      }

       // Traduire le texte dans la langue du téléphone (ici, français)
    final Translation translation = await translator.translate(extractedText, to: 'fr');

    // Extraire la chaîne de caractères à partir de l'objet Translation
    final String translatedText = translation.text;

    return translatedText;
    } catch (e) {
      print('Error scanning text: $e');
      return 'Error scanning text';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scannez ou saisissez du texte')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            final translatedText = await scanText(image);

            // Appelez la fonction pour traiter le texte extrait
            processExtractedText(translatedText);

            if (mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DisplayScreen(extractedText: translatedText , imagePath: image.path,),
                ),
              );
            }
          } catch (e) {
            print("Erreur lors de la capture de la photo ou du scanning de texte : $e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  void processExtractedText(String translatedText) {
    // Utilisez extractedText comme nécessaire
    print("Texte extrait: $translatedText");

    // Vous pouvez faire d'autres choses avec le texte ici
  }
}