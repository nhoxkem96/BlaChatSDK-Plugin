import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'chatcontainer.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:bla_chat_sdk/EventType.dart';
import 'CreateChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';

class ChannelScreen extends StatefulWidget {

  String userId;

  ChannelScreen(this.userId);

  @override
  State createState() => new ChannelScreenState(this.userId);
}

class ChannelScreenState extends State<ChannelScreen> {

  List<BlaChannel> _channels = [];
  String userId;

  ChannelScreenState(this.userId);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChannels();
    this.addListener();
  }

  void addListener() async {
    await BlaChatSdk.instance.addChannelListener(new ChannelListener(
      onTyping: (BlaChannel channel, BlaUser user, EventType type) {
        print("onTyping in channel screen");
      }
    ));

    await BlaChatSdk.instance.addMessageListener(new MessageListener(
        onNewMessage: (message) {
          print("have new message in channel screen: " + message.content);
        }
    ));
  }

  void getChannels() async {
    var channels = await BlaChatSdk.instance.getChannels("", 20);
    if (mounted)
      setState(() {
        _channels = channels;
      });
  }

  void testFunction(BlaChannel channel) async {
    try {
      var result = await BlaChatSdk.instance.inviteUserToChannel(["b8678c7a-82f3-4a1b-b8c4-9b3cce391c20", "8c8c21b3-22e9-48a5-833c-5d25a9d5597f"], channel.id);
    } catch (e) {
      print("error test " + e.toString());
    }
  }

  void createChannel(String name) async {
    try {
      Map<String, dynamic> customData = Map<String, dynamic>();
      customData["test"] = "haha";
      customData["test number"] = 1;
      var channel = await BlaChatSdk.instance.createChannel(name, ["e7cc8f40-30f7-41ab-a081-4a31ba6f1279"], BlaChannelType.GROUP, customData);
      Navigator.pop(context);
    } catch (e) {
      print("error create channel " + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Channels"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
//              print("run here");
//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => CreateChannelScreen(this.userId)),
//              );
              this.createChannel("test");
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _channels.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell (
                  onTap: () {
//                    this.testFunction(_channels[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatContainer(_channels[index].id, userId)),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.all(8),
                      child: new Row (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(_channels[index].avatar.isEmpty ? "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png" : _channels[index].avatar)
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  _channels[index].name,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                new Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(_channels[index].lastMessage != null ? _channels[index].lastMessage.content : ""),
                                    ],
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  )
              );
            }
        ),
      ),
    );
  }

  @override
  void onTyping(String test) {
    // TODO: implement onTyping
    print("ghahahaha " + test);
  }
}