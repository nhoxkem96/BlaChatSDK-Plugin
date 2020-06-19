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
      case 1:
        return BlaChannelType.GROUP;
      case 2:
        return BlaChannelType.DIRECT;
      default:
        return BlaChannelType.GROUP;
    }
  }

  static BlaMessageType initBlaMessageType(int value) {
    switch (value) {
      case 0:
        return BlaMessageType.TEXT;
      case 1:
        return BlaMessageType.IMAGE;
      case 2:
        return BlaMessageType.OTHER;
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
      case BlaMessageType.TEXT:
        return 0;
      case BlaMessageType.IMAGE:
        return 1;
      case BlaMessageType.OTHER:
        return 2;
      default:
        return 0;
    }
  }
}
