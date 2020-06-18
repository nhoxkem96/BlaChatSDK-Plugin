import 'dart:core';
import 'BlaChannelType.dart';
import 'BlaMessageType.dart';
import 'EventType.dart';

class BlaUtils {

  static EventType initEventType(int value) {
    switch (value) {
      case 0:
        return EventType.STOP;
      case 1:
        return EventType.START;
      default:
        return EventType.STOP;
    }
  }

  static BlaChannelType initBlaChannelType(int value) {
    switch (value) {
      default:
        return BlaChannelType.GROUP;
    }
  }

  static BlaMessageType initBlaMessageType(int value) {
    switch (value) {
      default:
        return BlaMessageType.TEXT;
    }
  }

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
