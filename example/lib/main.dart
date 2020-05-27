import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  void loginUser1(BuildContext context) async {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(onPressed: null, child: Text("User 1")),
              FlatButton(onPressed: () async {
                await BlaChatSdk.getChannels("", 20);
              }, child: Text("Get Channels")),
              FlatButton(onPressed: () async {
                await BlaChatSdk.getUsersInChannel("25f3ccfe-3413-4604-ba24-85244358c6d0");
              }, child: Text("getUsersInChannel")),
              FlatButton(onPressed: () async {
                await BlaChatSdk.getUsers(["2d71add9-9fc2-448e-b3b0-036504040fbd", "625aab97-8331-4037-9904-4192f68378e2"]);
              }, child: Text("Get User in channels")),
              FlatButton(onPressed: () async {
                await BlaChatSdk.getMessages("25f3ccfe-3413-4604-ba24-85244358c6d0", "", 20);
              }, child: Text("Get message"))

            ],
          ),
        ),
      ),
    );
  }
}
