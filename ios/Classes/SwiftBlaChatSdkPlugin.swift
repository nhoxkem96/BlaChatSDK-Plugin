import Flutter
import UIKit
import BlaChatSDK
import SwiftyJSON

public class SwiftBlaChatSdkPlugin: NSObject, FlutterPlugin, BlaPresenceListener, BlaChannelDelegate, BlaMessageDelegate {
    
    var _channel: FlutterMethodChannel;
    
    final let INIT_BLACHATSDK = "initBlaChatSDK";
    final let ADD_MESSSAGE_LISTENER = "addMessageListener";
    final let REMOVE_MESSSAGE_LISTENER = "removeMessageListener";
    final let ADD_CHANNEL_LISTENER = "addChannelListener";
    final let REMOVE_CHANNEL_LISTENER = "removeChannelListener";
    final let ADD_PRESENCE_LISTENER = "addPresenceListener";
    final let REMOVE_PRESENCE_LISTENER = "removePresenceListener";
    final let GET_CHANNELS = "getChannels";
    final let GET_USERS_IN_CHANNEL = "getUsersInChannel";
    final let GET_USERS = "getUsers";
    final let GET_MESSAGES = "getMessages";
    final let CREATE_CHANNEL = "createChannel";
    final let UPDATE_CHANNEL = "updateChannel";
    final let DELETE_CHANNEL = "deleteChannel";
    final let SEND_START_TYPING = "sendStartTyping";
    final let SEND_STOP_TYPING = "sendStopTyping";
    final let MARK_SEEN_MESSAGE = "markSeenMessage";
    final let MARK_RECEIVE_MESSAGE = "markReceiveMessage";
    final let CREATE_MESSAGE = "createMessage";
    final let UPDATE_MESSAGE = "updateMessage";
    final let DELETE_MESSAGE = "deleteMessage";
    final let INVITE_USER_TO_CHANNEL = "inviteUserToChannel";
    final let REMOVE_USER_FROM_CHANNEL = "removeUserFromChannel";
    final let GET_USER_PRESENCE = "getUserPresence";
    final let UPDATE_FCM_TOKEN = "updateFCMToken";
    final let LOGOUT_BLACHATSDK = "logoutBlaChatSDK";
    final let SEARCH_CHANNELS = "searchChannels";
    final let LEAVE_CHANNEL = "leaveChannel";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "bla_chat_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftBlaChatSdkPlugin(channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(_ channel: FlutterMethodChannel) {
        self._channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var arguments: [String: AnyObject]
        if(call.arguments != nil){
            arguments = call.arguments as! [String: AnyObject]
        }else{
            arguments = [String: AnyObject]()
        }
        
