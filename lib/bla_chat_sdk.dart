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

class MessageListener {

  MessageListener({this.onNewMessage, this.onUpdateMessage, this.onDeleteMessage, this.onUserSeen, this.onUserReceive});

  Function(BlaMessage message) onNewMessage;
  Function(BlaMessage message) onUpdateMessage;
  Function(BlaMessage message) onDeleteMessage;
  Function(BlaMessage message, BlaUser user, DateTime seenAt) onUserSeen;
  Function(BlaMessage message, BlaUser user, DateTime receivedAt) onUserReceive;
}

class PresenceListener {

  PresenceListener({this.onUpdate});

  Function(List<BlaUserPresence> users) onUpdate;
}

class ChannelListener {

  ChannelListener({this.onNewChannel, this.onUpdateChannel, this.onDeleteChannel,
    this.onUserSeenMessage, this.onUserReceiveMessage, this.onTyping, this.onMemberJoin, this.onMemberLeave});

  Function(BlaChannel channel) onNewChannel;
  Function(BlaChannel channel) onUpdateChannel;
  Function(BlaChannel channel) onDeleteChannel;
  Function(BlaChannel channel, BlaUser user, BlaMessage message) onUserSeenMessage;
  Function(BlaChannel channel, BlaUser user, BlaMessage message) onUserReceiveMessage;
  Function(BlaChannel channel, BlaUser user, EventType eventType) onTyping;
  Function(BlaChannel channel, BlaUser user) onMemberJoin;
  Function(BlaChannel channel, BlaUser user) onMemberLeave;
}

class BlaChatSdk {
  static final BlaChatSdk _singleton = BlaChatSdk._internal();

  List<ChannelListener> channelListeners = [];
  List<PresenceListener> presenceListeners = [];
  List<MessageListener> messageListeners = [];


  factory BlaChatSdk() {
    return _singleton;
  }

  BlaChatSdk._internal();

  static BlaChatSdk get instance {
    return _singleton;
  }

