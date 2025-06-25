import 'package:flutter/services.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_data.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_environments.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'liveness_flutter_sdk_method_channel.dart';

abstract class LivenessFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a LivenessFlutterSdkPlatform.
  LivenessFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static LivenessFlutterSdkPlatform _instance =
      MethodChannelLivenessFlutterSdk();

  /// The default instance of [LivenessFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelLivenessFlutterSdk].
  static LivenessFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LivenessFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(LivenessFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<CSLivenessResult> openCSLiveness(
      {String? accessToken,
      String? transactionId,
      bool? vocalGuidance,
      Color? primaryColor,
      Color? secondaryColor,
      Color? titleColor,
      Color? paragraphColor,
      LivenessEnvironments? environment}) {
    throw UnimplementedError('openCSLiveness() has not been implemented.');
  }
}
