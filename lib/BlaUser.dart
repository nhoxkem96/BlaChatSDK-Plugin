import 'dart:core';

class BlaUser {
  String id;
  String name;
  String avatar;
  Map<String, dynamic> customData;
  bool online;
  DateTime lastActiveAt;

  BlaUser.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    if (data["avatar"] != null) {
      avatar = data["avatar"];
    }
    if (data["customData"] != null) {
      customData = data["customData"];
    }
    if (data["online"] != null) {
      online = data["online"];
    }
    if (data["lastActiveAt"] != null) {
      lastActiveAt = DateTime.parse(data["lastActiveAt"]);
    }
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "customData": customData,
    "online": online,
    "lastActiveAt": lastActiveAt
  };
}