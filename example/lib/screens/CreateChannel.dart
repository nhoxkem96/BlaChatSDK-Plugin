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
      var channel = BlaChatSdk.instance.createChannel(name, ["e7cc8f40-30f7-41ab-a081-4a31ba6f1279"], BlaChannelType.GROUP);
      Navigator.pop(context);
    } catch (e) {
      print("error create channel " + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "name"
            ),
            controller: channelName,
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
    );
  }
}