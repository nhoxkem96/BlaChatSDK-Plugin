import 'package:flutter/material.dart';
import 'dart:core';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';


class CreateChannelScreen extends StatefulWidget {

  String userId;

  CreateChannelScreen(userId);

  @override
  State createState() => new CreateChannelScreenState();

}

class CreateChannelScreenState extends State<CreateChannelScreen> {
  TextEditingController channelName = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void createChannel(String name) async {
    try {
      Map<String, dynamic> customData = Map<String, dynamic>();
      var channel = await BlaChatSdk.instance.createChannel(name, ["e7cc8f40-30f7-41ab-a081-4a31ba6f1279"], BlaChannelType.GROUP, customData);
      Navigator.pop(context);
    } catch (e) {
      print("error create channel " + e);
    }
  }

  void testFunction() async {
    try {
//      var result = await BlaChatSdk.instance.updateChannel(channel);
    } catch (e) {
      print("error test " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create channel"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "name"
                ),
                controller: channelName,
              ),
            ),
            Container(
              height: 20,
            ),
            RaisedButton(
              onPressed: () {

              },
              color: Colors.blue,
              child: Text("Create channel"),
            )
          ],
        ),
      ),
    );
  }
}