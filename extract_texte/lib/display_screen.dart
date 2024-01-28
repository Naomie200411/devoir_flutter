import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_share/flutter_share.dart';

class DisplayScreen extends StatefulWidget {
  final String extractedText;
  final String imagePath;

  const DisplayScreen(
      {Key? key, required this.extractedText, required this.imagePath})
      : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  late String _croppedImagePath;

  @override
  void initState() {
    super.initState();
    _croppedImagePath = widget.imagePath;
  }

  Future<void> _cropImage(BuildContext context) async {
    try {
      print('Avant le recadrage');
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _croppedImagePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recadrer l\'image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );
      print('Après le recadrage');

      if (croppedFile != null) {
        setState(() {
          _croppedImagePath = croppedFile.path;
        });
      }
    } catch (e) {
      print('Erreur pendant le recadrage : $e');
    }
  }

  Future<void> _shareImageAndText(BuildContext context) async {
    try {
      await FlutterShare.share(
        title: 'Partager',
        text: widget.extractedText,
        linkUrl: _croppedImagePath,
        chooserTitle: 'Partager avec',
      );
    } catch (e) {
      print('Erreur lors du partage : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image et texte détecté'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Afficher l'image croppée
              Container(
                child: Image.file(
                  File(_croppedImagePath),
                  width: MediaQuery.of(context).size.width * 0.9,
                  //   height: 300,
                ),
              ),
              SizedBox(height: 20),

              // Afficher le texte détecté
              Text(
                'Texte détecté :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    widget.extractedText,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Bouton pour recadrer l'image
              ElevatedButton(
                onPressed: () => _cropImage(context),
                child: Text('Recadrer l\'image'),
              ),
              SizedBox(height: 10),

              // Bouton pour partager l'image et le texte
              ElevatedButton(
                onPressed: () => _shareImageAndText(context),
                child: Text('Partager l\'image et le texte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
