
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_screen.dart';

class LevelScreen extends StatefulWidget {
  @override
  _PageWithAnimatedListState createState() => _PageWithAnimatedListState();
}

class _PageWithAnimatedListState extends State<LevelScreen> {
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
      AnimatedButton(context: context, content: "Level 1", level:1),

      SizedBox(
        height: 20,
      ),

      AnimatedButton(context: context, content: "Level 2", level: 2),

      SizedBox(
        height: 20,
      ),

      AnimatedButton(context: context, content: "Level 3", level: 3),

      SizedBox(
        height: 20,
      ),

      AnimatedButton(context: context, content: "Level 4", level: 4),
      SizedBox(
        height: 20,
      ),
      AnimatedButton(context: context, content: "Level 5", level: 5),

      SizedBox(
        height: 20,
      ),
      AnimatedButton(context: context, content: "Level 6", level: 6),
      SizedBox(
        height: 20,
      ),
      AnimatedButtonBack(context: context),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 100,),
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

class AnimatedButtonBack extends StatelessWidget {
  const AnimatedButtonBack({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
          Navigator.pop(context);

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.arrow_back_ios, size: 40, color: Colors.black,),
            Text('Go Back',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
            SizedBox()
          ],
        ),
      ),
    );
  }
}


class AnimatedButton extends StatelessWidget {
  const AnimatedButton({
    super.key,
    required this.content,
    required this .level,

    required this.context,
  });

  final BuildContext context;
  final String content;
  final int level;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 300,
      ),
      width: 70,
      height:70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt("level", level);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainGameScreen()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),

            Text('$content',
                style: TextStyle(
                    fontFamily: 'Pacifico', fontSize: 25, color: Colors.black)),
            Icon(Icons.arrow_forward_ios_outlined, size: 40, color: Colors.black,),

          ],
        ),
      ),
    );
  }
}
