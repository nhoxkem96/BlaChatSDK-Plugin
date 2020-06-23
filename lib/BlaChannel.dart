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
    id = data["id"];
    name = data["name"];
    if (data["avatar"] != null) {
      avatar = data["avatar"];
    }
    if (data["createdAt"] != null) {
      createdAt = DateTime.parse(data["createdAt"]);
    }
    if (data["updatedAt"] != null) {
      updatedAt = DateTime.parse(data["updatedAt"]);
    }
    type = BlaUtils.initBlaChannelType(data["type"]);
    customData = data["customData"];
    if (lastMessageId != null) {
      lastMessageId = data["lastMessageId"];
    }
    if (data["lastMessage"] != null) {
      lastMessage = BlaMessage.fromJson(data["lastMessage"]);
    }
    numberMessageUnread = data["numberMessageUnread"];
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "createdAt": createdAt != null ? createdAt.millisecondsSinceEpoch : 0,
    "updatedAt": updatedAt != null ? updatedAt.millisecondsSinceEpoch : 0,
    "type": BlaUtils.getChannelTypeRawValue(type),
    "customData": customData,
    "lastMessageId": lastMessageId != null ? lastMessageId : "",
    "lastMessage": lastMessage != null ? lastMessage.toJson() : null,
    "numberMessageUnread": numberMessageUnread
  };
}
