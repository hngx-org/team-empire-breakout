import 'package:emp_breakout/providers/levelnotifier.dart';
import 'package:emp_breakout/providers/levels_provider.dart';
import 'package:emp_breakout/ui/settings_screen.dart';
import 'package:flame/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Level {
  // Level(_);
  static int rows = 0;
  static double radius = 10;
  static int column = 0;
  static int ball = 1;

  static Future<int> getRows()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? level = prefs.getInt("level");
    switch (level) {
      case 1:
        rows = 2;
        break;

      case 2:
        rows = 3;
        break;

      case 3:
        rows = 4;
        break;
      case 4:
        rows = 5;
        break;
      case 5:
        rows = 6;
      case 6:
        rows = 7;
        break;
    }
    return rows;
  }

  static Future<double> getRadius() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? level = prefs.getInt("level");
    switch (level) {
      case 1:
        radius = 10;
        break;

      case 2:
        radius = 5;
        break;

      case 3:
        radius = 5;
        break;
      case 4:
        radius = 5;
        break;
      case 5:
        radius = 5;
      case 6:
        radius = 5;
        break;
    }
    return radius;
  }

  static Future<int> getColumn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? level = prefs.getInt("level");
    switch (level) {
      case 1:
        column = 5;
        break;

      case 2:
        column = 7;
        break;
      case 3:
        column = 8;
        break;
      case 4:
        column = 9;
        break;
      case 5:
        column = 10;
      case 6:
        column = 12;
        break;
    }
    return column;
  }
  static Future<int> getBalls() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? level = prefs.getInt("level");
    switch (level) {
      case 1:
        if (levelInstance.value==GameLevel.easy){
          ball = 1;
        }else{
        ball = 2;
        }
        break;

      case 2:
        if (levelInstance.value==GameLevel.easy){
          ball = 1;
        }else{
          ball = 2;
        }   break;

      case 3:
        if (levelInstance.value==GameLevel.easy){
          ball = 1;
        }else{
          ball = 2;
        }
        break;
      case 4:
        ball = 2;
        break;
      case 5:
        ball  = 2;
      case 6:
        ball = 3;
        break;
    }
    return ball;
  }
}
