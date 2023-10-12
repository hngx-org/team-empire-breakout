import 'package:shared_preferences/shared_preferences.dart';

class Level {
  // Level(_);
  static int rows = 0;
  static double radius = 20;
  static int column = 0;

  static Future<int> getRows() async {
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
        radius = 30;
        break;

      case 2:
        radius = 25;
        break;

      case 3:
        radius = 20;
        break;
      case 4:
        radius = 15;
        break;
      case 5:
        radius = 10;
      case 6:
        radius = 9;
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
}
