import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'chatcontainer.dart';

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
  }

  void getChannels() async {
    var channels = await BlaChatSdk.instance.getChannels("", 20);
    if (mounted)
      setState(() {
        _channels = channels;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Channels"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: _channels.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell (
                  onTap: () {
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
}