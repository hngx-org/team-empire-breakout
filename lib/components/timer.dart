import 'dart:async';
import 'package:emp_breakout/components/breakout_forge2d.dart';
import 'package:emp_breakout/components/levels.dart';
import 'package:emp_breakout/components/overlay.dart';
import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  final BreakoutGame breakout;

  const TimeScreen({required this.breakout});
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  // int _value = 60;
  Timer? _timer;
  // bool _isTimerRunning = false;

  // void startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_value > 0) {
  //         _value--;
  //       } else {
  //         _timer?.cancel();
  //         widget.breakout.gameState = GameState.lost;
  //         // showTimeUpDialog();
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Time: ${timeInstance.value} sec',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class TimeNotifier extends ValueNotifier<int> {
  TimeNotifier() : super(0);
  GameState gameState = GameState.initializing;

  // void startCountdown(int durationSeconds) {
  //   value = durationSeconds;
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (value > 0) {
  //       value--;
  //     } else {
  //       cancelTimer(
  //         timer
  //       );
  //     }
  //   });
  // }

  late Timer? _timer;
  int _remainingTime = 0;

  void startTimer(int initialTime) {
    value = initialTime;
    _remainingTime = initialTime;

    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {

    if (_remainingTime > 0) {
      _remainingTime--;
      value = _remainingTime;
    } else {
      timer.cancel();
      gameState = GameState.lost;
    }
  }

  void cancelTimer() {
    (_timer != null) ? _timer!.cancel() : null;
  }

  void resetZero() {
    value = 0;
  }
  void endGame() {
    if (value == 0){
      gameState = GameState.lost;
    }
  }

  Future<void> resetTimer() async {
    value = await Level.getTime();
  }

  void reduceTimer(int seconds) {
    if (_remainingTime > seconds) {
      _remainingTime -= seconds;
      value = _remainingTime;
      endGame();
    }
  }
}

TimeNotifier timeInstance = TimeNotifier();
