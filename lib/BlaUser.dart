import 'dart:core';

class BlaUser {
  String id;
  String name;
  String avatar;
  String customData;
  bool online;

  BlaUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    customData = json["customData"];
    online = json["online"];
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
    "customData": customData,
    "online": online,
  };
}