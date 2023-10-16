import 'dart:core';

import 'package:emp_breakout/ui/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider extends ChangeNotifier{
 GameLevel _difficulty = GameLevel.easy;
  int _level = 1;
  int _score = 0;
  int _layers = 2;
  bool _soundPlaying = false;

  bool get soundPlaying => _soundPlaying;

  void setLevel(int value){
    _level = value;
    notifyListeners();
  }
 GameLevel? getDifficultyLevel(){
   return _difficulty;
 }

 GameLevel? setDifficultyLevel(GameLevel value){
   _difficulty = value;
   notifyListeners();
   return null;
 }

  int getLevel(){
    return _level;
  }

  void setSoundOn(){
    _soundPlaying=false;
    notifyListeners();
  }
  void setSoundoff(){
    _soundPlaying=true;
    notifyListeners();
  }
   // bool getSoundOn(){
   //  return _soundOn;
   // }
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