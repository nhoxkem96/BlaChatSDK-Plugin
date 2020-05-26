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
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String userId = "01d4d812-525e-4cc5-af7f-af9c4f9304f6";
      String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaGFubmVsIjoiJGNoYXQ6MDFkNGQ4MTItNTI1ZS00Y2M1LWFmN2YtYWY5YzRmOTMwNGY2IiwiY2xpZW50IjoiMDFkNGQ4MTItNTI1ZS00Y2M1LWFmN2YtYWY5YzRmOTMwNGY2IiwiZXhwIjoxNTkxODQ0ODk0LCJzdWIiOiIwMWQ0ZDgxMi01MjVlLTRjYzUtYWY3Zi1hZjljNGY5MzA0ZjYiLCJ1c2VySWQiOiIwMWQ0ZDgxMi01MjVlLTRjYzUtYWY3Zi1hZjljNGY5MzA0ZjYifQ.h4B45mOreYbTxgFRm9Agu4iLGXwksSlj5nciiOrq7wo";
      bool testFunction = await BlaChatSdk.initBlaChatSDK(userId, token);
      print("plat form version " + await BlaChatSdk.platformVersion);
      platformVersion = await BlaChatSdk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
              Text('Running on: $_platformVersion\n'),
              FlatButton(onPressed: () async {
                await BlaChatSdk.getChannels("", 20);
              }, child: Text("Get Channels")),
              FlatButton(onPressed: () async {
//                await BlaChatSdk.getChannels();
              }, child: Text("Get Messages")),
              FlatButton(onPressed: () async {
//                await BlaChatSdk.getChannels();
              }, child: Text("Get User in channels")),
              FlatButton(onPressed: () async {
//                await BlaChatSdk.getChannels();
              }, child: Text("Get user"))

            ],
          ),
        ),
      ),
    );
  }
}
