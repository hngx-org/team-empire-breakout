import 'package:flutter/material.dart';

class ScoreNotifier extends ValueNotifier<int> {
  ScoreNotifier() : super(0);

  void incrementScore() {
    value++;
    notifyListeners();
  }
}

ScoreNotifier scoreInstance = ScoreNotifier();
