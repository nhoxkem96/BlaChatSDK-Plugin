import 'dart:core';

class BlaConstants {

  static String INIT_BLACHATSDK= "initBlaChatSDK";
  static String ADD_MESSSAGE_LISTENER = "addMessageListener";
  static String REMOVE_MESSSAGE_LISTENER = "removeMessageListener";
  static String ADD_CHANNEL_LISTENER = "addChannelListener";
  static String REMOVE_CHANNEL_LISTENER = "removeChannelListener";
  static String ADD_PRESENCE_LISTENER = "addPresenceListener";
  static String REMOVE_PRESENCE_LISTENER = "removePresenceListener";
  static String GET_CHANNELS = "getChannels";
  static String GET_USERS_IN_CHANNEL = "getUsersInChannel";
  static String GET_USERS = "getUsers";
  static String GET_MESSAGES = "getMessages";
  static String CREATE_CHANNEL = "createChannel";
  static String UPDATE_CHANNEL = "updateChannel";
  static String DELETE_CHANNEL = "deleteChannel";
  static String SEND_START_TYPING = "sendStartTyping";
  static String SEND_STOP_TYPING = "sendStopTyping";
  static String MARK_SEEN_MESSAGE = "markSeenMessage";
  static String MARK_RECEIVE_MESSAGE = "markReceiveMessage";
  static String CREATE_MESSAGE = "createMessage";
  static String UPDATE_MESSAGE = "updateMessage";
  static String DELETE_MESSAGE = "deleteMessage";
  static String INVITE_USER_TO_CHANNEL = "inviteUserToChannel";
  static String REMOVE_USER_FROM_CHANNEL = "removeUserFromChannel";
  static String GET_USER_PRESENCE = "getUserPresence";
  static String SEARCH_CHANNELS = "searchChannels";

  //Listener

  static final String ON_NEW_MESSAGE = "getUserPresence";
  static final String ON_UPDATE_MESSAGE = "getUserPresence";
  static final String ON_DELETE_MESSAGE = "getUserPresence";
  static final String ON_USER_SEEN = "getUserPresence";
  static final String ON_USER_RECEIVE = "getUserPresence";
  static final String ON_UPDATE = "getUserPresence";
  static final String ON_NEW_CHANNEL = "getUserPresence";
  static final String ON_UPDATE_CHANNEL = "getUserPresence";
  static final String ON_DELETE_CHANNEL = "getUserPresence";
  static final String ON_USER_SEEN_MESSAGE = "getUserPresence";
  static final String ON_USER_RECEIVE_MESSAGE = "getUserPresence";
  static final String ON_TYPING = "getUserPresence";
  static final String ON_MEMBER_JOIN = "getUserPresence";
  static final String ON_MEMBER_LEAVE = "getUserPresence";
}