import 'package:flutter/material.dart';

import 'game_screen.dart';

class InstructionScreen extends StatefulWidget {
  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
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
        child: Text('Welcome to Breakout!',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.black)),
      ),
      SizedBox(
        height: 10,
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: Text('Swipe left or right to move the paddle.',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.black)),
      ),
      SizedBox(
        height: 10,
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: Text('Avoid letting the ball hit the bottom.',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.black)),
      ),
      SizedBox(
        height: 10,
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: Text('Collect power-ups for special abilities.',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.black)),
      ),
      SizedBox(
        height: 10,
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 100,
        child: Text('Have fun and enjoy the game!',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 30, color: Colors.black)),
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
      appBar: AppBar(
        title:Text('Instruction',
            style: TextStyle(
                fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/magic.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              Expanded(
                child:
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: Colors.white.withOpacity(0.7)
                    ),
                    child: AnimatedList(
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
                  ),


                            ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainGameScreen()),
                  );
                },
                child: Text('Start Game',
                    style: TextStyle(
                        fontFamily: 'Pacifico', fontSize: 25, color: Colors.white)),
              ),

              SizedBox(height: 70,),

                ]),
              ),
              // SizedBox(
              //   height: 70,
              // )

          ),
        );


  }
}


