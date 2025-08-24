
import 'brother_print_sdk_platform_interface.dart';

class BrotherPrintSdk {
  Future<String?> getPlatformVersion() {
    return BrotherPrintSdkPlatform.instance.getPlatformVersion();
  }

  Stream<Map<String, dynamic>> onDiscovery() {
    return BrotherPrintSdkPlatform.instance.onDiscovery();
  }

  Future<void> startNetworkSearch() {
    return BrotherPrintSdkPlatform.instance.startNetworkSearch();
  }

  Future<void> cancelSearch() {
    return BrotherPrintSdkPlatform.instance.cancelSearch();
  }
}
