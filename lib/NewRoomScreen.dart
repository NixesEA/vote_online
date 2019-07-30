import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'RoomScreen.dart';

class NewRoomRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewRoomState();
  }
}

class NewRoomState extends State<NewRoomRoute> {
  final String url = "http://192.168.43.27:1080/";

//  Room room = new Room();
  var room = {};

  List data = ["Speaker №1", "Speaker №2", "Speaker №3", "Speaker №4"];
  int id;

  Future<String> getID() async {
    var res = await http.get(Uri.parse(url + "getNewId"),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      id = resBody["id"];
      room["id"] = id;
    });

    return "Success!";
  }

  Future<String> postList() async {
    room["speakers"] = data;
    var res = await http.post(Uri.parse(url + "post_room"),
        headers: {"Accept": "application/json"}, body: json.encode(room));
    print(json.encode(room));

    setState(() {
      if (json.decode(res.body)["status"] == "ok") {
        _showToast("Комната создана");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VoteListRoute()));
      } else {
        _showToast(
            "Произошла ошибка::${json.decode(res.body)["status"]}");
      }
    });

    return "Success!";
  }

  Widget createNewPlayer(String s, int pos) {
    return Card(
        key: Key(s),
        child: Container(
            child: Wrap(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "$s",
              contentPadding: const EdgeInsets.all(16.0),
              border: InputBorder.none,
            ),
            onChanged: (text) {
              print("Second text field: $text");
              data[pos] = text;
            },
          ),
          RaisedButton(
              child: Icon(Icons.delete_forever),
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).accentColor,
              onPressed: () {
                _showToast(data[pos]);
                setState(() {
                  data.remove(data[pos]);
                });
              })
        ])));
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Wait a second!")),
        body: Container(
          child: Center(child: CupertinoActivityIndicator()),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Room №$id")),
        bottomNavigationBar: RaisedButton(
            child: Text("Создать комнату"),
            textColor: Colors.white,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).accentColor,
            onPressed: () {
              if (data.length < 2) {
                _showToast("Нужно больше спикеров");
              } else {
                this.postList();
              }
            }),
        body: Container(
//          child: Center(
          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: new ListView.builder(
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              createNewPlayer(data[index], index)
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              data.add("Speaker №${data.length + 1}");
            });
          },
          child: Icon(Icons.add),
        ),
//        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    this.getID();
//    this.getSWData();
  }

  _showToast(String s) {
    Toast.show(s, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}

class Room {
  var id = 0;
//  List speakers = new List();
}
