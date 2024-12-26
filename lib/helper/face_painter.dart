import 'package:flutter/material.dart';
import 'package:image_recognizer/model/face_registry.dart';
import 'package:image_recognizer/helper/cordinates_translator.dart';
import 'dart:ui' as ui;

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.image,
  );
  final ui.Image image;
  final List<FaceMatch> faces;
  final Size imageSize;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
    for (final FaceMatch faceMeta in faces) {
      final faceBounding = faceMeta.boundingRect;
      final person = faceMeta.user;
      final accuracy = faceMeta.difference;
      final left = translateX(faceBounding.left, size, imageSize);
      final top = translateY(faceBounding.top, size, imageSize);
      final right = translateX(faceBounding.right, size, imageSize);
      final bottom = translateY(faceBounding.bottom, size, imageSize);

      var path = Path();

      path
        ..moveTo(left, top)
        ..lineTo(right, top)
        ..lineTo(right, bottom)
        ..lineTo(left, bottom)
        ..lineTo(left, top);

      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.green
            ..strokeWidth = 1.7);

      final textPainter = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
            text: "Name: ${person.name}",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                background: Paint()..color = Colors.blue,
                foreground: Paint()
                  ..color = Colors.white
                  ..isAntiAlias = false))
        ..layout(maxWidth: 200);

      // // textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(left, top));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}
