
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "package:vote_make_app/NewRoomScreen.dart";
import 'package:vote_make_app/RoomScreen.dart';


void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {

  static Set<String> s = new Set();

  static void add(String idRoom) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    s.add(idRoom);
    prefs.setStringList('counter', MainScreen.s.toList());
  }

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  @override
  void initState(){
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MainScreen.s.addAll(prefs.getStringList('counter'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Create new Room"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewRoomRoute()));
              },
            ),
            RaisedButton(
              child: Text("Connect to Room"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VoteListRoute()));
              },
            )
          ],
        ),
      ),
    );
  }
}
