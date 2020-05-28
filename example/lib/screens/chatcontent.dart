import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';
import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
//import 'package:blachat/models/cursor.dart';
import 'message_item.dart';
import 'package:bla_chat_sdk/BlaMessageType.dart';


class ChatContent extends StatefulWidget {

  String channelID;

  String myID;

  ChatContent(this.channelID, this.myID);

  @override
  State createState() => new ChatContentState(channelID, myID);
}

class ChatContentState extends State<ChatContent> {
  final TextEditingController _chatController = new TextEditingController();
  List<BlaMessage> listMessage = <BlaMessage>[];

  Map<String, BlaUser> mapMembers = Map();

  String channelID;

  String myID;

  DateTime lastReceiveMyMessage;

  DateTime lastSeenMyMessage;


  ChatContentState(this.channelID, this.myID);

  bool isTyping = false;

  void initState() {
    super.initState();
    getMembersOnChannel();
    getMessage();

//    Blachat.instance.getReceiveCursor(channelID).then((List<ChannelCursor> cursors) {
//      if (cursors.length > 0){
//        var _lastReceiveMyMessage = cursors[0].time;
//        for (int i = 1; i < cursors.length; i++) {
//          if (_lastReceiveMyMessage.millisecondsSinceEpoch < cursors[i].time.millisecondsSinceEpoch) {
//            _lastReceiveMyMessage = cursors[i].time;
//          }
//        }
//
//        if (mounted) {
//          setState(() {
//            this.lastReceiveMyMessage = _lastReceiveMyMessage;
//          });
//        }
//
//      }
//    });
//
//    Blachat.instance.getSeenCursor(channelID).then((List<ChannelCursor> cursors) {
//      if (cursors.length > 0){
//        var _lastSeenMyMessage = cursors[0].time;
//        for (int i = 1; i < cursors.length; i++) {
//          if (_lastSeenMyMessage.millisecondsSinceEpoch < cursors[i].time.millisecondsSinceEpoch) {
//            _lastSeenMyMessage = cursors[i].time;
//          }
//        }
//        if (mounted){
//          setState(() {
//            this.lastSeenMyMessage = _lastSeenMyMessage;
//          });
//        }
//      }
//    });
//
//    Blachat.instance.addMessageEventListener((MessageEvent type, ChannelCursor cursor) {
//      if (cursor.channelID == this.channelID && mounted) {
//        switch (type) {
//          case MessageEvent.RECEIVED: {
//            setState(() {
//              lastReceiveMyMessage = cursor.time;
//            });
//            break;
//          }
//          case MessageEvent.SEEN: {
//            setState(() {
//              lastSeenMyMessage = cursor.time;
//            });
//            break;
//          }
//        }
//      }
//    });

//    BlaChatSdk.instance.addMessageListener((BlaMessage message) {
//      if (message.channelID == channelID){
//        if (mounted) {
//          if (message.authorID != myID) {
//            Blachat.instance.sendMarkSeenEvent(channelID, message.id, message.authorID);
//          }
//          setState(() {
//            listMessage.insert(0, message);
//          });
//        }
//      }
//    });

//    _chatController.addListener(() {
//      if (_chatController.text.isEmpty){
//        isTyping = false;
//        Blachat.instance.sendStopTyping(channelID);
//      } else if (_chatController.text.isNotEmpty && isTyping == false) {
//        isTyping = true;
//        Blachat.instance.sendTyping(channelID);
//      }
//
//    });
  }

  void getMembersOnChannel() async {
    var members = await BlaChatSdk.instance.getUsersInChannel(channelID);
    if (mounted){
      setState(() {
        members.forEach((e) {
          mapMembers[e.id] = e;
        });
      });
    } else {
      members.forEach((e) {
        mapMembers[e.id] = e;
      });
    }
  }

  void getMessage() async {
    var messages = await BlaChatSdk.instance.getMessages(channelID, "", 20);
    if (mounted) {
      setState(() {
        listMessage.insertAll(0, messages);
      });
    }
  }

  void _handleSubmit(String text) async {
    _chatController.clear();
    var message = await BlaChatSdk.instance.createMessage(text, this.channelID, BlaMessageType.TEXT, null);
    if (mounted) {
      setState(() {
        listMessage.insert(0, message);
      });
    }
  }

  Widget _chatEnvironment (){
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Start typing ..."),
                controller: _chatController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: ()=> _handleSubmit(_chatController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            semanticChildCount: 1,
            itemBuilder: (_, int index) {
              if (listMessage[index].authorId == myID){
                return OutComingMessage(
                    message: listMessage[index],
                    user: mapMembers[listMessage[index].authorId],
                    lastReceiveMyMessage: lastReceiveMyMessage,
                    lastSeenMyMessage: lastSeenMyMessage
                );
              } else {
                return InComingMessage(
                  message: listMessage[index],
                  user: mapMembers[listMessage[index].authorId],
                );
              }
            },
            itemCount: listMessage.length,
          ),
        ),

        new Divider(
          height: 1.0,
        ),
        new Container(decoration: new BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
          child: _chatEnvironment(),)
      ],
    );
  }
}