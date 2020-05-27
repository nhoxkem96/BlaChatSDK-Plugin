import 'dart:core';

class BlaUser {
  String id;
  String name;
  String avatar;
  String customData;
  bool online;
//  DateTime lastActiveAt;

  BlaUser.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    customData = json["customData"];
    online = json["online"];
//    lastActiveAt = DateTime.fromMicrosecondsSinceEpoch(json["lastActiveAt"]);
  }
}