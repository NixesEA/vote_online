import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VoteListRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoteListState();
  }
}

class VoteListState extends State<VoteListRoute> {

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

  Widget getItem(String s) {
    return ListTile(
      title: Text(s),
      onTap: (){
        setState(() {
          _character = s;
          Toast.show(s, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        });
      },
      leading: Radio(
        value: s,
        groupValue: _character,
//        onChanged: (String value) {
//          setState(() {
//            _character = value;
//
//          });
//        },
      ),
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
                  children: <Widget>[

                    getItem(data[index]["name"])

                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

}
