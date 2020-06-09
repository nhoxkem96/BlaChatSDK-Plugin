package blachatsdk.blameo.com.bla_chat_sdk

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import android.preference.PreferenceManager
import com.blameo.chatsdk.blachat.*
import com.blameo.chatsdk.models.bla.*
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

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "bla_chat_sdk")
      val bien = BlaChatSdkPlugin();
      bien.setupChannel(registrar.messenger(), registrar.activity())
      channel.setMethodCallHandler(bien)
    }
  }

  private fun setupChannel(messenger: BinaryMessenger, activity: Activity) {
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
        result.success(e.message);
      }

    } else if (call.method == GET_USERS_IN_CHANNEL) {

    } else if (call.method == GET_USERS) {

    } else if (call.method == GET_MESSAGES) {

    } else if (call.method == CREATE_CHANNEL) {

    } else if (call.method == UPDATE_CHANNEL) {

    } else if (call.method == DELETE_CHANNEL) {

    } else if (call.method == SEND_START_TYPING) {

    } else if (call.method == SEND_STOP_TYPING) {

    } else if (call.method == MARK_SEEN_MESSAGE) {

    } else if (call.method == MARK_RECEIVE_MESSAGE) {

    } else if (call.method == CREATE_MESSAGE) {

    } else if (call.method == UPDATE_MESSAGE) {

    } else if (call.method == DELETE_MESSAGE) {

    } else if (call.method == INVITE_USER_TO_CHANNEL) {

    } else if (call.method == REMOVE_USER_FROM_CHANNEL) {

    } else if (call.method == GET_USER_PRESENCE) {

    } else {
      result.notImplemented()
    }
  }
}
