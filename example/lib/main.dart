import 'package:flutter/material.dart';
import 'dart:async';
import './screens/ChannelScreen.dart';
import 'package:flutter/services.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';

void main() {
  runApp(TestClass());
}

class TestClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Demo",
      home: MyApp(),
    );
  }
}

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
    String userId = "5d3669da-6058-4cb6-a02f-ace20f0a54cc";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6NWQzNjY5ZGEtNjA1OC00Y2I2LWEwMmYtYWNlMjBmMGE1NGNjIiwiY2xpZW50IjoiNWQzNjY5ZGEtNjA1OC00Y2I2LWEwMmYtYWNlMjBmMGE1NGNjIiwiZXhwIjoxNTkzMjMxMjY4LCJzdWIiOiI1ZDM2NjlkYS02MDU4LTRjYjYtYTAyZi1hY2UyMGYwYTU0Y2MiLCJ1c2VySWQiOiI1ZDM2NjlkYS02MDU4LTRjYjYtYTAyZi1hY2UyMGYwYTU0Y2MifQ.p5-W9mxkcdvwcb98wtC9tCsgpe4eVr096vUmYoq9GUI";

    var test = await BlaChatSdk.instance.initBlaChatSDK(userId, token);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelScreen(userId)));
  }

  void loginUser2(BuildContext context) async {
    String userId = "a332046b-1e34-419d-b6d4-b555b5d30ab8";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6YTMzMjA0NmItMWUzNC00MTlkLWI2ZDQtYjU1NWI1ZDMwYWI4IiwiY2xpZW50IjoiYTMzMjA0NmItMWUzNC00MTlkLWI2ZDQtYjU1NWI1ZDMwYWI4IiwiZXhwIjoxNTkyOTE4ODUzLCJzdWIiOiJhMzMyMDQ2Yi0xZTM0LTQxOWQtYjZkNC1iNTU1YjVkMzBhYjgiLCJ1c2VySWQiOiJhMzMyMDQ2Yi0xZTM0LTQxOWQtYjZkNC1iNTU1YjVkMzBhYjgifQ.wEnOmhCTI_o3vUWymPrefAg2AqlEuUEcda4xYgwqgPs";
    await BlaChatSdk.instance.initBlaChatSDK(userId, token);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelScreen(userId)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(onPressed: () async {
                loginUser1(context);
              }, child: Text("User 1", style: TextStyle(fontWeight: FontWeight.bold),)),
              RaisedButton(onPressed: () {
                loginUser2(context);
              }, child: Text("User 2",  style: TextStyle(fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
      ),
    );
  }
}
