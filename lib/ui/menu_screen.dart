import 'package:emp_breakout/ui/game_screen.dart';
import 'package:flutter/material.dart';

class MenuContent extends StatefulWidget {
  @override
  _MenuContentState createState() => _MenuContentState();
}

class _MenuContentState extends State<MenuContent> {
  double buttonSize = 100.0;
  bool isButtonBouncing = false;

  void startGame() {
    setState(() {
      isButtonBouncing = true;
      buttonSize = 120.0;
    });

    // Simulate a delay for the animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        isButtonBouncing = false;
        buttonSize = 100.0;
      });

      // Navigate to the game screen or perform other actions
      // You can replace this with your game logic.
      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: buttonSize,
          height: buttonSize,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
              builder: (context) => MainGameScreen()),
    );},
            child: Text('Start Game'),
        ),
        ),
      ],
    );
  }
}
