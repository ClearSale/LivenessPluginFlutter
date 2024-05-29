import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'liveness_flutter_sdk_platform_interface.dart';

/// An implementation of [LivenessFlutterSdkPlatform] that uses method channels.
class MethodChannelLivenessFlutterSdk extends LivenessFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('liveness_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
