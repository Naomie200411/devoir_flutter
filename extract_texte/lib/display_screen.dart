import 'package:flutter/material.dart';
import 'dart:io'; 



class DisplayScreen extends StatelessWidget {
  final String extractedText;
  final String imagePath;

  const DisplayScreen({Key? key, required this.extractedText, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image et texte détecté'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Afficher l'image capturée
            Image.file(
              File(imagePath),
              width: 300, // Ajustez la taille selon vos besoins
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
