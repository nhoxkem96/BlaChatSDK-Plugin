import 'dart:core';
import 'BlaMessageType.dart';
import 'BlaUser.dart';

class BlaMessage {
  String id;
  String channelID;
  String content;
  BlaMessageType type;
  String customData;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime sentAt;
  BlaUser author;
  List<BlaUser> receivedBy;
  List<BlaUser> seenBy;

  BlaMessage.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    channelID = json["channelID"];
    content = json["content"];
    id = json["id"];
    id = json["id"];
    id = json["id"];
    id = json["id"];
    id = json["id"];
    id = json["id"];

  }
}
