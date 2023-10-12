import 'dart:developer';

import 'package:flutter/material.dart';

class ScoreNotifier extends ValueNotifier<int> {
  ScoreNotifier() : super(0);

  void incrementScore() {
    log("dddd");
    value = value + 1;
    log(value.toString());
    notifyListeners();
  }
}
