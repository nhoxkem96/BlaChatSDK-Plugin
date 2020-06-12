package blachatsdk.blameo.com.bla_chat_sdk

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import android.preference.PreferenceManager
import android.util.Log
import com.blameo.chatsdk.blachat.*
import com.blameo.chatsdk.models.bla.*
import com.blameo.chatsdk.models.entities.User
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonObject
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception
import java.util.*
import kotlin.collections.HashMap


class BlaChatSdkPlugin : MethodCallHandler {

  val INIT_BLACHATSDK = "initBlaChatSDK"
  val ADD_MESSSAGE_LISTENER = "addMessageListener"
  val REMOVE_MESSSAGE_LISTENER = "removeMessageListener"
  val ADD_CHANNEL_LISTENER = "addChannelListener"
  val REMOVE_CHANNEL_LISTENER = "removeChannelListener"
  val ADD_PRESENCE_LISTENER = "addPresenceListener"
  val REMOVE_PRESENCE_LISTENER = "removePresenceListener"
  val GET_CHANNELS = "getChannels"
  val GET_USERS_IN_CHANNEL = "getUsersInChannel"
  val GET_USERS = "getUsers"
  val GET_MESSAGES = "getMessages"
  val CREATE_CHANNEL = "createChannel"
  val UPDATE_CHANNEL = "updateChannel"
  val DELETE_CHANNEL = "deleteChannel"
  val SEND_START_TYPING = "sendStartTyping"
  val SEND_STOP_TYPING = "sendStopTyping"
  val MARK_SEEN_MESSAGE = "markSeenMessage"
  val MARK_RECEIVE_MESSAGE = "markReceiveMessage"
  val CREATE_MESSAGE = "createMessage"
  val UPDATE_MESSAGE = "updateMessage"
  val DELETE_MESSAGE = "deleteMessage"
  val INVITE_USER_TO_CHANNEL = "inviteUserToChannel"
  val REMOVE_USER_FROM_CHANNEL = "removeUserFromChannel"
  val GET_USER_PRESENCE = "getUserPresence"


  var thread: Thread? = null

