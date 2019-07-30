
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import "package:vote_make_app/NewRoomScreen.dart";
import 'package:vote_make_app/RoomScreen.dart';


void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {

  static Set<int> s = new Set();

  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

//  var imei;
//
//  @override
//  void initState(){
//    super.initState();
//    imei = Random.secure().nextInt(1000000000);
//  }

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
