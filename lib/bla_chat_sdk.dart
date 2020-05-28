import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'BlaChannel.dart';
import 'BlaMessage.dart';
import 'BlaChannelType.dart';
import 'BlaMessageType.dart';
import 'BlaPresenceState.dart';
import 'BlaUser.dart';
import 'EventType.dart';
import 'BlaConstants.dart';
import 'BlaUtils.dart';
import 'BlaUserPresence.dart';

// Message listener
typedef onNewMessage = Function(BlaMessage message);
typedef onUpdateMessage = Function(BlaMessage message);
typedef onDeleteMessage = Function(BlaMessage message);
typedef onUserSeen = Function(BlaMessage message, BlaUser user, int seenAt);
typedef onUserReceive = Function(BlaMessage message, BlaUser user, int receivedAt);

//Presence listener
typedef onUpdate = Function(List<BlaUserPresence> users);

//Channel listener
typedef onNewChannel = Function(BlaChannel channel);
typedef onUpdateChannel = Function(BlaChannel channel);
typedef onDeleteChannel = Function(BlaChannel channel);
typedef onUserSeenMessage = Function(BlaChannel channel, BlaUser user, BlaMessage message);
typedef onUserReceiveMessage = Function(BlaChannel channel, BlaUser user, BlaMessage message);
typedef onTyping = Function(BlaChannel channel, BlaUser user, EventType eventType);
typedef onMemberJoin = Function(BlaChannel channel, BlaUser user);
typedef onMemberLeave = Function(BlaChannel channel, BlaUser user);

class BlaChatSdk {

  static final BlaChatSdk _singleton = BlaChatSdk._internal();

  factory BlaChatSdk() {
    return _singleton;
  }

  BlaChatSdk._internal();

  static BlaChatSdk get instance {
    return _singleton;
  }


  static const MethodChannel _channel =
      const MethodChannel('bla_chat_sdk');

  Future<String> get platformVersion async {
      final String version = await _channel.invokeMethod('getPlatformVersion');
      return version;
  }

  Future<bool> initBlaChatSDK(String userId, String token) async {
      try {
        dynamic data = await _channel.invokeMethod(BlaConstants.INIT_BLACHATSDK, <String, dynamic>{
          'userId': userId,
          'token': token,
        });
        return true;
      } catch (e) {
        return false;
      }
  }

  Future<bool> addMessageListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.ADD_MESSSAGE_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMessageListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.REMOVE_MESSSAGE_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addChannelListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.ADD_CHANNEL_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeChannelListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.REMOVE_CHANNEL_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPresenceListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.ADD_PRESENCE_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePresenceListener() async {
    try {
      dynamic data = await _channel.invokeMethod(BlaConstants.REMOVE_PRESENCE_LISTENER);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<BlaChannel>> getChannels(String lastId, int limit) async {
      dynamic data = await _channel.invokeMethod(BlaConstants.GET_CHANNELS, <String, dynamic>{
        'lastId': lastId,
        'limit': limit,
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        List<dynamic> result = json.decode(valueMap["result"]);
        List<BlaChannel> channels = result.map((item) => BlaChannel.fromJson(item)).toList();
        return channels;
      } else {
        throw valueMap["message"];
      }
  }

  Future<List<BlaUser>> getUsersInChannel(String channelId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.GET_USERS_IN_CHANNEL, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaUser> users = result.map((item) => BlaUser.fromJson(item)).toList();
      return users;
    } else {
      throw valueMap["message"];
    }
  }

  Future<List<BlaUser>> getUsers(List<String> userIds) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.GET_USERS, <String, dynamic>{
      'userIds': userIds,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaUser> users = result.map((item) => BlaUser.fromJson(item)).toList();
      return users;
    } else {
      throw valueMap["message"];
    }
  }

  Future<List<BlaMessage>> getMessages(String channelId, String lastId, int limit) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.GET_MESSAGES, <String, dynamic>{
      'channelId': channelId,
      'lastId': lastId,
      'limit': limit
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaMessage> messages = result.map((item) => BlaMessage.fromJson(item)).toList();
      return messages;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaChannel> createChannel(String name, List<String> userIds, BlaChannelType type) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_CHANNEL, <String, dynamic>{
      'name': name,
      'userIds': userIds,
      'type': type
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
    print("is success " + isSuccess.toString());
    print("result " + valueMap["result"]);
    return null;
  }

  // PENDING
  Future<BlaChannel> updateChannel(BlaChannel channel) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_CHANNEL, <String, dynamic>{
//      'name': name,
//      'userIds': userIds,
//      'type': type
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
    print("is success " + isSuccess.toString());
    print("result " + valueMap["result"]);
    return null;
  }

  //PENDING
  Future<BlaChannel> deleteChannel(String name, List<String> userIds, BlaChannelType type) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_CHANNEL, <String, dynamic>{
      'name': name,
      'userIds': userIds,
      'type': type
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
    print("is success " + isSuccess.toString());
    print("result " + valueMap["result"]);
    return null;
  }

  Future<bool> sendStartTyping(String channelId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.SEND_START_TYPING, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
    print("is success " + isSuccess.toString());
    print("result " + valueMap["result"]);
    return true;
  }

  Future<bool> sendStopTyping(String channelId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.SEND_STOP_TYPING, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<bool> markSeenMessage(String messageId, String channelId, String receiveId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.MARK_SEEN_MESSAGE, <String, dynamic>{
      'messageId': messageId,
      'channelId': channelId,
      'receiveId': receiveId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<bool> markReceiveMessage(String messageId, String channelId, String receiveId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.MARK_RECEIVE_MESSAGE, <String, dynamic>{
      'messageId': messageId,
      'channelId': channelId,
      'receiveId': receiveId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<BlaMessage> createMessage(String content, String channelId, BlaMessageType type, Map<String, dynamic> customData) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_MESSAGE, <String, dynamic>{
      'content': content,
      'channelId': channelId,
      'type': BlaUtils.getBlaMessageTypeRawValue(type)
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return null;
  }

  //PENDING
  Future<bool> updateMessage(String content, String channelId, BlaMessageType type, Map<String, dynamic> customData) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.UPDATE_MESSAGE, <String, dynamic>{
      'content': content,
      'channelId': channelId,
      'type': BlaUtils.getBlaMessageTypeRawValue(type)
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  //PENDING
   Future<bool> deleteMessage(String content, String channelId, BlaMessageType type, Map<String, dynamic> customData) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.DELETE_MESSAGE, <String, dynamic>{
      'content': content,
      'channelId': channelId,
      'type': BlaUtils.getBlaMessageTypeRawValue(type)
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<bool> inviteUserToChannel(List<String> userIds, String channelId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.INVITE_USER_TO_CHANNEL, <String, dynamic>{
      'userIds': userIds,
      'channelId': channelId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<bool> removeUserFromChannel(String userId, String channelId) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.REMOVE_USER_FROM_CHANNEL, <String, dynamic>{
      'userId': userId,
      'channelId': channelId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<List<BlaUserPresence>> getUserPresence() async {
    dynamic data = await _channel.invokeMethod(BlaConstants.GET_USER_PRESENCE, <String, dynamic>{
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return [];
  }
}
