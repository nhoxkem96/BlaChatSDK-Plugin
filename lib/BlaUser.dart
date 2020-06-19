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
    avatar = data["avatar"];
    customData = data["customData"];
    online = data["online"];
    lastActiveAt = DateTime.parse(data["lastActiveAt"]);
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