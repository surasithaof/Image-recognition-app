# Image-recognition-app

This project demonstrates face detection & recognition using using google-mlkit-face-detection and tenserflow lite 

Here is an article link, where implemenation steps are explained [Article Link](https://medium.com/analytics-vidhya/face-recognition-authentication-using-flutter-and-tensorflow-lite-2659d941d56e)


Detecting face using google-mlkit-face-detection
```dart
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

final faceDetector = FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));

Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    return faces;
}
```

Generating facial vector using tensorflow-lite

```dart
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

late Interpreter _interpreter;

//load face-net model
void loadModel() async {
    final modelBuffer = await rootBundle.load("assets/mobile_face_net.tflite");
    _interpreter = Interpreter.fromBuffer(modelBuffer.buffer.asUint8List());
}

Future<List<double>> recognizeFace(img.Image dimage, Face face) async {
    try {
      //crop's the face from image and process it
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
```


# Face detetion work flow demo
![Face detetion demo](https://github.com/Mahesh-R-Mesta/Image-recognition-app/blob/main/demo_image.png)

Tested on Android only
