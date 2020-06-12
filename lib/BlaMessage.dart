import 'dart:core';
import 'BlaMessageType.dart';
import 'BlaUser.dart';
import 'BlaUtils.dart';
import 'dart:convert';

class BlaMessage {
  String id;
  String authorId;
  String channelId;
  String content;
  BlaMessageType type;
  bool isSystemMessage;
  String customData;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime sentAt;
  BlaUser author;
  List<BlaUser> receivedBy;
  List<BlaUser> seenBy;

  BlaMessage.fromJson(Map<String, dynamic> json) {
    print("parse message " + json.toString());
    id = json["id"];
    authorId = json["authorId"];
    channelId = json["channelId"];
    content = json["content"];
    type = BlaUtils.initBlaMessageType(json["type"]);
    isSystemMessage = json["isSystemMessage"];
    customData = json["customData"].toString();
    createdAt = DateTime.parse(json["createdAt"]);
    updatedAt = json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : DateTime.parse(json["createdAt"]);
    sentAt = DateTime.parse(json["sentAt"]);
    author = BlaUser.fromJson(json["author"]);
    List<dynamic> listReceivedBy = json["receivedBy"];
    receivedBy = listReceivedBy.map((item) => BlaUser.fromJson(item)).toList();
    List<dynamic> listSeenBy = json["seenBy"];
    seenBy = listSeenBy.map((item) => BlaUser.fromJson(item)).toList();
  }

  Map toJson() => {
    "id": id,
    "authorId": authorId,
    "channelId": channelId,
    "content": content,
    "type": BlaUtils.getBlaMessageTypeRawValue(type),
    "isSystemMessage": isSystemMessage,
    "customData": customData,
    "createdAt": createdAt.millisecondsSinceEpoch,
    "updatedAt": updatedAt.millisecondsSinceEpoch,
    "sentAt": sentAt.millisecondsSinceEpoch,
    "author": author.toJson(),
    "receivedBy": jsonEncode(receivedBy.map((item) => item.toJson()).toList()),
    "seenBy": jsonEncode(seenBy.map((item) => item.toJson()).toList()),
  };
}
