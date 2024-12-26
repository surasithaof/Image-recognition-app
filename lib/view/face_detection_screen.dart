import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_recognizer/model/face_registry.dart';
import 'package:image_recognizer/helper/cordinates_translator.dart';
import 'package:image_recognizer/helper/face_painter.dart';
import 'package:image_recognizer/helper/face_recognition.dart';
import 'package:image_recognizer/view/face_registry_dialog.dart';
import 'dart:ui' as ui;

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  final imagePicker = ImagePicker();
  final faceRecognition = FaceRecognition();
  img.Image? _viewImage;

  final faceDetector = FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
  Size? _imageActualSize;
  int resizeImageWidth = 400;

  Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    return faces;
  }

  List<FaceMatch> recognizedFaces = [];

  bool isProcessing = false;

  void pickAndProcess({ImageSource source = ImageSource.camera}) async {
    setState(() {
      _viewImage = null;
      _imageActualSize = null;
      isProcessing = true;
    });
    recognizedFaces.clear();
    final imageFile = await imagePicker.pickImage(source: source);
    if (imageFile != null) {
      // detect faces
      final List<Face> faces = await detectFaces(File(imageFile.path));
      final image = await img.decodeImageFile(imageFile.path);
      // if (image != null) return;
      for (final face in faces) {
        // crop image and generate facial vector
        final facialVector = await faceRecognition.recognizeFace(image!, face);
        final faceDetail = FaceRegistry.findFromList(facialVector, face.boundingBox);
        if (faceDetail != null) recognizedFaces.add(faceDetail);
      }

      setState(() {
        _imageActualSize = Size(image!.width.toDouble(), image.height.toDouble());
        final resizeHeight = (image.height / image.width) * resizeImageWidth;
        _viewImage = img.copyResize(image, width: resizeImageWidth, height: resizeHeight.toInt());
        isProcessing = false;
      });
    }
  }

  Future<ui.Image?> loadUiImage(img.Image? image) async {
    if (image == null) return null;
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img.JpegEncoder().encode(image), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future registerFace() async {
    final unknownFace = recognizedFaces.firstWhere((faceData) => !faceData.isRecognized);
    final faceBounding = unknownFace.boundingRect;
    final resizedImageSize = Size(_viewImage!.width.toDouble(), _viewImage!.height.toDouble());
    final left = translateX(faceBounding.left, resizedImageSize, _imageActualSize!).toInt();
    final top = translateY(faceBounding.top, resizedImageSize, _imageActualSize!).toInt();
    final right = translateX(faceBounding.right, resizedImageSize, _imageActualSize!).toInt();
    final bottom = translateY(faceBounding.bottom, resizedImageSize, _imageActualSize!).toInt();
    final croppedImage = img.copyCrop(_viewImage!, x: left, y: top, width: right - left, height: bottom - top);
    await RegisterFaceDialog(context: context, imageBytes: img.JpegEncoder().encode(croppedImage), person: unknownFace.user).show();
  }

  @override
  void initState() {
    faceRecognition.loadModel();
    super.initState();
  }

  @override
  void dispose() {
    faceRecognition.close();
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Face recognition app (POC)"),
        ),
        body: DefaultTextStyle(
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),
          child: SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                FutureBuilder(
                    future: loadUiImage(_viewImage),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            if (recognizedFaces.isNotEmpty)
                              CustomPaint(
                                  painter: FaceDetectorPainter(recognizedFaces, _imageActualSize!, snapshot.data!),
                                  child: SizedBox.fromSize(size: Size(_viewImage!.width.toDouble(), _viewImage!.height.toDouble()))),
                            const SizedBox(height: 10),
                            Text(recognizedFaces.isEmpty ? "No faces found in picture" : "faces found: ${recognizedFaces.length}"),
                          ],
                        );
                      }
                      return Padding(
                          padding: const EdgeInsets.all(15),
                          child: isProcessing ? const CircularProgressIndicator() : const Text("Please select image"));
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return Center(
                              child: Material(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                child: SizedBox(
                                  width: 300,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(title: const Text("Camera"), onTap: pickAndProcess),
                                      const Divider(height: 0),
                                      ListTile(title: const Text("Album"), onTap: () => pickAndProcess(source: ImageSource.gallery)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: const Text("Select image")),
                if (recognizedFaces.isNotEmpty && recognizedFaces.any((faceData) => !faceData.isRecognized)) ...[
                  const SizedBox(height: 30),
                  const Text("Unknown face found... click below to save it"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), onPressed: registerFace, child: const Text("SAVE"))
                ]
              ]),
            ),
          ),
        ));
  }
}
