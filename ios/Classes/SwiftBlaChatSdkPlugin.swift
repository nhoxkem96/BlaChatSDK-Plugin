import Flutter
import UIKit
import BlaChatSDK

public class SwiftBlaChatSdkPlugin: NSObject, FlutterPlugin, BlaPresenceListener, BlaChannelDelegate, BlaMessageDelegate {
    
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
        let instance = SwiftBlaChatSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
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
                let token = arguments["token"] as? Int
            {
                UserDefaults.standard.setValue(userId, forKey: "userId")
                UserDefaults.standard.setValue(token, forKey: "token")
                let dict: [String: Any] = ["isSuccess": false, "result": true];
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
            break
        case REMOVE_MESSSAGE_LISTENER:
            ChatSDK.shareInstance.removeMessageListener(delegate: self as BlaMessageDelegate)
            break
        case ADD_CHANNEL_LISTENER:
            ChatSDK.shareInstance.addChannelListener(delegate: self as BlaChannelDelegate)
            break
        case REMOVE_CHANNEL_LISTENER:
            ChatSDK.shareInstance.removeChannelListener(delegate: self as BlaChannelDelegate)
            break
        case ADD_PRESENCE_LISTENER:
            ChatSDK.shareInstance.addPresenceListener(delegate: self as BlaPresenceListener)
            break
        case REMOVE_PRESENCE_LISTENER:
            ChatSDK.shareInstance.removePresenceListener(delegate: self as BlaPresenceListener)
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
                        let jsonEncoder = JSONEncoder()
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
                        let jsonEncoder = JSONEncoder()
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
            if let userIds = arguments["userIds"] as? [String]
            {
                ChatSDK.shareInstance.getUsers(userIds: userIds) { (users, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let jsonEncoder = JSONEncoder()
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
                        let jsonEncoder = JSONEncoder()
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
                let userIds = arguments["userIds"] as? [String],
                let type = arguments["type"] as? Int
            {
                var channelType = BlaChannelType.GROUP
                if type == 2 {
                    channelType = BlaChannelType.DIRECT
                }
                ChatSDK.shareInstance.createChannel(name: name, userIds: userIds, type: channelType) { (channel, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let jsonEncoder = JSONEncoder()
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
            if let channelId = arguments["channelId"] as? String
            {
                
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case DELETE_CHANNEL:
            if let channelId = arguments["channelId"] as? String
            {
                
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
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
                let type = arguments["type"] as? Int,
                let customData = arguments["customData"] as? String
            {
                ChatSDK.shareInstance.createMessage(content: content, channelId: channelId, type: BlaMessageType.TEXT, customData: nil) { (data, error) in
                    if let err = error {
                        let dict: [String: Any] = ["isSuccess": false, "message": err.localizedDescription];
                        let json = try! JSONSerialization.data(withJSONObject: dict)
                        let jsonString = String(data: json, encoding: .utf8)!
                        result(jsonString)
                    } else {
                        let jsonEncoder = JSONEncoder()
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
            if let channelId = arguments["channelId"] as? String
            {
                
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case DELETE_MESSAGE:
            if let channelId = arguments["channelId"] as? String
            {
                
            } else {
                let dict: [String: Any] = ["isSuccess": false, "message": "Error arguments"];
                let json = try! JSONSerialization.data(withJSONObject: dict)
                let jsonString = String(data: json, encoding: .utf8)!
                result(jsonString)
            }
            break
        case INVITE_USER_TO_CHANNEL:
            if let userIds = arguments["userIds"] as? [String],
                let channelId = arguments["channelId"] as? String
            {
                
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
        
    }
    
    public func onUpdateChannel(channel: BlaChannel) {
        
    }
    
    public func onDeleteChannel(channel: BlaChannel) {
        
    }
    
    public func onTyping(channel: BlaChannel, user: BlaUser, type: BlaEventType) {
        
    }
    
    public func onMemberJoin(channel: BlaChannel, user: BlaUser) {
        
    }
    
    public func onMemberLeave(channel: BlaChannel, user: BlaUser) {
        
    }
    
    public func onNewMessage(message: BlaMessage) {
        
    }
    
    public func onUpdateMessage(message: BlaMessage) {
        
    }
    
    public func onDeleteMessage(message: BlaMessage) {
    }
    
    public func onUserSeen(message: BlaMessage, user: BlaUser, seenAt: Date) {
        
    }
    
    public func onUserReceive(message: BlaMessage, user: BlaUser, sentAt seentAt: Date) {
    }
}
