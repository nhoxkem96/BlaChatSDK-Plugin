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
  Map<String, dynamic> customData;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime sentAt;
  BlaUser author;
  List<BlaUser> receivedBy;
  List<BlaUser> seenBy;

  BlaMessage.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    authorId = data["authorId"];
    channelId = data["channelId"];
    content = data["content"];
    type = BlaUtils.initBlaMessageType(data["type"]);
    isSystemMessage = data["isSystemMessage"];
    customData = data["customData"];
    createdAt = DateTime.parse(data["createdAt"]);
    updatedAt = data["updatedAt"] != null ? DateTime.parse(data["updatedAt"]) : DateTime.parse(data["createdAt"]);
    sentAt = DateTime.parse(data["sentAt"]);
    author = BlaUser.fromJson(data["author"]);
    List<dynamic> listReceivedBy = data["receivedBy"];
    receivedBy = listReceivedBy.map((item) => BlaUser.fromJson(item)).toList();
    List<dynamic> listSeenBy = data["seenBy"];
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
