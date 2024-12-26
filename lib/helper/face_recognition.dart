import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognition {
  final int faceNetInputImageSize = 112;
  late Interpreter _interpreter;

  void loadModel() async {
    final modelBuffer = await rootBundle.load("assets/mobile_face_net.tflite");
    _interpreter = Interpreter.fromBuffer(modelBuffer.buffer.asUint8List());
  }

  Future<List<double>> recognizeFace(img.Image image, Face face) async {
    try {
      List input = _imageProcessor(image, face);
      input = input.reshape([1, 112, 112, 3]);
      List output = List.generate(1, (index) => List.filled(192, 0));
      _interpreter.run(input, output);
      return output[0];
    } catch (error) {
      debugPrint(error.toString());
    }
    return [];
  }

  List _imageProcessor(img.Image imageInput, Face faceDetected) {
    img.Image croppedImage = _cropFace(imageInput, faceDetected);
    img.Image image = img.copyResizeCropSquare(croppedImage, size: 112);

    Float32List imageAsList = imageToByteListFloat32(image);
    return imageAsList;
  }

  img.Image _cropFace(img.Image convertedImage, Face faceDetected) {
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return img.copyCrop(convertedImage, x: x.round(), y: y.round(), width: w.round(), height: h.round());
  }

  Float32List imageToByteListFloat32(img.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - 128) / 128;
        buffer[pixelIndex++] = (pixel.g - 128) / 128;
        buffer[pixelIndex++] = (pixel.b - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  close() {
    _interpreter.close();
  }
}
