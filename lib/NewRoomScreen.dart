import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewRoomRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewRoomState();
  }
}

class NewRoomState extends State<NewRoomRoute> {
  String _character;

  final String url = "https://swapi.co/api/starships";
  List data;

  Future<String> getSWData() async {
    var res =
    await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      data = resBody["results"];
    });

    return "Success!";
  }

  Widget createNewPlayer(String s) {
    return TextField(
      decoration: InputDecoration(
          labelText: s,
          border: InputBorder.none,
          hintText: 'Введите имя участника'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[createNewPlayer(data[index]["name"])],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }
}
