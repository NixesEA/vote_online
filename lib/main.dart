import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import "package:vote_make_app/NewRoomScreen.dart";
import 'package:vote_make_app/RoomScreen.dart';


void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(


          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Create new Vote"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewRoomRoute()));
              },
            ),
            RaisedButton(
              child: Text("Connect to Vote"),
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
