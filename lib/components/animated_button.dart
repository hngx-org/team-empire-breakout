import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 150.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: isPressed ? Colors.blue : Colors.green,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(25.0),
        onTap: () {
          setState(() {
            isPressed = !isPressed;
          });
        },
        child: Center(
          child: Text(
            isPressed ? 'Pressed' : 'Press Me',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}