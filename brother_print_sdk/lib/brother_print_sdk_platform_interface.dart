import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'brother_print_sdk_method_channel.dart';

abstract class BrotherPrintSdkPlatform extends PlatformInterface {
  /// Constructs a BrotherPrintSdkPlatform.
  BrotherPrintSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static BrotherPrintSdkPlatform _instance = MethodChannelBrotherPrintSdk();

  /// The default instance of [BrotherPrintSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelBrotherPrintSdk].
  static BrotherPrintSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BrotherPrintSdkPlatform] when
  /// they register themselves.
  static set instance(BrotherPrintSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Stream<Map<String, dynamic>> onDiscovery() {
    throw UnimplementedError('onDiscovery() has not been implemented.');
  }

  Future<void> startNetworkSearch() {
    throw UnimplementedError('startNetworkSearch() has not been implemented.');
  }

  Future<void> cancelSearch() {
    throw UnimplementedError('cancelSearch() has not been implemented.');
  }
}
