import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main.dart' as main;

class VoteListRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoteListState();
  }
}

class VoteListState extends State<VoteListRoute> {
  String _character;

  final String url = "http://192.168.43.27:1081/";
//  final String url = "http://92.100.133.166:1081/";
  Map<String, int> data;
  var id;
  int rawId;
  var flag = true;

  Future<String> getVoteData() async {
    var res = await http.get(Uri.parse(url + "vote_room?id=$id"),
        headers: {"Accept": "application/json"});

    setState(() {
      print(json.decode(res.body));
      var resBody = json.decode(res.body);
      id = resBody["id"];
      data = (resBody["speakers"] as Map<String, dynamic>).cast<String, int>();
      main.MainScreen.add(id.toString());
    });
    return "Success!";
  }

  Future<String> postVote() async {
    var res = await http.get(
        Uri.parse(url + "post_vote?id=$id&vote=$_character"),
        headers: {"Accept": "application/json"});

    setState(() {
      if (json.decode(res.body)["status"] == "ok") {
        _showToast("Голос отправлен");
        flag = false;
      } else {
        _showToast("Произошла ошибка::${json.decode(res.body)["status"]}");
      }
    });

    return "Success!";
  }

  Future<String> connectToRoom() async {
    var res = await http.get(Uri.parse(url + "vote_room?id=$rawId"),
        headers: {"Accept": "application/json"});

    setState(() {
      print(json.decode(res.body));
      var resBody = json.decode(res.body);
      id = resBody["id"];
      data = (resBody["speakers"] as Map<String, dynamic>).cast<String, int>();
      main.MainScreen.add(id.toString());
    });
    return "Success!";
  }

  Widget getItem(int s) {
    var keys = data.keys.toList();

    return ListTile(
      title: Text("${keys[s]}::${data[keys[s]].toString()}"),
      onTap: () {
        setState(() {
          _character = keys[s].toString();
          Toast.show(_character, context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        });
      },
      leading: Radio(
        value: keys[s],
        groupValue: _character,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      if (rawId == null) {
        return Scaffold(
          appBar: AppBar(title: Text("Wait a second!")),
          body: Container(
              child: Center(
                  child: Card(
                      child: Container(
                          child: Wrap(children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Room Number",
                contentPadding: const EdgeInsets.all(16.0),
                border: InputBorder.none,
              ),
              onChanged: (text) {
                print("RawId text field: $text");
                rawId = int.parse(text);
              },
            ),
            RaisedButton(
                child: Icon(Icons.cast_connected),
                textColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  setState(() {
                    if (main.MainScreen.s.contains(rawId.toString())){
                      id = rawId;
                      flag = false;
                      this.getVoteData();
                    }else{
                      this.connectToRoom();
                    }
                  });
                })
          ]))))),
        );
      } else {
        return Scaffold(
          appBar: AppBar(title: Text("Wait a second!")),
          body: Container(
            child: Center(child: CupertinoActivityIndicator()),
          ),
        );
      }
    } else {
      if (flag) {
        return Scaffold(
          appBar: AppBar(title: Text("Room №$id")),
          bottomNavigationBar: RaisedButton(
              child: Text("Отправить выбор"),
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).accentColor,
              onPressed: () {
                this.postVote();
              }),
          body: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[getItem(index)],
                    ),
                  ),
                );
              }),
        );
      } else {
        return Scaffold(
          appBar: AppBar(title: Text("Room №$id")),
          bottomNavigationBar: RaisedButton(
              child: Text("Обновить"),
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).accentColor,
              onPressed: () {
                this.getVoteData();
              }),
          body: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[getItem(index)],
                    ),
                  ),
                );
              }),
        );
      }
    }
  }

  Future initImei() async {
//    imei = await ImeiPlugin.getImei;
  }

  _showToast(String s) {
    Toast.show(s, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  void initState() {
    super.initState();

    this.getVoteData();
  }
}