        switch call.method {
        case INIT_BLACHATSDK:
            if let userId = arguments["userId"] as? String,
                let token = arguments["token"] as? String
            {
                UserDefaults.standard.setValue(userId, forKey: "userId")
                UserDefaults.standard.setValue(token, forKey: "token")
                BlaChatSDK.shareInstance.addMessageListener(delegate: self as BlaMessageDelegate)
                BlaChatSDK.shareInstance.addChannelListener(delegate: self as BlaChannelDelegate)
                BlaChatSDK.shareInstance.addPresenceListener(delegate: self as BlaPresenceListener)
                BlaChatSDK.shareInstance.initBlaChatSDK(userId: userId, token: token) { (data, error) in
                }
                let dict: [String: Any] = ["isSuccess": true, "result": true];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case ADD_MESSSAGE_LISTENER:
            BlaChatSDK.shareInstance.addMessageListener(delegate: self as BlaMessageDelegate)
            result(true)
            break
        case REMOVE_MESSSAGE_LISTENER:
            BlaChatSDK.shareInstance.removeMessageListener(delegate: self as BlaMessageDelegate)
            result(true)
            break
        case ADD_CHANNEL_LISTENER:
            BlaChatSDK.shareInstance.addChannelListener(delegate: self as BlaChannelDelegate)
            result(true)
            break
        case REMOVE_CHANNEL_LISTENER:
            BlaChatSDK.shareInstance.removeChannelListener(delegate: self as BlaChannelDelegate)
            result(true)
            break
        case ADD_PRESENCE_LISTENER:
            BlaChatSDK.shareInstance.addPresenceListener(delegate: self as BlaPresenceListener)
            result(true)
            break
        case REMOVE_PRESENCE_LISTENER:
            BlaChatSDK.shareInstance.removePresenceListener(delegate: self as BlaPresenceListener)
            result(true)
            break
        case GET_CHANNELS:
            if let lastId = arguments["lastId"] as? String,
                let limit = arguments["limit"] as? Int
            {
                BlaChatSDK.shareInstance.getChannels(lastId: lastId, limit: limit) { (channels, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(channels)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case SEARCH_CHANNELS:
            if let query = arguments["query"] as? String
            {
                BlaChatSDK.shareInstance.searchChannels(query: query) { (channels, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(channels)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case GET_USERS_IN_CHANNEL:
            if let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.getUserInChannel(channelId: channelId) { (users, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(users)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case GET_USERS:
            if let userIds = arguments["userIds"] as? String
            {
                let listUserId = userIds.components(separatedBy: ",")
                BlaChatSDK.shareInstance.getUsers(userIds: listUserId) { (users, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(users)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case GET_MESSAGES:
            if let channelId = arguments["channelId"] as? String,
                let lastId = arguments["lastId"] as? String,
                let limit = arguments["limit"] as? Int
            {
                BlaChatSDK.shareInstance.getMessages(channelId: channelId, lastId: lastId, limit: limit) { (messages, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(messages)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case CREATE_CHANNEL:
            if let name = arguments["name"] as? String,
                let avatar = arguments["avatar"] as? String,
                let userIds = arguments["userIds"] as? String,
                let type = arguments["type"] as? Int
            {
                let channelType = BlaChannelType.init(rawValue: type)
                let listUserId = userIds.components(separatedBy: ",")
                var customData: [String: Any]?
                if let customDataString = arguments["customData"] as? String, let data = customDataString.data(using: .utf8) {
                    do {
                        customData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                    }
                }
                BlaChatSDK.shareInstance.createChannel(name: name, avatar: avatar, userIds: listUserId, type: channelType, customData: customData ?? [String: Any]()) { (channel, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(channel)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case UPDATE_CHANNEL:
            if let jsonChannel = arguments["channel"] as? String
            {
                let json = JSON.init(parseJSON: jsonChannel)
                let channel = BlaChannel(json: json)
                BlaChatSDK.shareInstance.updateChannel(channel: channel) { (channelResult, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let data = jsonChannel.data(using: .utf8)!
                        let jsonData = try! jsonEncoder.encode(channelResult)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case DELETE_CHANNEL:
            if let jsonChannel = arguments["channel"] as? String
            {
                let json = JSON.init(parseJSON: jsonChannel)
                let channel = BlaChannel(json: json)
                BlaChatSDK.shareInstance.deleteChannel(channel: channel) { (channelResult, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let data = jsonChannel.data(using: .utf8)!
                        let jsonData = try! jsonEncoder.encode(channelResult)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
        case LEAVE_CHANNEL:
            if let jsonChannel = arguments["channel"] as? String
            {
                let json = JSON.init(parseJSON: jsonChannel)
                let channel = BlaChannel(json: json)
                BlaChatSDK.shareInstance.leaveChannel(channel: channel) { (channelResult, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let data = jsonChannel.data(using: .utf8)!
                        let jsonData = try! jsonEncoder.encode(channelResult)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
        case SEND_START_TYPING:
            if let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.sendStartTyping(channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case SEND_STOP_TYPING:
            if let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.sendStopTyping(channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case MARK_SEEN_MESSAGE:
            if let messageId = arguments["messageId"] as? String,
                let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.markSeenMessage(messageId: messageId, channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case MARK_RECEIVE_MESSAGE:
            if let messageId = arguments["messageId"] as? String,
                let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.markReceiveMessage(messageId: messageId, channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case CREATE_MESSAGE:
            if let content = arguments["content"] as? String,
                let channelId = arguments["channelId"] as? String,
                let type = arguments["type"] as? Int
            {
                var messageType = BlaMessageType.init(rawValue: type)
                var customData: [String: Any]?
                if let customDataString = arguments["customData"] as? String, let data = customDataString.data(using: .utf8) {
                    do {
                        customData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    } catch {
                    }
                }
                BlaChatSDK.shareInstance.createMessage(content: content, channelId: channelId, type: messageType, customData: customData) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(data!)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case UPDATE_MESSAGE:
            if let jsonMessage = arguments["message"] as? String
            {
                let json = JSON.init(parseJSON: jsonMessage)
                let message = BlaMessage(json: json)
                BlaChatSDK.shareInstance.updateMessage(message: message) { (messageResult, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(messageResult)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case DELETE_MESSAGE:
            if let jsonMessage = arguments["message"] as? String
            {
                let json = JSON.init(parseJSON: jsonMessage)
                let message = BlaMessage(json: json)
                BlaChatSDK.shareInstance.deleteMessage(message: message) { (messageResult, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                        let jsonData = try! jsonEncoder.encode(messageResult)
                        let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                        let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case INVITE_USER_TO_CHANNEL:
            if let userIds = arguments["userIds"] as? String,
                let channelId = arguments["channelId"] as? String
            {
                let listUserId = userIds.components(separatedBy: ",")
                BlaChatSDK.shareInstance.inviteUserToChannel(userIds: listUserId, channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case REMOVE_USER_FROM_CHANNEL:
            if let userId = arguments["userId"] as? String,
                let channelId = arguments["channelId"] as? String
            {
                BlaChatSDK.shareInstance.removeUserFromChannel(userId: userId, channelId: channelId) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case GET_USER_PRESENCE:
            BlaChatSDK.shareInstance.getUserPresence { (users, error) in
                if let err = error {
                    let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                    let json = try! JSONSerialization.data(withJSONObject: dict)
                    let jsonString = String(data: json, encoding: .utf8)!
                    result(jsonString)
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.dateEncodingStrategy = .formatted(formatter)
                    let jsonData = try! jsonEncoder.encode(users)
                    let jsonResult = String(data: jsonData, encoding: String.Encoding.utf8)
                    let dict: [String: Any] = ["isSuccess": true, "result": jsonResult!];
                    let json = try! JSONSerialization.data(withJSONObject: dict)
                    let jsonString = String(data: json, encoding: .utf8)!
                    result(jsonString)
                }
            }
            break
            
        case UPDATE_FCM_TOKEN:
            if let fcmToken = arguments["fcmToken"] as? String
            {
                BlaChatSDK.shareInstance.updateFCMToken(fcmToken: fcmToken) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let dict: [String: Any] = ["isSuccess": true, "result": data!];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    }
                }
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
            
        case LOGOUT_BLACHATSDK:
            BlaChatSDK.shareInstance.logoutBlaChatSDK()
            result(true)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    // BlaChatSDK delegate
    public func onUpdate(userPresence: [BlaUser]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(userPresence)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUpdate", arguments: [
            "userPresence": jsonResult1!,
        ]);
    }
    
    public func onNewChannel(channel: BlaChannel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onNewChannel", arguments: [
            "channel": jsonResult1!,
        ]);
    }
    
    public func onUpdateChannel(channel: BlaChannel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUpdateChannel", arguments: [
            "channel": jsonResult1!,
        ]);
    }
    
    public func onDeleteChannel(channelId: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        self._channel.invokeMethod("onDeleteChannel", arguments: [
            "channelId": channelId,
        ]);
    }
    
    public func onTyping(channel: BlaChannel, user: BlaUser, type: BlaEventType) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onTyping", arguments: [
            "channel": jsonResult1!,
            "user": jsonResult2!,
            "type": type == BlaEventType.START ? 1 : 0
        ]);
    }
    
    public func onMemberJoin(channel: BlaChannel, user: BlaUser) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onMemberJoin", arguments: [
            "channel": jsonResult1!,
            "user": jsonResult2!,
        ]);
    }
    
    public func onMemberLeave(channel: BlaChannel, user: BlaUser) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onMemberLeave", arguments: [
            "channel": jsonResult1!,
            "user": jsonResult2!,
        ]);
    }
    
    public func onNewMessage(message: BlaMessage) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(message)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onNewMessage", arguments: [
            "message": jsonResult1!,
        ]);
    }
    
    public func onUpdateMessage(message: BlaMessage) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(message)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUpdateMessage", arguments: [
            "message": jsonResult1!,
        ]);
    }
    
    public func onDeleteMessage(messageId: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        self._channel.invokeMethod("onDeleteMessage", arguments: [
            "messageId": messageId,
        ]);
    }
    
    public func onUserSeen(message: BlaMessage, user: BlaUser, seenAt: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(message)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUserSeen", arguments: [
            "message": jsonResult1!,
            "user": jsonResult2!,
            "seenAt": seenAt.timeIntervalSince1970
        ]);
    }
    
    public func onUserReceive(message: BlaMessage, user: BlaUser, receivedAt: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(message)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUserReceive", arguments: [
            "message": jsonResult1!,
            "user": jsonResult2!,
            "receivedAt": receivedAt.timeIntervalSince1970
        ]);
    }
    
    public func onUserSeenMessage(channel: BlaChannel, user: BlaUser, message: BlaMessage) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData3 = try! jsonEncoder.encode(message)
        let jsonResult3 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUserSeenMessage", arguments: [
            "channel": jsonResult1!,
            "user": jsonResult2!,
            "message": jsonResult3!
        ]);
    }
    
    public func onUserReceiveMessage(channel: BlaChannel, user: BlaUser, message: BlaMessage) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData2 = try! jsonEncoder.encode(user)
        let jsonResult2 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        let jsonData3 = try! jsonEncoder.encode(message)
        let jsonResult3 = String(data: jsonData2, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onUserSeenMessage", arguments: [
            "channel": jsonResult1!,
            "user": jsonResult2!,
            "message": jsonResult3!
        ]);
    }
}
