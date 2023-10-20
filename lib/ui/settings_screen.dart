// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});
//
//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }
//
// class _SettingScreenState extends State<SettingScreen> {
//   bool isSwitched = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadSwitchState();
//   }
//
//   void loadSwitchState() async {
//     final SharedPreferences soundRef = await SharedPreferences.getInstance();
//     setState(() {
//       isSwitched = soundRef.getBool('soundSwitch') ?? false;
//     });
//   }
//
//   void saveSwitchState() async {
//     final SharedPreferences soundRef = await SharedPreferences.getInstance();
//     await soundRef.setBool('soundSwitch', isSwitched);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(child: Text('Settings')),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                   color: Colors.purpleAccent, borderRadius: BorderRadius.circular(10)),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       isSwitched ? 'Switch OFF Music' : 'Switch ON Music',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Switch(
//                       value: isSwitched,
//                       onChanged: (value) {
//                         setState(() {
//                           isSwitched = value;
//                           saveSwitchState(); // Save the state when it's changed
//                           if (isSwitched == false) {
//                             FlameAudio.bgm.stop();
//                           } else if(value== true){
//                             FlameAudio.bgm.resume();
//                           }
//                         });
//                       },
//                       activeTrackColor: Colors.lightGreen,
//                       activeColor: Colors.purpleAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:emp_breakout/providers/levelnotifier.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameLevel {
  easy,
  hard,
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  GameLevel selectedLevel = GameLevel.easy;

  @override
  void initState() {
    super.initState();
    loadSwitchState();
    loadSelectedLevel();
  }

  void loadSwitchState() async {
    final SharedPreferences soundRef = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = soundRef.getBool('soundSwitch') ?? false;
    });
  }

  void loadSelectedLevel() async {
    final SharedPreferences levelRef = await SharedPreferences.getInstance();
    setState(() {
      selectedLevel = GameLevel.values[levelRef.getInt('selectedLevel') ?? 0];
    });
  }

  void saveSwitchState() async {
    final SharedPreferences soundRef = await SharedPreferences.getInstance();
    await soundRef.setBool('soundSwitch', isSwitched);
  }

  void saveSelectedLevel(GameLevel level) async {
    final SharedPreferences levelRef = await SharedPreferences.getInstance();
    await levelRef.setInt('selectedLevel', level.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(
      //       child: Text('Settings',
      //           style: TextStyle(
      //               fontFamily: 'Pacifico',
      //               fontSize: 25,
      //               color: Colors.black))),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/bb.jpeg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // SizedBox(
              //   height: 20,
              // ),
              Center(
                child: Text('Settings',
                    style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 25,
                        color: Colors.white)),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.purpleAccent,
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          isSwitched ? 'Switch OFF Music' : 'Switch ON Music',
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 25,
                              color: Colors.brown),
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              saveSwitchState();
                              if (isSwitched == false) {
                                FlameAudio.bgm.stop();
                              } else {
                                FlameAudio.bgm.resume();
                              }
                            });
                          },
                          activeTrackColor: Colors.lightGreen,
                          activeColor: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    // color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListTile(
                        title: Text(
                          'Select Game Mode',
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 25,
                              color: Colors.brown),
                        ),
                      ),
                      DropdownButton<GameLevel>(
                        value: selectedLevel,
                        items: GameLevel.values.map((level) {
                          return DropdownMenuItem<GameLevel>(
                            value: level,
                            child: Text(
                              level.toString().split('.').last,
                              style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 25,
                                  color: Colors.black),
                            ), // Display the level name
                          );
                        }).toList(),
                        onChanged: (GameLevel? value) {
                          setState(() {
                            selectedLevel = value!;
                            saveSelectedLevel(selectedLevel);
                            levelInstance.value = selectedLevel;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text('Go back',
                          style: TextStyle(
                              fontFamily: 'Pacifico',
                              fontSize: 25,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
