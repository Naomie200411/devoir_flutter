import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  final String extractedText;

  DisplayScreen(this.extractedText);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Display')),
      body: Center(
        child: Text(
          extractedText ?? 'No text detected',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
