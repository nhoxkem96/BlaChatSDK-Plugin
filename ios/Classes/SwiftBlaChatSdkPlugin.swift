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
                ChatSDK.shareInstance.addMessageListener(delegate: self as BlaMessageDelegate)
                ChatSDK.shareInstance.addChannelListener(delegate: self as BlaChannelDelegate)
                ChatSDK.shareInstance.addPresenceListener(delegate: self as BlaPresenceListener)
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
            ChatSDK.shareInstance.addMessageListener(delegate: self as BlaMessageDelegate)
            result(true)
            break
        case REMOVE_MESSSAGE_LISTENER:
            ChatSDK.shareInstance.removeMessageListener(delegate: self as BlaMessageDelegate)
            result(true)
            break
        case ADD_CHANNEL_LISTENER:
            ChatSDK.shareInstance.addChannelListener(delegate: self as BlaChannelDelegate)
            result(true)
            break
        case REMOVE_CHANNEL_LISTENER:
            ChatSDK.shareInstance.removeChannelListener(delegate: self as BlaChannelDelegate)
            result(true)
            break
        case ADD_PRESENCE_LISTENER:
            ChatSDK.shareInstance.addPresenceListener(delegate: self as BlaPresenceListener)
            result(true)
            break
        case REMOVE_PRESENCE_LISTENER:
            ChatSDK.shareInstance.removePresenceListener(delegate: self as BlaPresenceListener)
            result(true)
            break
        case GET_CHANNELS:
            if let lastId = arguments["lastId"] as? String,
                let limit = arguments["limit"] as? Int
            {
                ChatSDK.shareInstance.getChannels(lastId: lastId, limit: limit) { (channels, error) in
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
                ChatSDK.shareInstance.getUserInChannel(channelId: channelId) { (users, error) in
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
                ChatSDK.shareInstance.getUsers(userIds: listUserId) { (users, error) in
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
                ChatSDK.shareInstance.getMessages(channelId: channelId, lastId: lastId, limit: limit) { (messages, error) in
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
                let userIds = arguments["userIds"] as? String,
                let type = arguments["type"] as? Int
            {
                var channelType = BlaChannelType.GROUP
                if type == 2 {
                    channelType = BlaChannelType.DIRECT
                }
                let listUserId = userIds.components(separatedBy: ",")
                ChatSDK.shareInstance.createChannel(name: name, userIds: listUserId, type: channelType) { (channel, error) in
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
                let channel = BlaChannel(dao: BlaChannelDAO(json: json))
                ChatSDK.shareInstance.updateChannel(channel: channel) { (channelResult, error) in
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
                let channel = BlaChannel(dao: BlaChannelDAO(json: json))
                ChatSDK.shareInstance.deleteChannel(channel: channel) { (channelResult, error) in
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
                ChatSDK.shareInstance.sendStartTyping(channelId: channelId) { (data, error) in
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
                ChatSDK.shareInstance.sendStopTyping(channelId: channelId) { (data, error) in
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
                let channelId = arguments["channelId"] as? String,
                let receiveId = arguments["receiveId"] as? String
            {
                ChatSDK.shareInstance.markSeenMessage(messageId: messageId, channelId: channelId, receiveId: receiveId) { (data, error) in
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
                let channelId = arguments["channelId"] as? String,
                let receiveId = arguments["receiveId"] as? String
            {
                ChatSDK.shareInstance.markReceiveMessage(messageId: messageId, channelId: channelId, receiveId: receiveId) { (data, error) in
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
                ChatSDK.shareInstance.createMessage(content: content, channelId: channelId, type: BlaMessageType.TEXT, customData: nil) { (data, error) in
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
                let message = BlaMessage(dao: BlaMessageDAO(json: json))
                ChatSDK.shareInstance.updateMessage(message: message) { (messageResult, error) in
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
                let message = BlaMessage(dao: BlaMessageDAO(json: json))
                ChatSDK.shareInstance.deleteMessage(message: message) { (messageResult, error) in
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
                ChatSDK.shareInstance.inviteUserToChannel(userIds: listUserId, channelId: channelId) { (data, error) in
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
                ChatSDK.shareInstance.removeUserFromChannel(userId: userId, channelId: channelId) { (data, error) in
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
            
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    // BlaChatSDK delegate
    public func onUpdate(userPresence: [BlaUserPresence]) {
        
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
    
    public func onDeleteChannel(channel: BlaChannel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(channel)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onDeleteChannel", arguments: [
            "channel": jsonResult1!,
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
    
    public func onDeleteMessage(message: BlaMessage) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData1 = try! jsonEncoder.encode(message)
        let jsonResult1 = String(data: jsonData1, encoding: String.Encoding.utf8)
        
        self._channel.invokeMethod("onDeleteMessage", arguments: [
            "message": jsonResult1!,
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
}
