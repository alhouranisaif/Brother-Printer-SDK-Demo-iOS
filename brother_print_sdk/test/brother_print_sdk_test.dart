import 'package:flutter_test/flutter_test.dart';
import 'package:brother_print_sdk/brother_print_sdk.dart';
import 'package:brother_print_sdk/brother_print_sdk_platform_interface.dart';
import 'package:brother_print_sdk/brother_print_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBrotherPrintSdkPlatform
    with MockPlatformInterfaceMixin
    implements BrotherPrintSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<Map<String, dynamic>> onDiscovery() => const Stream.empty();

  @override
  Future<void> startNetworkSearch() async {}

  @override
  Future<void> cancelSearch() async {}
}

void main() {
  final BrotherPrintSdkPlatform initialPlatform = BrotherPrintSdkPlatform.instance;

  test('$MethodChannelBrotherPrintSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBrotherPrintSdk>());
  });

  test('getPlatformVersion', () async {
    BrotherPrintSdk brotherPrintSdkPlugin = BrotherPrintSdk();
    MockBrotherPrintSdkPlatform fakePlatform = MockBrotherPrintSdkPlatform();
    BrotherPrintSdkPlatform.instance = fakePlatform;

    expect(await brotherPrintSdkPlugin.getPlatformVersion(), '42');
  });
}
