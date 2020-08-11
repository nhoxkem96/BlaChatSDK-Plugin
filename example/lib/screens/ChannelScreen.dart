import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/BlaChannel.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:intl/intl.dart';
import 'chatcontainer.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:bla_chat_sdk/EventType.dart';
import 'CreateChannel.dart';
import 'package:bla_chat_sdk/BlaChannelType.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';

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
        onTyping: (BlaChannel channel, BlaUser user, EventType tyzpe) {
      print("onTyping in channel screen");
    }, onUpdateChannel: (BlaChannel channel) {
      print("on update channel ");
    }, onDeleteChannel: (String channelId) {
      print("delete channel");
    }, onNewChannel: (BlaChannel channel) {
          print("on new channel");
    }));

    await BlaChatSdk.instance
        .addMessageListener(new MessageListener(onNewMessage: (message) {
      print("have new message in channel screen: " + message.content);
    }, onDeleteMessage: (messageId) {
      print('delete message id');
    }));
    await BlaChatSdk.instance
        .addPresenceListener(new PresenceListener(onUpdate: (users) {
      print("on update presence " + users.length.toString());
    }));
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
      Map<String, dynamic> customData = Map<String, dynamic>();
      customData["test message"] = "haha";
      customData["test number"] = 1;
//      var result = await BlaChatSdk.instance.createMessage("text", channel.id, BlaMessageType.TEXT, null);
//      print("call back " + result.toString());
//       var test = await BlaChatSdk.instance.deleteMessage(channel.lastMessage);
      var test = await BlaChatSdk.instance.markSeenMessage(channel.lastMessage.id, channel.id);
       print("haha " + test.toString());
    } catch (e) {
      print("error test " + e.toString());
    }
  }

  void createChannel(String name) async {
    try {
      Map<String, dynamic> customData = Map<String, dynamic>();
      customData["test"] = "haha";
      customData["test number"] = 1;
      var channel = await BlaChatSdk.instance.createChannel(
          name,
          "",
          ["e7cc8f40-30f7-41ab-a081-4a31ba6f1279"],
          BlaChannelType.GROUP,
          customData);
      Navigator.pop(context);
    } catch (e) {
      print("error create channel " + e);
    }
  }

  String conversationTime(DateTime date) {
    var dayFormat = DateFormat("dd/MM/yyyy");
    var dateString = dayFormat.format(date);
    var nowString = dayFormat.format(DateTime.now());
    var diff =
        dayFormat.parse(nowString).difference(dayFormat.parse(dateString));
    var time = '';
    if (diff.inDays == 0) {
      var format = DateFormat('HH:mm');
      time = format.format(date);
    } else if (diff.inDays == 1) {
      time = 'Hôm qua';
    } else {
      var format = DateFormat('dd/MM');
      time = format.format(date);
    }
    return time;
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
              return InkWell(
                  onTap: () {
                    this.testFunction(_channels[index]);
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => ChatContainer(_channels[index].id, userId)),
//                    );
                  },
                  child: Container(
                      margin: EdgeInsets.all(8),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(_channels[index]
                                          .avatar ==
                                      null
                                  ? "http://icons.iconarchive.com/icons/papirus-team/papirus-status/256/avatar-default-icon.png"
                                  : _channels[index].avatar)),
                          new Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Text(
                                        _channels[index].name != null
                                            ? _channels[index].name
                                            : '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          conversationTime(
                                              _channels[index].updatedAt),
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  new Container(
                                      margin: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              _channels[index].lastMessage != null
                                                  ? _channels[index]
                                                  .lastMessage
                                                  .content
                                                  : ""),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      )));
            }),
      ),
    );
  }

  @override
  void onTyping(String test) {
    // TODO: implement onTyping
    print("ghahahaha " + test);
  }
}
