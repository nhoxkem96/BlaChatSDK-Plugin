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
    String userId = "a883f925-e8b8-48df-a9f3-c5ed988018b7";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6YTg4M2Y5MjUtZThiOC00OGRmLWE5ZjMtYzVlZDk4ODAxOGI3IiwiY2xpZW50IjoiYTg4M2Y5MjUtZThiOC00OGRmLWE5ZjMtYzVlZDk4ODAxOGI3IiwiZXhwIjoxNTk4NzU0NTk3LCJzdWIiOiJhODgzZjkyNS1lOGI4LTQ4ZGYtYTlmMy1jNWVkOTg4MDE4YjciLCJ1c2VySWQiOiJhODgzZjkyNS1lOGI4LTQ4ZGYtYTlmMy1jNWVkOTg4MDE4YjcifQ.0CdFp6YNNTJot_V-54q5mIdGRh3wNdn31zTnlcvqqr0";
    var test = await BlaChatSdk.instance.initBlaChatSDK(userId, token);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChannelScreen(userId)));
  }

  void loginUser2(BuildContext context) async {
    String userId = "fb36cadb-5f6c-4dec-9e8e-4b1dd7940e11";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6ZmIzNmNhZGItNWY2Yy00ZGVjLTllOGUtNGIxZGQ3OTQwZTExIiwiY2xpZW50IjoiZmIzNmNhZGItNWY2Yy00ZGVjLTllOGUtNGIxZGQ3OTQwZTExIiwiZXhwIjoxNTk0OTc0MDcwLCJzdWIiOiJmYjM2Y2FkYi01ZjZjLTRkZWMtOWU4ZS00YjFkZDc5NDBlMTEiLCJ1c2VySWQiOiJmYjM2Y2FkYi01ZjZjLTRkZWMtOWU4ZS00YjFkZDc5NDBlMTEifQ.Fr7hKpbRr5lFzF6FdApI5V-Eht-JO1omx7Gxx9_Tn8Q";
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
