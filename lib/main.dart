import 'package:flutter/material.dart';
import 'package:image_recognizer/view/face_detection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face recognition - POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        listTileTheme: const ListTileThemeData(titleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: Colors.black)),
        useMaterial3: true,
      ),
      home: const FaceDetectionScreen(),
    );
  }
}
