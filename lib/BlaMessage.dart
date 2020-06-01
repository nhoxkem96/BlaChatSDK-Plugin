import 'dart:core';
import 'BlaMessageType.dart';
import 'BlaUser.dart';
import 'BlaUtils.dart';

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
    id = json["id"];
    authorId = json["authorId"];
    channelId = json["channelId"];
    content = json["content"];
    type = BlaUtils.initBlaMessageType(json["type"]);
    isSystemMessage = json["isSystemMessage"];
    customData = json["customData"];
    createdAt = DateTime.fromMicrosecondsSinceEpoch(json["createdAt"]);
    updatedAt = json["updatedAt"] != null ? DateTime.fromMicrosecondsSinceEpoch(json["updatedAt"]) : DateTime.fromMicrosecondsSinceEpoch(json["createdAt"]);
    sentAt = DateTime.fromMicrosecondsSinceEpoch(json["sentAt"]);
    author = BlaUser.fromJson(json["author"]);
    List<dynamic> listReceivedBy = json["receivedBy"];
    receivedBy = listReceivedBy.map((item) => BlaUser.fromJson(item)).toList();
    List<dynamic> listSeenBy = json["seenBy"];
    seenBy = listSeenBy.map((item) => BlaUser.fromJson(item)).toList();
  }
}
