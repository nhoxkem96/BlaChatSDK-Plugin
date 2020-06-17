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
    String userId = "817540b0-b471-429d-a6bb-ad5fa755b837";
    String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6ODE3NTQwYjAtYjQ3MS00MjlkLWE2YmItYWQ1ZmE3NTViODM3IiwiY2xpZW50IjoiODE3NTQwYjAtYjQ3MS00MjlkLWE2YmItYWQ1ZmE3NTViODM3IiwiZXhwIjoxNTk0OTczOTUyLCJzdWIiOiI4MTc1NDBiMC1iNDcxLTQyOWQtYTZiYi1hZDVmYTc1NWI4MzciLCJ1c2VySWQiOiI4MTc1NDBiMC1iNDcxLTQyOWQtYTZiYi1hZDVmYTc1NWI4MzcifQ.vp_j5VPaRwnBEa37k3LJYpc8ZgRBrCyYV3LV0ZoY4rU";
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
