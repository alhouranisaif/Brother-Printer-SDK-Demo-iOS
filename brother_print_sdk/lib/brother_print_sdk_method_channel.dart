import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'brother_print_sdk_platform_interface.dart';

/// An implementation of [BrotherPrintSdkPlatform] that uses method channels.
class MethodChannelBrotherPrintSdk extends BrotherPrintSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('brother_print_sdk');
  @visibleForTesting
  final eventChannel = const EventChannel('brother_print_sdk/events');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Stream<Map<String, dynamic>> onDiscovery() {
    return eventChannel.receiveBroadcastStream().map((event) => Map<String, dynamic>.from(event as Map));
  }

  @override
  Future<void> startNetworkSearch() {
    return methodChannel.invokeMethod('startNetworkSearch');
  }

  @override
  Future<void> cancelSearch() {
    return methodChannel.invokeMethod('cancelSearch');
  }
}
