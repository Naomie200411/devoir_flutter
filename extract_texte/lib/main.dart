import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraScreen(
        camera: firstCamera,
      ),
    ),
  );
}
