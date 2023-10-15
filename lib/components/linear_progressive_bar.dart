import 'package:flutter/material.dart';

class LinearProgressWidget extends StatefulWidget {
  @override
  _LinearProgressWidgetState createState() => _LinearProgressWidgetState();
}

class _LinearProgressWidgetState extends State<LinearProgressWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    // Create an animation that goes from 0.0 to 1.0
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[Container(
        height: 50, // Set the desired height
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _animation.value, // Current progress value
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              );
            },
          ),
        ),
      ),
        Center(child: Text("Loading......",  style: TextStyle(color:Colors.black,fontFamily: 'Pacifico',fontSize: 26, fontWeight: FontWeight.bold),))
      ]
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}