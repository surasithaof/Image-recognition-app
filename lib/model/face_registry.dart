import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_recognizer/model/face_model.dart';

typedef FaceMatch = ({User user, double difference, Rect boundingRect, bool isRecognized});

mixin FaceRegistry {
  static List<User> listOfUsers = [];

  static FaceMatch? findFromList(List<double> vectors, Rect boundingRect) {
    double cutoffThreshold = 1;
    FaceMatch? userMatch;

    for (final user in listOfUsers) {
      final List<double> knownVector = user.vectorList;
      double distance = 0;

      for (int i = 0; i < vectors.length; i++) {
        double diff = vectors[i] - knownVector[i];
        distance += pow(diff, 2);
      }
      distance = sqrt(distance);
      debugPrint("${user.name}  $distance");
      if (userMatch == null || (distance < userMatch.difference)) {
        userMatch = (user: user.copyWith(list: vectors), difference: distance, boundingRect: boundingRect, isRecognized: true);
      }
    }
    if (listOfUsers.isEmpty || (userMatch?.difference ?? 1) > cutoffThreshold) {
      return (user: User("Unknown", vectors), difference: 1, boundingRect: boundingRect, isRecognized: false);
    }
    return userMatch;
  }
}
