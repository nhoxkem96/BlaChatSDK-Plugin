import 'dart:core';
import 'BlaMessage.dart';
import 'dart:convert';

class BlaChannel {
  String id;
  String name;
  String avatar;
  DateTime createdAt;
  DateTime updatedAt;
  int type;
  String customData;
  String lastMessageId;
  BlaMessage lastMessage;

  BlaChannel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    avatar = data["avatar"];
    createdAt = DateTime.fromMicrosecondsSinceEpoch(data["createdAt"]);
    updatedAt = DateTime.fromMicrosecondsSinceEpoch(data["updatedAt"]);
    type = data["type"];
    customData = data["customData"];
    lastMessageId = data["lastMessageId"];
    if (data["lastMessage"] != null) {
      lastMessage = BlaMessage.fromJson(data["lastMessage"]);
    }
  }
}
