import 'dart:async';
import 'package:emp_breakout/components/breakout_forge2d.dart';
import 'package:emp_breakout/components/overlay.dart';
import 'package:flutter/material.dart';

class TimeScreen extends StatefulWidget {
  final BreakoutGame breakout;

  const TimeScreen({required this.breakout});
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  int _value = 60;
  Timer? _timer;
  // bool _isTimerRunning = false;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_value > 0) {
          _value--;
        } else {
          _timer?.cancel();
          widget.breakout.gameState = GameState.lost;
          // showTimeUpDialog();
        }
      });
    });
  }

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
            'Time: $_value sec',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// class TimeNotifier extends ValueNotifier<int> {
//   TimeNotifier() : super(60);
//   GameState gameState = GameState.initializing;

//   void startCountdown(int durationSeconds) {
//     value = durationSeconds;
//     Timer.periodic(Duration(seconds: 1), (timer) {
//       if (value > 0) {
//         value--;
//       } else {
//         timer.cancel();

//       }
//     });
//   }

//   void resetTime() {
//     value = 60;
//   }
// }

// TimeNotifier timeInstance = TimeNotifier();
