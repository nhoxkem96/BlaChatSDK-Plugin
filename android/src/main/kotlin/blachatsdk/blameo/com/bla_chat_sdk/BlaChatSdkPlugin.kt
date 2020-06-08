package blachatsdk.blameo.com.bla_chat_sdk

import android.content.Context
import android.content.SharedPreferences
import android.preference.PreferenceManager
import com.blameo.chatsdk.blachat.BlaChannelEventListener
import com.blameo.chatsdk.blachat.BlaChatSDK
import com.blameo.chatsdk.blachat.BlaMessageListener
import com.blameo.chatsdk.blachat.BlaPresenceListener
import com.blameo.chatsdk.models.bla.BlaChannel
import com.blameo.chatsdk.models.bla.BlaMessage
import com.blameo.chatsdk.models.bla.BlaTypingEvent
import com.blameo.chatsdk.models.bla.BlaUser
import com.google.gson.JsonObject
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


class BlaChatSdkPlugin: MethodCallHandler {

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

  val SHARED_PREFERENCES_NAME = "shared_preference"
  private var context: Context? = null
  private var channel: MethodChannel? = null
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "bla_chat_sdk")
      channel.setMethodCallHandler(BlaChatSdkPlugin())
    }
  }

  private fun setupChannel(messenger: BinaryMessenger, context: Context) {
    this.context = context
    this.channel = channel
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    val  arguments = call.arguments as Map<String, Any>;
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == INIT_BLACHATSDK) {
      val sharedPreferences = context?.getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE);
      val userId = arguments["userId"] as String;
      val token = arguments["token"] as String;
      // save
      sharedPreferences?.edit()?.putString("user_id", userId)
      sharedPreferences?.edit()?.putString("token", token)
      BlaChatSDK.getInstance().addMessageListener(object:BlaMessageListener{
        override fun onNewMessage(p0: BlaMessage?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUpdateMessage(p0: BlaMessage?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onDeleteMessage(p0: BlaMessage?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUserSeen(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUserReceive(p0: BlaMessage?, p1: BlaUser?, p2: Date?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }
      })

      BlaChatSDK.getInstance().addEventChannelListener(object: BlaChannelEventListener{
        override fun onMemberLeave(p0: BlaChannel?, p1: BlaUser?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUserReceiveMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onDeleteChannel(p0: BlaChannel?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onTyping(p0: BlaChannel?, p1: BlaUser?, p2: BlaTypingEvent?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onNewChannel(p0: BlaChannel?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUserSeenMessage(p0: BlaChannel?, p1: BlaUser?, p2: BlaMessage?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onUpdateChannel(p0: BlaChannel?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }

        override fun onMemberJoin(p0: BlaChannel?, p1: BlaUser?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }
      })
      
      BlaChatSDK.getInstance().addPresenceListener(object:BlaPresenceListener {
        override fun onUpdate(p0: BlaUser?) {
          TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        }
      })

    } else if (call.method == ADD_MESSSAGE_LISTENER) {

    } else if (call.method == REMOVE_MESSSAGE_LISTENER) {

    } else if (call.method == ADD_CHANNEL_LISTENER) {

    } else if (call.method == REMOVE_CHANNEL_LISTENER) {

    } else if (call.method == ADD_PRESENCE_LISTENER) {

    } else if (call.method == REMOVE_PRESENCE_LISTENER) {

    } else if (call.method == GET_CHANNELS) {
      val limit = arguments["limit"] as Int;
      val lastId = arguments["lastId"] as String;
//      var channels = BlaChatSDK.getInstance().getChannels();
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
