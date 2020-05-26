import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bla_chat_sdk/bla_chat_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('bla_chat_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BlaChatSdk.platformVersion, '42');
  });
}
