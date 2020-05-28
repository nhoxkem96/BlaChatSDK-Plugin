import 'package:flutter/material.dart';
import 'package:bla_chat_sdk/BlaMessage.dart';
import 'package:bla_chat_sdk/BlaUser.dart';
import 'package:intl/intl.dart';


const marginItem = EdgeInsets.fromLTRB(0, 0, 4, 4);

Widget _renderContentMessage(BlaMessage message, BlaUser user, bool isIncoming, DateTime lastReceive, DateTime lastSeen) {
  return StringMessageContent(
      message,
      user,
      !isIncoming,
      isIncoming ? Colors.black : Colors.white,
      isIncoming ? Colors.black : Colors.white,
      isIncoming ? const Color(0xffE6E6E6) : Colors.blue,
      lastReceive,
      lastSeen
  );
}

class InComingMessage extends StatelessWidget {
  InComingMessage({this.message, this.user});

  final BlaMessage message;

  BlaUser user;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: marginItem,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(user == null ? "https://www.pngkey.com/png/detail/115-1150152_default-profile-picture-avatar-png-green.png" : user.avatar),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                constraints: new BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 60),
                child: _renderContentMessage(message, user, true, null, null),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OutComingMessage extends StatelessWidget {
  final BlaMessage message;

  BlaUser user;

  DateTime lastReceiveMyMessage;

  DateTime lastSeenMyMessage;


  OutComingMessage({this.message, this.user, this.lastReceiveMyMessage,
    this.lastSeenMyMessage});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: marginItem,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                constraints: new BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 60),
                child: _renderContentMessage(message, user, false, lastReceiveMyMessage, lastSeenMyMessage),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class StringMessageContent extends StatelessWidget {
  final BlaMessage message;

  final Color textColor;

  final Color timeColor;

  final Color backgroundColor;

  bool isOutComing;

  BlaUser user;

  DateTime lastReceiveMyMessage;

  DateTime lastSeenMyMessage;

  StringMessageContent(
      this.message, this.user, this.isOutComing, this.textColor, this.timeColor, this.backgroundColor, this.lastReceiveMyMessage, this.lastSeenMyMessage);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  constraints: new BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 80
                  ),
                  child: Text(
                    message.content,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 15,
                        color: textColor
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.all(8),
                alignment: new Alignment(-1.0, 1.0),
                child:  Text(
                  _timeStatusOfMessage(message, isOutComing, this.lastReceiveMyMessage, this.lastSeenMyMessage),
                  style: TextStyle(fontSize: 12.0, color: timeColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

String _timeStatusOfMessage(BlaMessage message, bool isOutComing, DateTime lastReceive, DateTime lastSeen) {

  if (isOutComing){
    if (lastSeen != null && message.createdAt.millisecondsSinceEpoch < lastSeen.millisecondsSinceEpoch)
      return "${DateFormat("hh:mm").format(message.createdAt)} Seen";
    if (lastReceive != null && message.createdAt.millisecondsSinceEpoch < lastReceive.millisecondsSinceEpoch)
      return "${DateFormat("hh:mm").format(message.createdAt)} Received";
    return DateFormat("hh:mm").format(message.createdAt);
  } else {
    return DateFormat("hh:mm").format(message.createdAt);
  }
}

