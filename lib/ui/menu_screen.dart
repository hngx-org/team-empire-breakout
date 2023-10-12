<<<<<<< HEAD
// import 'package:emp_breakout/components/animated_button.dart';
// import 'package:emp_breakout/ui/game_screen.dart';
// import 'package:flutter/material.dart';
//
// class MenuContent extends StatefulWidget {
//   @override
//   _MenuContentState createState() => _MenuContentState();
// }
//
// class _MenuContentState extends State<MenuContent> {
//   double buttonSize = 100.0;
//   bool isButtonBouncing = false;
//
//   void startGame() {
//     setState(() {
//       isButtonBouncing = true;
//       buttonSize = 120.0;
//     });
//
//     // Simulate a delay for the animation
//     Future.delayed(Duration(milliseconds: 300), () {
//       setState(() {
//         isButtonBouncing = false;
//         buttonSize = 100.0;
//       });
//
//       // Navigate to the game screen or perform other actions
//       // You can replace this with your game logic.
//       // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen()));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           width: buttonSize,
//           height: buttonSize,
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//               builder: (context) => MainGameScreen()),
//     );},
//             child: Text('Start Game'),
//         ),
//         ),
//         AnimatedButton(),
//
//       ],
//     );
//   }
// }
import 'package:emp_breakout/ui/instructions_screen.dart';
=======
import 'package:emp_breakout/ui/levels_screen.dart';
>>>>>>> 30e58ad352b7615c7f1a72c59317cca9099a8d60
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _PageWithAnimatedListState createState() => _PageWithAnimatedListState();
}

class _PageWithAnimatedListState extends State<MenuScreen> {
  var _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() {
    // fetching data from web api, db...
    final fetchedList = [
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainGameScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ), // Set the background color
          child: Text('Start Game',
              style: TextStyle(
                  fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LevelScreen()),
            );
          },
          child: Text('Select Level',
              style: TextStyle(
                  fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
        ),
      ),
      SizedBox(
        height: 40,
      ),
      AnimatedContainer(
        duration: Duration(
          milliseconds: 300,
        ),
        width: 100,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () {
            Navigator.push(
              context,
<<<<<<< HEAD
              MaterialPageRoute(builder: (context) => InstructionScreen())
=======
              MaterialPageRoute(builder: (context) => LevelScreen()),
>>>>>>> 30e58ad352b7615c7f1a72c59317cca9099a8d60
            );
          },
          child: Text('Instructions',
              style: TextStyle(
                  fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
        ),
      ),
    ];

    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          _listItems.add(fetchedList[i]);
          _listKey.currentState?.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  void _unloadItems() {
    var future = Future(() {});
    for (var i = _listItems.length - 1; i >= 0; i--) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 100), () {
          final deletedItem = _listItems.removeAt(i);
          _listKey.currentState!.removeItem(i,
              (BuildContext context, Animation<double> animation) {
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive((Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ))),
              child: deletedItem,
            );
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/splash.jpeg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
<<<<<<< HEAD
            SizedBox(height: 200,),
=======
            SizedBox(
              height: 300,
            ),
>>>>>>> 30e58ad352b7615c7f1a72c59317cca9099a8d60
            Expanded(
              child: Stack(
                children:[
                  AnimatedList(
                    key: _listKey,
                    padding: EdgeInsets.only(top: 10),
                    initialItemCount: _listItems.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position: CurvedAnimation(
                          curve: Curves.easeOut,
                          parent: animation,
                        ).drive((Tween<Offset>(
                          begin: Offset(1, 0),
                          end: Offset(0, 0),
                        ))),
                        child: _listItems[index],
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 80,
                      ),
                      onPressed: () {
                        // Add your settings button functionality here
                      },
                    ),
                  ),

                ]

              ),

            ),
            SizedBox(height: 60,)
          ],
        ),
      ),
    );
  }
}
