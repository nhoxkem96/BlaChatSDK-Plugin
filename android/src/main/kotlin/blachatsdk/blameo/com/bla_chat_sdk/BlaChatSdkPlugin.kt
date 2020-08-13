package blachatsdk.blameo.com.bla_chat_sdk

import android.app.Activity
import android.content.Context
import android.util.Log
import com.blameo.chatsdk.blachat.BlaChatSDK
import com.blameo.chatsdk.blachat.Callback
import com.blameo.chatsdk.blachat.ChannelEventListener
import com.blameo.chatsdk.blachat.MessagesListener
import com.blameo.chatsdk.models.bla.*
import com.blameo.chatsdk.models.entities.Message
import com.blameo.chatsdk.utils.GsonUtil
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.HashMap

class MyDateTypeAdapter(): TypeAdapter<Date>() {
  private var simpleDateFormat: SimpleDateFormat? = null

  init {
    simpleDateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
  }

  override fun write(out: JsonWriter?, value: Date?) {
    if (value == null) out!!.nullValue() else out!!.value(simpleDateFormat!!.format(value))
  }

  override fun read(`in`: JsonReader?): Date {
    return if (`in` != null) Date(`in`.nextLong()) else Date()
  }

}


class BlaChatSdkPlugin : MethodCallHandler {

  private val INIT_BLACHATSDK = "initBlaChatSDK"
  private val ADD_MESSSAGE_LISTENER = "addMessageListener"
  private val REMOVE_MESSSAGE_LISTENER = "removeMessageListener"
  private val ADD_CHANNEL_LISTENER = "addChannelListener"
  private val REMOVE_CHANNEL_LISTENER = "removeChannelListener"
  private val ADD_PRESENCE_LISTENER = "addPresenceListener"
  private val REMOVE_PRESENCE_LISTENER = "removePresenceListener"
  private val GET_CHANNELS = "getChannels"
  private val GET_USERS_IN_CHANNEL = "getUsersInChannel"
  private val GET_USERS = "getUsers"
  private val GET_MESSAGES = "getMessages"
  private val CREATE_CHANNEL = "createChannel"
  private val UPDATE_CHANNEL = "updateChannel"
  private val DELETE_CHANNEL = "deleteChannel"
  private val SEND_START_TYPING = "sendStartTyping"
  private val SEND_STOP_TYPING = "sendStopTyping"
  private val MARK_SEEN_MESSAGE = "markSeenMessage"
  private val MARK_RECEIVE_MESSAGE = "markReceiveMessage"
  private val CREATE_MESSAGE = "createMessage"
  private val UPDATE_MESSAGE = "updateMessage"
  private val DELETE_MESSAGE = "deleteMessage"
  private val INVITE_USER_TO_CHANNEL = "inviteUserToChannel"
  private val REMOVE_USER_FROM_CHANNEL = "removeUserFromChannel"
  private val GET_USER_PRESENCE = "getUserPresence"
  private val SEARCH_CHANNELS = "searchChannels"
  private val UPDATE_FCM_TOKEN = "updateFCMToken";
  private val LOGOUT_BLACHATSDK = "logoutBlaChatSDK";


  var thread: Thread? = null

