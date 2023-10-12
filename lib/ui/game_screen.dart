import 'package:emp_breakout/components/overlay.dart';
import 'package:flame/flame.dart';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import '../components/breakout_forge2d.dart';

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGameScreen> {
  final rwGreen = const Color.fromARGB(255, 21, 132, 67);
  final breakout = BreakoutGame();
  int score = 0;


  @override
  void initState() {
    super.initState();
    breakout.brickBrokenCallback = updateScore;
  }

  void updateScore(int newScore) {
    setState(() {
      score = newScore;
    });
  }



  @override
  Widget build(BuildContext context) {
    // Flame.images.load('background.png');

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          Stack(
            children: [Container(

              child: GameWidget(
                backgroundBuilder: (context){
                  return Container(
                    margin: EdgeInsets.only(bottom: 100),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/water.png'), // Replace with the path to your image asset
                        fit: BoxFit.cover, // You can choose how the image fits in the container
                      ),
                    ),
                  );
                },
                game: breakout,
                overlayBuilderMap: const {
                  'PreGame': OverlayBuilder.preGame,
                  'PauseGame': OverlayBuilder.pauseGame,
                  'PostGame': OverlayBuilder.postGame,
                },
              ),
            ),

          Positioned(
            bottom: 20,
            right: 20,
            child: pauseGame(context, breakout),
          ),

    //   Positioned(
    // bottom: 10,
    //         child: AnimatedContainer(
    // duration: Duration(
    // milliseconds: 300,
    // ),
    // width: 200,
    // height: 100,
    // child: ElevatedButton(
    // style: ElevatedButton.styleFrom(
    // primary: Colors.red,
    // ),
    // onPressed: () {
    // Navigator.pop(context);
    //
    // },
    // child: Row(
    // mainAxisAlignment: MainAxisAlignment.spaceAround,
    // children: [
    //   Icon(Icons.arrow_forward_ios_outlined, size: 40, color: Colors.black,),
    //
    // Text('Go back',
    // style: TextStyle(
    // fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
    //   SizedBox(),
    //
    // ],
    // ),
    // ),
    // ),
    //         )
]
    ));
  }
}