  val SHARED_PREFERENCES_NAME = "shared_preference"
  private var context: Activity? = null
  private var channel: MethodChannel? = null
  var myGson =  GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create()
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "bla_chat_sdk")
      val bien = BlaChatSdkPlugin();
      bien.setupChannel(registrar.messenger(), registrar.activity(), channel)
      channel.setMethodCallHandler(bien)
    }
  }

  private fun setupChannel(messenger: BinaryMessenger, activity: Activity, channel: MethodChannel) {
    this.channel = channel
    this.context = activity
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val arguments = call.arguments as Map<String, Any>;
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == INIT_BLACHATSDK) {
      val sharedPreferences = context?.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
      val userId = arguments["userId"] as String;
      val token = arguments["token"] as String;
      BlaChatSDK.getInstance().init(this.context, userId, token);

      if (userId != null && token != null) {
        // save
        sharedPreferences?.edit()?.putString("user_id", userId)
        sharedPreferences?.edit()?.putString("token", token)
        BlaChatSDK.getInstance().addChannelListener(object: ChannelEventListener{
          override fun onMemberLeave(p0: BlaChannel?, p1: BlaUser?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onMemberLeave", dict)
              }
            })
          }

          override fun onUserReceiveMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                dict["message"] = myGson.toJson(p2)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserReceiveMessage", dict)
              }
            })
          }

          override fun onDeleteChannel(p0: BlaChannel?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onDeleteChannel", dict)
              }
            })
          }

          override fun onTyping(p0: BlaChannel?, p1: BlaUser?, p2: EventType?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                dict["type"] = if(p2 == EventType.START) 1 else 0
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onTyping", dict)
              }
            })
          }

          override fun onNewChannel(p0: BlaChannel?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onNewChannel", dict)
              }
            })
          }

          override fun onUserSeenMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                dict["message"] = myGson.toJson(p2)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserSeenMessage", dict)
              }
            })
          }

          override fun onUpdateChannel(p0: BlaChannel?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUpdateChannel", dict)
              }
            })
          }

          override fun onMemberJoin(p0: BlaChannel?, p1: BlaUser?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["channel"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onMemberJoin", dict)
              }
            })
          }
        })

        BlaChatSDK.getInstance().addMessageListener(object: MessagesListener{
          override fun onNewMessage(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["message"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onNewMessage", dict)
              }
            })
          }

          override fun onUpdateMessage(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["message"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUpdateMessage", dict)
              }
            })
          }

          override fun onDeleteMessage(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["message"] = myGson.toJson(p0)
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onDeleteMessage", dict)
              }
            })
          }

          override fun onUserSeen(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["message"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                dict["seenAt"] = p2!!.time
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserSeen", dict)
              }
            })
          }

          override fun onUserReceive(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["message"] = myGson.toJson(p0)
                dict["user"] = myGson.toJson(p1)
                dict["receivedAt"] = p2!!.time
                this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserReceive", dict)
              }
            })
          }
        })

        BlaChatSDK.getInstance().addPresenceListener(object: BlaPresenceListener{
          override fun onUpdate(p0: BlaUserPresence?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
//                var dict = HashMap<String, Any>()
//                dict["channel"] = myGson.toJson(p0)
//                dict["user"] = myGson.toJson(p1)
//                dict["type"] = if(p2 == EventType.START) 1 else 0
//                this@BlaChatSdkPlugin.channel!!.invokeMethod("onTyping", dict)
              }
            })
          }
        })
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = true
        dict["result"] = true
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      } else {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["result"] = false
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == ADD_MESSSAGE_LISTENER) {

    } else if (call.method == REMOVE_MESSSAGE_LISTENER) {

    } else if (call.method == ADD_CHANNEL_LISTENER) {

    } else if (call.method == REMOVE_CHANNEL_LISTENER) {

    } else if (call.method == ADD_PRESENCE_LISTENER) {

    } else if (call.method == REMOVE_PRESENCE_LISTENER) {

    } else if (call.method == GET_CHANNELS) {
      try {
        val limit = arguments["limit"] as Int
        val lastId = arguments["lastId"] as String
        BlaChatSDK.getInstance().getChannels(lastId, limit, object : Callback<List<BlaChannel>> {
          override fun onSuccess(p0: List<BlaChannel>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["isSuccess"] = true
                dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
                val jsonString = Gson().toJson(dict);
                result.success(jsonString);
              }
            })

          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                var dict = HashMap<String, Any>()
                dict["isSuccess"] = false
                dict["message"] = p0.toString()
                val jsonString = Gson().toJson(dict);
                result.success(jsonString);
              }

            })

          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == GET_USERS_IN_CHANNEL) {
      try {
        val channelId = arguments["channelId"] as String
        BlaChatSDK.getInstance().getUsersInChannel(channelId, object: Callback<List<BlaUser>> {
          override fun onSuccess(p0: List<BlaUser>?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == GET_USERS) {
      try {
        val userIds = arguments["userIds"] as String
        var listUserId = userIds.split(",").toMutableList()  as ArrayList<String>
        BlaChatSDK.getInstance().getUsers(listUserId, object: Callback<List<BlaUser>> {
          override fun onSuccess(p0: List<BlaUser>?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == GET_MESSAGES) {
      try {
        val channelId = arguments["channelId"] as String
        val lastId = arguments["lastId"] as String
        val limit = arguments["limit"] as Int
        BlaChatSDK.getInstance().getMessages(channelId, lastId, limit, object: Callback<List<BlaMessage>> {
          override fun onSuccess(p0: List<BlaMessage>?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == CREATE_CHANNEL) {
      try {
        val name = arguments["name"] as String
        val userIds = arguments["userIds"] as String
        val type = arguments["type"] as Int
        var listUserId = userIds.split(",").toMutableList()  as ArrayList<String>
        var channelType = BlaChannelType.GROUP
        if (type == 2) {
          channelType = BlaChannelType.DIRECT
        }
        BlaChatSDK.getInstance().createChannel(name, listUserId, channelType, object: Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == UPDATE_CHANNEL) {
      try {
        val jsonChannel = arguments["channel"] as String
        var channel = Gson().fromJson(jsonChannel, BlaChannel::class.java)

        BlaChatSDK.getInstance().updateChannel(channel, object: Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == DELETE_CHANNEL) {
      try {
        val jsonChannel = arguments["channel"] as String
        var channel = Gson().fromJson(jsonChannel, BlaChannel::class.java)

        BlaChatSDK.getInstance().deleteChannel(channel, object: Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == SEND_START_TYPING) {
      try {
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().sendStartTyping(channelId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == SEND_STOP_TYPING) {
      try {
        val channelId = arguments["channelId"] as String
        BlaChatSDK.getInstance().sendStopTyping(channelId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == MARK_SEEN_MESSAGE) {
      try {
        val messageId = arguments["messageId"] as String
        val channelId = arguments["channelId"] as String
        val receiveId = arguments["receiveId"] as String

        BlaChatSDK.getInstance().markSeenMessage(messageId, channelId, receiveId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == MARK_RECEIVE_MESSAGE) {
      try {
        val messageId = arguments["messageId"] as String
        val channelId = arguments["channelId"] as String
        val receiveId = arguments["receiveId"] as String

        BlaChatSDK.getInstance().markReceiveMessage(messageId, channelId, receiveId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == CREATE_MESSAGE) {
      try {
        val content = arguments["content"] as String
        val channelId = arguments["channelId"] as String
        val type = arguments["type"] as Int

        var blaMessageType = BlaMessageType.TEXT
        if (type == 1) {
          blaMessageType = BlaMessageType.IMAGE;
        }

        BlaChatSDK.getInstance().createMessage(content, channelId, blaMessageType, null, object: Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }

        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == UPDATE_MESSAGE) {
      try {
        val jsonMessage = arguments["message"] as String
        var message = Gson().fromJson(jsonMessage, BlaMessage::class.java)

        BlaChatSDK.getInstance().updateMessage(message, object : Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == DELETE_MESSAGE) {
      try {
        val jsonMessage = arguments["message"] as String
        var message = Gson().fromJson(jsonMessage, BlaMessage::class.java)

        BlaChatSDK.getInstance().deleteMessage(message, object : Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create().toJson(p0)
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == INVITE_USER_TO_CHANNEL) {
      try {
        val userIds = arguments["userIds"] as String
        val channelId = arguments["channelId"] as String
        var listUserId = userIds.split(",").toMutableList()  as ArrayList<String>

        BlaChatSDK.getInstance().inviteUserToChannel(listUserId, channelId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == REMOVE_USER_FROM_CHANNEL) {
      try {
        val userId = arguments["userId"] as String
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().removeUserFromChannel(userId, channelId, object: Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = true
            dict["result"] = p0?:false
            val jsonString = Gson().toJson(dict)
            result.success(jsonString)
          }

          override fun onFail(p0: Exception?) {
            var dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = p0.toString()
            val jsonString = Gson().toJson(dict);
            result.success(jsonString);
          }
        })
      } catch (e: Exception) {
        var dict = HashMap<String, Any>()
        dict["isSuccess"] = false
        dict["message"] = e.toString()
        val jsonString = Gson().toJson(dict);
        result.success(jsonString)
      }
    } else if (call.method == GET_USER_PRESENCE) {

    } else {
      result.notImplemented()
    }
  }
}