  val SHARED_PREFERENCES_NAME = "shared_preference"
  private var context: Activity? = null
  private var channel: MethodChannel? = null
  var myGson = GsonBuilder().registerTypeAdapter(Date::class.java, MyDateTypeAdapter()).setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").create()

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "bla_chat_sdk")
      val bien = BlaChatSdkPlugin()
      bien.setupChannel(registrar.messenger(), registrar.activity(), channel)
      channel.setMethodCallHandler(bien)
    }
  }

  private fun setupChannel(messenger: BinaryMessenger, activity: Activity, channel: MethodChannel) {
    this.channel = channel
    this.context = activity
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val arguments = call.arguments as Map<*, *>;
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == INIT_BLACHATSDK) {
      val sharedPreferences = context?.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);

      try {
        if (arguments["userId"] == null || arguments["token"] == null) {
          result.error("INIT", "arguments must not be null", "userid or token is null")
          return
        }
        val userId = arguments["userId"] as String;
        val token = arguments["token"] as String;
        BlaChatSDK.getInstance().initBlaChatSDK(this.context, userId, token)
      } catch (e: Exception) {
        result.error("INIT", e.message, e)
      }


      BlaChatSDK.getInstance().addChannelListener(object : ChannelEventListener {
        override fun onMemberLeave(p0: BlaChannel?, p1: BlaUser?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            val dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onMemberLeave", dict)
          }
        }

        override fun onUserReceiveMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            dict["message"] = myGson.toJson(p2)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserReceiveMessage", dict)
          }
        }

        override fun onDeleteChannel(p0: BlaChannel?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onDeleteChannel", dict)
          }
        }

        override fun onTyping(p0: BlaChannel?, p1: BlaUser?, p2: EventType?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            dict["type"] = if (p2 == EventType.START) 1 else 0
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onTyping", dict)
          }
        }

        override fun onNewChannel(p0: BlaChannel?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onNewChannel", dict)
          }
        }

        override fun onUserSeenMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            dict["message"] = myGson.toJson(p2)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserSeenMessage", dict)
          }
        }

        override fun onUpdateChannel(p0: BlaChannel?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUpdateChannel", dict)
          }
        }

        override fun onMemberJoin(p0: BlaChannel?, p1: BlaUser?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["channel"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onMemberJoin", dict)
          }
        }
      })

      BlaChatSDK.getInstance().addMessageListener(object : MessagesListener {
        override fun onNewMessage(p0: BlaMessage?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            Log.i("test", "onNewMessage " + myGson.toJson(p0))
            dict["message"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onNewMessage", dict)
          }
        }

        override fun onUpdateMessage(p0: BlaMessage?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            var dict = HashMap<String, Any>()
            dict["message"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUpdateMessage", dict)
          }
        }

        override fun onDeleteMessage(p0: BlaMessage?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            val dict = HashMap<String, Any>()
            dict["message"] = myGson.toJson(p0)
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onDeleteMessage", dict)
          }
        }

        override fun onUserSeen(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            val dict = HashMap<String, Any>()
            dict["message"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            dict["seenAt"] = p2!!.time
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserSeen", dict)
          }
        }

        override fun onUserReceive(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
          this@BlaChatSdkPlugin.context?.runOnUiThread {
            val dict = HashMap<String, Any>()
            dict["message"] = myGson.toJson(p0)
            dict["user"] = myGson.toJson(p1)
            dict["receivedAt"] = p2!!.time
            this@BlaChatSdkPlugin.channel!!.invokeMethod("onUserReceive", dict)
          }
        }
      })
      BlaChatSDK.getInstance().addPresenceListener { user ->
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["channel"] = myGson.toJson(user)
          this@BlaChatSdkPlugin.channel!!.invokeMethod("onTyping", dict)
        }
      }
      val dict = HashMap<String, Any>()
      dict["isSuccess"] = true
      dict["result"] = true
      val jsonString = Gson().toJson(dict);
      result.success(jsonString)
    } else if (call.method == ADD_MESSSAGE_LISTENER) {
      //TODO:
    } else if (call.method == REMOVE_MESSSAGE_LISTENER) {

    } else if (call.method == ADD_CHANNEL_LISTENER) {

    } else if (call.method == REMOVE_CHANNEL_LISTENER) {

    } else if (call.method == ADD_PRESENCE_LISTENER) {

    } else if (call.method == REMOVE_PRESENCE_LISTENER) {

    } else if (call.method == GET_CHANNELS) {
      try {
        if (arguments == null) {
          result.error("01", "arguments is null", arguments)
          return
        }
        val limit = arguments["limit"] as Int
        val lastId = arguments["lastId"] as String
        BlaChatSDK.getInstance().getChannels(lastId, limit, object : Callback<List<BlaChannel>> {
          override fun onSuccess(p0: List<BlaChannel>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }

          override fun onFail(p0: Exception?) {
            p0?.printStackTrace()
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == GET_USERS_IN_CHANNEL) {
      try {
        val channelId = arguments["channelId"] as String
        BlaChatSDK.getInstance().getUsersInChannel(channelId, object : Callback<List<BlaUser>> {
          override fun onSuccess(p0: List<BlaUser>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                val dict = HashMap<String, Any>()
                dict["isSuccess"] = true
                dict["result"] = myGson.toJson(p0)
                val jsonString = myGson.toJson(dict)
                result.success(jsonString)
              }
            })
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                val dict = HashMap<String, Any>()
                dict["isSuccess"] = false
                dict["message"] = p0.toString()
                val jsonString = myGson.toJson(dict)
                result.success(jsonString)
              }
            })
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == GET_USERS) {
      try {
        val userIds = arguments["userIds"] as String
        val listUserId = userIds.split(",").toMutableList() as ArrayList<String>
        BlaChatSDK.getInstance().getUsers(listUserId, object : Callback<List<BlaUser>> {
          override fun onSuccess(p0: List<BlaUser>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                val dict = HashMap<String, Any>()
                dict["isSuccess"] = true
                dict["result"] = myGson.toJson(p0)
                val jsonString = myGson.toJson(dict)
                result.success(jsonString)
              }
            })
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread(object : Runnable {
              override fun run() {
                val dict = HashMap<String, Any>()
                dict["isSuccess"] = false
                dict["message"] = p0.toString()
                val jsonString = myGson.toJson(dict)
                result.success(jsonString)
              }
            })
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == GET_MESSAGES) {
      try {
        val channelId = arguments["channelId"] as String
        val lastId = arguments["lastId"] as String
        val limit = arguments["limit"] as Int
        BlaChatSDK.getInstance().getMessages(channelId, lastId, limit, object : Callback<List<BlaMessage>> {
          override fun onSuccess(p0: List<BlaMessage>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == CREATE_CHANNEL) {
      try {
        val name = arguments["name"] as String
        val userIds = arguments["userIds"] as String
        val type = arguments["type"] as Int
        val avatar = arguments["avatar"] as String
        val customDataString = arguments["customData"] as String
        val customData = GsonUtil.jsonToMap(customDataString)
        val listUserId = userIds.split(",").toMutableList() as ArrayList<String>
        var channelType = BlaChannelType.GROUP
        if (type == 2) {
          channelType = BlaChannelType.DIRECT
        }
        BlaChatSDK.getInstance().createChannel(name, avatar, listUserId, channelType, customData, object : Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == UPDATE_CHANNEL) {
      try {
        val jsonChannel = arguments["channel"] as String
        val channel = myGson.fromJson(jsonChannel, BlaChannel::class.java)

        BlaChatSDK.getInstance().updateChannel(channel, object : Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            p0?.toString();
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == DELETE_CHANNEL) {
      try {
        val jsonChannel = arguments["channel"] as String
        val channel = myGson.fromJson(jsonChannel, BlaChannel::class.java)

        BlaChatSDK.getInstance().deleteChannel(channel, object : Callback<BlaChannel> {
          override fun onSuccess(p0: BlaChannel?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {

              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == SEND_START_TYPING) {
      try {
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().sendStartTyping(channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = p0 ?: false
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == SEND_STOP_TYPING) {
      try {
        val channelId = arguments["channelId"] as String
        BlaChatSDK.getInstance().sendStopTyping(channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = p0 ?: false
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == MARK_SEEN_MESSAGE) {
      try {
        val messageId = arguments["messageId"] as String
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().markSeenMessage(messageId, channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any?>()
              dict["isSuccess"] = p0 ?: false
              dict["result"] = null
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == MARK_RECEIVE_MESSAGE) {
      try {
        val messageId = arguments["messageId"] as String
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().markReceiveMessage(messageId, channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = p0 ?: false
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              var dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
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
        val customDataString = arguments["customData"] as String

        val customData = GsonUtil.jsonToMap(customDataString)

        BlaChatSDK.getInstance().createMessage(content, channelId, blaMessageType, customData, object : Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == UPDATE_MESSAGE) {
      try {
        val jsonMessage = arguments["message"] as String
        val message = myGson.fromJson(jsonMessage, BlaMessage::class.java)

        BlaChatSDK.getInstance().updateMessage(message, object : Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == DELETE_MESSAGE) {
      try {
        val jsonMessage = arguments["message"] as String
        val message = myGson.fromJson(jsonMessage, BlaMessage::class.java)
        BlaChatSDK.getInstance().deleteMessage(message, object : Callback<BlaMessage> {
          override fun onSuccess(p0: BlaMessage?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(p0)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == INVITE_USER_TO_CHANNEL) {
      try {
        val userIds = arguments["userIds"] as String
        val channelId = arguments["channelId"] as String
        val listUserId = userIds.split(",").toMutableList() as ArrayList<String>

        BlaChatSDK.getInstance().inviteUserToChannel(listUserId, channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = p0 ?: false
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == REMOVE_USER_FROM_CHANNEL) {
      try {
        val userId = arguments["userId"] as String
        val channelId = arguments["channelId"] as String

        BlaChatSDK.getInstance().removeUserFromChannel(userId, channelId, object : Callback<Boolean> {
          override fun onSuccess(p0: Boolean?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = p0 ?: false
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(p0: Exception?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = false
              dict["message"] = p0.toString()
              val jsonString = myGson.toJson(dict);
              result.success(jsonString);
            }
          }
        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == GET_USER_PRESENCE) {
      try {
        BlaChatSDK.getInstance().getUserPresence(object : Callback<List<BlaUser>> {
          override fun onSuccess(rs: List<BlaUser>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(rs)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(e: Exception?) {
            val dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = e.toString()
            val jsonString = myGson.toJson(dict);
            result.success(jsonString)
          }
        })
      } catch(e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == SEARCH_CHANNELS) {
      try {
        val q = arguments["query"] as String
        BlaChatSDK.getInstance().searchChannels(q, object : Callback<List<BlaChannel>> {
          override fun onSuccess(rs: List<BlaChannel>?) {
            this@BlaChatSdkPlugin.context?.runOnUiThread {
              val dict = HashMap<String, Any>()
              dict["isSuccess"] = true
              dict["result"] = myGson.toJson(rs)
              val jsonString = myGson.toJson(dict)
              result.success(jsonString)
            }
          }

          override fun onFail(e: Exception?) {
            val dict = HashMap<String, Any>()
            dict["isSuccess"] = false
            dict["message"] = e.toString()
            val jsonString = myGson.toJson(dict);
            result.success(jsonString)
          }

        })
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == UPDATE_FCM_TOKEN) {
      try {
        val fcmToken = arguments["fcmToken"] as String
        BlaChatSDK.getInstance().updateFCMToken(fcmToken);
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else if (call.method == LOGOUT_BLACHATSDK) {
      try {
        BlaChatSDK.getInstance().logout()
      } catch (e: Exception) {
        this@BlaChatSdkPlugin.context?.runOnUiThread {
          val dict = HashMap<String, Any>()
          dict["isSuccess"] = false
          dict["message"] = e.toString()
          val jsonString = myGson.toJson(dict);
          result.success(jsonString)
        }
      }
    } else {
      result.notImplemented()
    }
  }
}
