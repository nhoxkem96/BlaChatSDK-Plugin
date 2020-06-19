import 'dart:core';
import 'BlaMessage.dart';
import 'dart:convert';

class BlaChannel {
  String id;
  String name;
  String avatar;
  DateTime createdAt;
  DateTime updatedAt;
  BlaChannel type;
  Map<String, dynamic> customData;
  String lastMessageId;
  BlaMessage lastMessage;
  String numberMessageUnread;

  BlaChannel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    avatar = data["avatar"];
    createdAt = DateTime.parse(data["createdAt"]);
    updatedAt = DateTime.parse(data["updatedAt"]);
    type = data["type"];
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
