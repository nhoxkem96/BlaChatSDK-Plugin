import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'BlaChannel.dart';
import 'BlaMessage.dart';
import 'BlaChannelType.dart';
import 'BlaMessageType.dart';
import 'BlaUser.dart';
import 'EventType.dart';
import 'BlaConstants.dart';
import 'BlaUtils.dart';

class MessageListener {

  MessageListener({this.onNewMessage, this.onUpdateMessage, this.onDeleteMessage, this.onUserSeen, this.onUserReceive});

  Function(BlaMessage message) onNewMessage;
  Function(BlaMessage message) onUpdateMessage;
  Function(String messageId) onDeleteMessage;
  Function(BlaMessage message, BlaUser user, DateTime seenAt) onUserSeen;
  Function(BlaMessage message, BlaUser user, DateTime receivedAt) onUserReceive;
}

class PresenceListener {

  PresenceListener({this.onUpdate});

  Function(List<BlaUser> users) onUpdate;
}

class ChannelListener {

  ChannelListener({this.onNewChannel, this.onUpdateChannel, this.onDeleteChannel,
    this.onUserSeenMessage, this.onUserReceiveMessage, this.onTyping, this.onMemberJoin, this.onMemberLeave});

  Function(BlaChannel channel) onNewChannel;
  Function(BlaChannel channel) onUpdateChannel;
  Function(String channelId) onDeleteChannel;
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
            var messageId = call.arguments["messageId"];
            for (MessageListener listener in messageListeners) {
              listener.onDeleteMessage(messageId);
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
            List<dynamic> result = json.decode(call.arguments["userPresence"]);
            List<BlaUser> users =
            result.map((item) => BlaUser.fromJson(item)).toList();
            for (PresenceListener listener in presenceListeners) {
              listener.onUpdate(users);
            }
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
            var channelId = call.arguments["channelId"];
            for (ChannelListener listener in channelListeners) {
              listener.onDeleteChannel(channelId);
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

  Future<List<BlaChannel>> searchChannels(String query) async {
    try {
      var data = await _channel
          .invokeMethod(BlaConstants.SEARCH_CHANNELS, <String, dynamic>{
        'query': query
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        List<dynamic> result = json.decode(valueMap["result"]);
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
    try {
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
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<BlaUser>> getUsers(List<String> userIds) async {
    try {
      dynamic data =
      await _channel.invokeMethod(BlaConstants.GET_USERS, <String, dynamic>{
        'userIds': userIds.join(","),
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
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<BlaMessage>> getMessages(
      String channelId, String lastId, int limit) async {
    try {
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
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaChannel> createChannel(
      String name, String avatar, List<String> userIds, BlaChannelType type, Map<String, dynamic> customData) async {
    try {
      var customDataString = json.encode(customData);
      dynamic data = await _channel.invokeMethod(BlaConstants.CREATE_CHANNEL,
          <String, dynamic>{'name': name, 'avatar': avatar, 'userIds': userIds.join(","), 'type': BlaUtils.getChannelTypeRawValue(type), 'customData': customDataString});
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        var channel = BlaChannel.fromJson(json.decode(valueMap["result"]));
        return channel;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaChannel> updateChannel(BlaChannel channel) async {
    try {
      var jsonChannel = jsonEncode(channel.toJson());
      dynamic data = await _channel
          .invokeMethod(BlaConstants.UPDATE_CHANNEL, <String, dynamic>{
        'channel': jsonChannel
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        var channel = BlaChannel.fromJson(json.decode(valueMap["result"]));
        return channel;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaChannel> deleteChannel(BlaChannel channel) async {
    try {
      var dataChannel = channel.toJson();
      dataChannel.remove("lastMessage");
      var jsonChannel = jsonEncode(dataChannel);
      dynamic data = await _channel.invokeMethod(BlaConstants.DELETE_CHANNEL,
          <String, dynamic>{
            'channel': jsonChannel
          });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        var channel = BlaChannel.fromJson(json.decode(valueMap["result"]));
        return channel;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaChannel> leaveChannel(BlaChannel channel) async {
    try {
      var jsonChannel = jsonEncode(channel.toJson());
      dynamic data = await _channel.invokeMethod(BlaConstants.LEAVE_CHANNEL,
          <String, dynamic>{
            'channel': jsonChannel
          });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        var channel = BlaChannel.fromJson(json.decode(valueMap["result"]));
        return channel;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> sendStartTyping(String channelId) async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.SEND_START_TYPING, <String, dynamic>{
        'channelId': channelId,
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> sendStopTyping(String channelId) async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.SEND_STOP_TYPING, <String, dynamic>{
        'channelId': channelId,
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> markSeenMessage(
      String messageId, String channelId) async {
    try {
      dynamic data = await _channel.invokeMethod(
          BlaConstants.MARK_SEEN_MESSAGE, <String, dynamic>{
        'messageId': messageId,
        'channelId': channelId
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> markReceiveMessage(
      String messageId, String channelId) async {
    try {
      dynamic data = await _channel.invokeMethod(
          BlaConstants.MARK_RECEIVE_MESSAGE, <String, dynamic>{
        'messageId': messageId,
        'channelId': channelId
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch(e) {
      throw e.toString();
    }
  }

  Future<BlaMessage> createMessage(String content, String channelId,
      BlaMessageType type, Map<String, dynamic> customData) async {
    try {
      var customDataString = json.encode(customData);
      dynamic data = await _channel
          .invokeMethod(BlaConstants.CREATE_MESSAGE, <String, dynamic>{
        'content': content,
        'channelId': channelId,
        'type': BlaUtils.getBlaMessageTypeRawValue(type),
        'customData': customDataString
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        var message = BlaMessage.fromJson(json.decode(valueMap["result"]));
        return message;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaMessage> updateMessage(BlaMessage message) async {
    try {
      var jsonMessage = jsonEncode(message.toJson());
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
    } catch (e) {
      throw e.toString();
    }
  }

  Future<BlaMessage> deleteMessage(BlaMessage message) async {
    try {
      message.seenBy = [];
      message.receivedBy = [];
      var mapData = message.toJson();
      mapData.remove("receivedBy");
      mapData.remove("seenBy");
      var jsonMessage = jsonEncode(mapData);

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
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> inviteUserToChannel(
      List<String> userIds, String channelId) async {
    try {
      dynamic data = await _channel.invokeMethod(
          BlaConstants.INVITE_USER_TO_CHANNEL,
          <String, dynamic>{'userIds': userIds.join(","), 'channelId': channelId});
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> removeUserFromChannel(String userId, String channelId) async {
    try {
      dynamic data = await _channel.invokeMethod(
          BlaConstants.REMOVE_USER_FROM_CHANNEL,
          <String, dynamic>{'userId': userId, 'channelId': channelId});
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<BlaUser>> getUserPresence() async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.GET_USER_PRESENCE, <String, dynamic>{});
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      if (isSuccess) {
        return [];
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> updateFCMToken(String fcmToken) async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.UPDATE_FCM_TOKEN, <String, dynamic>{
        'fcmToken': fcmToken
      });
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return result;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> logoutBlaChatSDK() async {
    try {
      dynamic data = await _channel
          .invokeMethod(BlaConstants.LOGOUT_BLACHATSDK, <String, dynamic>{});
      Map valueMap = json.decode(data);
      bool isSuccess = valueMap["isSuccess"];
      bool result = valueMap["result"];
      if (isSuccess) {
        return true;
      } else {
        throw valueMap["message"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
