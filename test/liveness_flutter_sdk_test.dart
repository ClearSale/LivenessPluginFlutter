import 'package:flutter_test/flutter_test.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_platform_interface.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLivenessFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements LivenessFlutterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LivenessFlutterSdkPlatform initialPlatform = LivenessFlutterSdkPlatform.instance;

  test('$MethodChannelLivenessFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLivenessFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    LivenessFlutterSdk livenessFlutterSdkPlugin = LivenessFlutterSdk();
    MockLivenessFlutterSdkPlatform fakePlatform = MockLivenessFlutterSdkPlatform();
    LivenessFlutterSdkPlatform.instance = fakePlatform;

    expect(await livenessFlutterSdkPlugin.getPlatformVersion(), '42');
  });
}
