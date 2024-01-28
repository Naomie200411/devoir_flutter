import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class DisplayScreen extends StatelessWidget {
  final String extractedText;
  final String imagePath;

  const DisplayScreen(
      {Key? key, required this.extractedText, required this.imagePath})
      : super(key: key);

  Future<void> _shareImageAndText(BuildContext context) async {
    try {
      await FlutterShare.share(
        title: 'Partager',
        text: extractedText,
        linkUrl: imagePath,
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
              // Afficher l'image capturée
              Image.file(
                File(imagePath),
                width: 300,
                height: 300,
              ),
              SizedBox(height: 20),

              // Afficher le texte détecté
              Text(
                'Texte détecté :',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                extractedText,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),

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
