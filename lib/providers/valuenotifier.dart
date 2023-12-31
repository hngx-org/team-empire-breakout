import 'package:emp_breakout/providers/levels_provider.dart';
import 'package:flutter/material.dart';

class ScoreNotifier extends ValueNotifier<int> {
  ScoreNotifier() : super(0);

  void incrementScore(int i) {
    value = value + i;
    notifyListeners();
  }

  void restScore() {
    value = 0;
    notifyListeners();
  }
}

ScoreNotifier scoreInstance = ScoreNotifier();
