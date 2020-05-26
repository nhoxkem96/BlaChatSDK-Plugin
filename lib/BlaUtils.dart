import 'dart:core';
import 'BlaChannelType.dart';
import 'BlaMessageType.dart';
import 'BlaPresenceState.dart';
import 'EventType.dart';

class BlaUtils {
  static int getChannelTypeRawValue(BlaChannelType type) {
    switch (type) {
      case BlaChannelType.DIRECT:
        return 2;
      case BlaChannelType.GROUP:
        return 1;
      default:
        return 1;
    }
  }

  static int getBlaPresenceStateRawValue(BlaPresenceState state) {
    switch (state) {
      case BlaPresenceState.OFFFLINE:
        return 1;
      case BlaPresenceState.ONLINE:
        return 2;
      default:
        return 1;
    }
  }

  static int getEventTypeValue(EventType type) {
    switch (type ){
      case EventType.START:
        return 1;
      case EventType.STOP:
        return 2;
      default:
        return 2;
    }
  }

  static int getBlaMessageTypeRawValue(BlaMessageType type) {
    switch (type) {
      default:
        return 1;
    }
  }
}
