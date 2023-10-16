
import 'package:emp_breakout/ui/settings_screen.dart';
import 'package:flutter/cupertino.dart';

import 'levels_provider.dart';

class LevelNotifier extends ValueNotifier<GameLevel> {
  LevelNotifier() : super(GameLevel.easy);

  void changeLevel(GameLevel value2 ) {

    value=value2;
    notifyListeners();
  }

}

LevelNotifier levelInstance = LevelNotifier();
