import 'dart:core';
import 'BlaMessage.dart';
import 'dart:convert';
import 'BlaUtils.dart';
import 'BlaChannelType.dart';

class BlaChannel {
  String id;
  String name;
  String avatar;
  DateTime createdAt;
  DateTime updatedAt;
  BlaChannelType type;
  Map<String, dynamic> customData;
  String lastMessageId;
  BlaMessage lastMessage;
  String numberMessageUnread;

  BlaChannel.fromJson(Map<String, dynamic> data) {
    print(data);
    id = data["id"];
    name = data["name"];
    if (data["avatar"] != null) {
      avatar = data["avatar"];
    }
    if ((data["createdAt"] as String).isNotEmpty){
      createdAt = DateTime.parse(data["createdAt"]);
    }

    if ((data["updatedAt"] as String).isNotEmpty){
      updatedAt = DateTime.parse(data["updatedAt"]);
    }

    type = BlaUtils.initBlaChannelType(data["type"]);
    customData = data["customData"];
    lastMessageId = data["lastMessageId"];
    if (data["lastMessage"] != null) {
      lastMessage = BlaMessage.fromJson(data["lastMessage"]);
    }
    numberMessageUnread = data["numberMessageUnread"];
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "createdAt": createdAt.millisecondsSinceEpoch,
    "updatedAt": updatedAt.millisecondsSinceEpoch,
    "type": type,
    "customData": customData,
    "lastMessageId": lastMessageId,
    "lastMessage": lastMessage.toJson(),
    "numberMessageUnread": numberMessageUnread
  };
}