  static const MethodChannel _channel = const MethodChannel('bla_chat_sdk');

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> initBlaChatSDK(String userId, String token) async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.INIT_BLACHATSDK, <String, dynamic>{
        'userId': userId,
        'token': token,
      });
      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case "onNewMessage": {
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            for (MessageListener listener in messageListeners) {
              listener.onNewMessage(message);
            }
            break;
          }
          case "onUpdateMessage": {
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            for (MessageListener listener in messageListeners) {
              listener.onUpdateMessage(message);
            }
            break;
          }
          case "onDeleteMessage": {
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            for (MessageListener listener in messageListeners) {
              listener.onDeleteMessage(message);
            }
            break;
          }
          case "onUserSeen": {
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            var seenAt = DateTime.fromMillisecondsSinceEpoch(call.arguments["seenAt"]);
            for (MessageListener listener in messageListeners) {
              listener.onUserSeen(message, user, seenAt);
            }
            break;
          }
          case "onUserReceive": {
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            var seenAt = DateTime.fromMillisecondsSinceEpoch(call.arguments["seenAt"]);
            for (MessageListener listener in messageListeners) {
              listener.onUserReceive(message, user, seenAt);
            }
            break;
          }
          case "onUpdate": {

            break;
          }
          case "onNewChannel": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            for (ChannelListener listener in channelListeners) {
              listener.onNewChannel(channel);
            }
            break;
          }
          case "onUpdateChannel": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            for (ChannelListener listener in channelListeners) {
              listener.onUpdateChannel(channel);
            }
            break;
          }
          case "onDeleteChannel": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            for (ChannelListener listener in channelListeners) {
              listener.onDeleteChannel(channel);
            }
            break;
          }
          case "onUserSeenMessage": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            for (ChannelListener listener in channelListeners) {
              listener.onUserSeenMessage(channel, user, message);
            }
            break;
          }
          case "onUserReceiveMessage": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            var message = BlaMessage.fromJson(json.decode(call.arguments["message"]));
            for (ChannelListener listener in channelListeners) {
              listener.onUserReceiveMessage(channel, user, message);
            }
            break;
          }
          case "onTyping": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            var type = BlaUtils.initEventType(call.arguments["type"]);
            for (ChannelListener listener in channelListeners) {
              listener.onTyping(channel, user, type);
            }
            break;
          }
          case "onMemberJoin": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            for (ChannelListener listener in channelListeners) {
              listener.onMemberJoin(channel, user);
            }
            break;
          }
          case "onMemberLeave": {
            var channel = BlaChannel.fromJson(json.decode(call.arguments["channel"]));
            var user = BlaUser.fromJson(json.decode(call.arguments["user"]));
            for (ChannelListener listener in channelListeners) {
              listener.onMemberLeave(channel, user);
            }
            break;
          }
          default:
            break;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> addMessageListener(MessageListener listener) async {
    try {
      messageListeners.add(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMessageListener(MessageListener listener) async {
    try {
      messageListeners.remove(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addChannelListener(ChannelListener listener) async {
    try {
      channelListeners.add(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeChannelListener(ChannelListener listener) async {
    try {
      channelListeners.remove(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addPresenceListener(PresenceListener listener) async {
    try {
      presenceListeners.add(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePresenceListener(PresenceListener listener) async {
    try {
      presenceListeners.remove(listener);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<BlaChannel>> getChannels(String lastId, int limit) async {
    try {
      var data = await _channel
          .invokeMethod(BlaConstants.GET_CHANNELS, <String, dynamic>{
        'lastId': lastId,
        'limit': limit,
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        List<dynamic> result = json.decode(valueMap["result"]);
        print("result " + result.toString());
        List<BlaChannel> channels =
            result.map((item) => BlaChannel.fromJson(item)).toList();
        return channels;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<BlaUser>> getUsersInChannel(String channelId) async {
    dynamic data = await _channel
        .invokeMethod(BlaConstants.GET_USERS_IN_CHANNEL, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaUser> users =
          result.map((item) => BlaUser.fromJson(item)).toList();
      return users;
    } else {
      throw valueMap["message"];
    }
  }

  Future<List<BlaUser>> getUsers(List<String> userIds) async {
    dynamic data =
        await _channel.invokeMethod(BlaConstants.GET_USERS, <String, dynamic>{
      'userIds': userIds,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaUser> users =
          result.map((item) => BlaUser.fromJson(item)).toList();
      return users;
    } else {
      throw valueMap["message"];
    }
  }

  Future<List<BlaMessage>> getMessages(
      String channelId, String lastId, int limit) async {
    dynamic data = await _channel.invokeMethod(
        BlaConstants.GET_MESSAGES, <String, dynamic>{
      'channelId': channelId,
      'lastId': lastId,
      'limit': limit
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      List<dynamic> result = json.decode(valueMap["result"]);
      List<BlaMessage> messages =
          result.map((item) => BlaMessage.fromJson(item)).toList();
      return messages;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaChannel> createChannel(
      String name, List<String> userIds, BlaChannelType type) async {
    dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_CHANNEL,
        <String, dynamic>{'name': name, 'userIds': userIds, 'type': type});
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var channel = BlaChannel.fromJson(json.decode(valueMap["result"]));
      return channel;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaChannel> updateChannel(BlaChannel channel) async {
    var jsonChannel = jsonEncode(channel.toJson());
    dynamic data = await _channel
        .invokeMethod(BlaConstants.UPDATE_CHANNEL, <String, dynamic>{
      'channel': jsonChannel
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var channel = BlaChannel.fromJson(valueMap["result"]);
      return channel;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaChannel> deleteChannel(BlaChannel channel) async {
    var jsonChannel = jsonEncode(channel.toJson());
    dynamic data = await _channel.invokeMethod(BlaConstants.DELETE_CHANNEL,
        <String, dynamic>{
          'channel': jsonChannel
        });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var channel = BlaChannel.fromJson(valueMap["result"]);
      return channel;
    } else {
      throw valueMap["message"];
    }
  }

  Future<bool> sendStartTyping(String channelId) async {
    dynamic data = await _channel
        .invokeMethod(BlaConstants.SEND_START_TYPING, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    print("start typing " + isSuccess.toString());
    if (isSuccess) {
      return json.decode(valueMap["result"]);
    } else {
      throw valueMap["message"];
    }
  }

  Future<bool> sendStopTyping(String channelId) async {
    dynamic data = await _channel
        .invokeMethod(BlaConstants.SEND_STOP_TYPING, <String, dynamic>{
      'channelId': channelId,
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    print("stop typing " + isSuccess.toString());
    if (isSuccess) {
      return json.decode(valueMap["result"]);
    } else {
      throw valueMap["message"];
    }
  }

  Future<bool> markSeenMessage(
      String messageId, String channelId, String receiveId) async {
    dynamic data = await _channel.invokeMethod(
        BlaConstants.MARK_SEEN_MESSAGE, <String, dynamic>{
      'messageId': messageId,
      'channelId': channelId,
      'receiveId': receiveId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      return json.decode(valueMap["result"]);
    } else {
      throw valueMap["message"];
    }
  }

  Future<bool> markReceiveMessage(
      String messageId, String channelId, String receiveId) async {
    dynamic data = await _channel.invokeMethod(
        BlaConstants.MARK_RECEIVE_MESSAGE, <String, dynamic>{
      'messageId': messageId,
      'channelId': channelId,
      'receiveId': receiveId
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      return json.decode(valueMap["result"]);
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaMessage> createMessage(String content, String channelId,
      BlaMessageType type, Map<String, dynamic> customData) async {
    dynamic data = await _channel
        .invokeMethod(BlaConstants.CREATE_MESSAGE, <String, dynamic>{
      'content': content,
      'channelId': channelId,
      'type': BlaUtils.getBlaMessageTypeRawValue(type)
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var message = BlaMessage.fromJson(json.decode(valueMap["result"]));
      return message;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaMessage> updateMessage(BlaMessage message) async {
    var jsonMessage = message.toJson();
    dynamic data = await _channel
        .invokeMethod(BlaConstants.UPDATE_MESSAGE, <String, dynamic>{
      'message': jsonMessage
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var mess = BlaMessage.fromJson(json.decode(valueMap["result"]));
      return mess;
    } else {
      throw valueMap["message"];
    }
  }

  Future<BlaMessage> deleteMessage(BlaMessage message) async {
    var jsonMessage = message.toJson();
    dynamic data = await _channel
        .invokeMethod(BlaConstants.DELETE_MESSAGE, <String, dynamic>{
      'message': jsonMessage
    });
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    if (isSuccess) {
      var mess = BlaMessage.fromJson(json.decode(valueMap["result"]));
      return mess;
    } else {
      throw valueMap["message"];
    }
  }

  Future<bool> inviteUserToChannel(
      List<String> userIds, String channelId) async {
    dynamic data = await _channel.invokeMethod(
        BlaConstants.INVITE_USER_TO_CHANNEL,
        <String, dynamic>{'userIds': userIds.join(","), 'channelId': channelId});
    print("data " + data);
//    Map valueMap = json.decode(data);
//    bool isSuccess = valueMap["isSuccess"];
//    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<bool> removeUserFromChannel(String userId, String channelId) async {
    dynamic data = await _channel.invokeMethod(
        BlaConstants.REMOVE_USER_FROM_CHANNEL,
        <String, dynamic>{'userId': userId, 'channelId': channelId});
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return true;
  }

  Future<List<BlaUserPresence>> getUserPresence() async {
    dynamic data = await _channel
        .invokeMethod(BlaConstants.GET_USER_PRESENCE, <String, dynamic>{});
    Map valueMap = json.decode(data);
    bool isSuccess = valueMap["isSuccess"];
    List<dynamic> result = json.decode(valueMap["result"]);
//      BlaChannel channel = BlaChannel.fromJson(result[0]);
    return [];
  }
}
