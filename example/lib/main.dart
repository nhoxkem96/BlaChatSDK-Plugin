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
    String userId = "01d4d812-525e-4cc5-af7f-af9c4f9304f6";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6MDFkNGQ4MTItNTI1ZS00Y2M1LWFmN2YtYWY5YzRmOTMwNGY2IiwiY2xpZW50IjoiMDFkNGQ4MTItNTI1ZS00Y2M1LWFmN2YtYWY5YzRmOTMwNGY2IiwiZXhwIjoxNTkxODQ0ODk0LCJzdWIiOiIwMWQ0ZDgxMi01MjVlLTRjYzUtYWY3Zi1hZjljNGY5MzA0ZjYiLCJ1c2VySWQiOiIwMWQ0ZDgxMi01MjVlLTRjYzUtYWY3Zi1hZjljNGY5MzA0ZjYifQ.h4B45mOreYbTxgFRm9Agu4iLGXwksSlj5nciiOrq7wo";
    print("run here");
    var test = await BlaChatSdk.instance.initBlaChatSDK(userId, token);
    print("test result " + test.toString());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelScreen(userId)));
  }

  void loginUser2(BuildContext context) async {
    String userId = "e7cc8f40-30f7-41ab-a081-4a31ba6f1279";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6ZTdjYzhmNDAtMzBmNy00MWFiLWEwODEtNGEzMWJhNmYxMjc5IiwiY2xpZW50IjoiZTdjYzhmNDAtMzBmNy00MWFiLWEwODEtNGEzMWJhNmYxMjc5IiwiZXhwIjoxNTkxNDEzNjkwLCJzdWIiOiJlN2NjOGY0MC0zMGY3LTQxYWItYTA4MS00YTMxYmE2ZjEyNzkiLCJ1c2VySWQiOiJlN2NjOGY0MC0zMGY3LTQxYWItYTA4MS00YTMxYmE2ZjEyNzkifQ.yWEk56qcm1O1f7sp-3aya6WGQn2U2YfVJlK-f4mgkFc";
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
