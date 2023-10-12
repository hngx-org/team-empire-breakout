
import 'package:emp_breakout/ui/levels_screen.dart';
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
        height: 20,
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
        height: 20,
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
              MaterialPageRoute(builder: (context) => LevelScreen()),
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
      image: AssetImage('assets/images/splash.jpeg'), // Replace with your image path
      fit: BoxFit.cover,
    ),
    ),
        child: Column(
          children: [
            SizedBox(height: 300,),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
