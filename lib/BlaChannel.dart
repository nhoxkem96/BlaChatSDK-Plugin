import 'dart:core';

class BlaChannel {
  String id;
  String name;
  String avatar;
  DateTime createdAt;
  DateTime updatedAt;
  int type;
  String customData;
  String lastMessageId;

  BlaChannel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    createdAt = DateTime.fromMicrosecondsSinceEpoch(json["createdAt"]);
    updatedAt = DateTime.fromMicrosecondsSinceEpoch(json["updatedAt"]);
    type = json["type"];
    customData = json["customData"];
    lastMessageId = json["lastMessageId"];
  }
}
