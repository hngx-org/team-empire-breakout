import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider extends ChangeNotifier{

  int _level = 1;
  int _score = 0;
  int _layers = 2;
  bool _soundOn = true;

  void setLevel(int value){
    _level = value;
    notifyListeners();
  }

  int getLevel(){
    return _level;
  }

  void setSoundOn(bool value){
    _soundOn=value;
    notifyListeners();
  }
   bool getSoundOn(){
    return _soundOn;
   }
  void setScore(int value){
    _score = value;
    notifyListeners();
  }

  int getScore(){
    return _score;
  }

  void setLayers(int value){
    _layers = value;
    notifyListeners();
  }

  Future<int> getLayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     int? level = prefs.getInt("level");
    switch (level){
      case 1:
        setLayers(2);
        break;

      case 2:
        setLayers(3);
        break;

      case 3:
        setLayers(4);
        break;
    }
    return _layers;
  }

}