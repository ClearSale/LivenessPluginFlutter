import 'package:liveness_flutter_sdk/liveness_flutter_sdk_extend_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_data.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_environments.dart';

import 'liveness_flutter_sdk_platform_interface.dart';

/// An implementation of [LivenessFlutterSdkPlatform] that uses method channels.
class MethodChannelLivenessFlutterSdk extends LivenessFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('liveness_flutter_sdk');

  @override
  Future<CSLivenessResult> openCSLiveness(
      {String? accessToken,
      String? transactionId,
      bool? vocalGuidance,
      Color? primaryColor,
      Color? secondaryColor,
      Color? titleColor,
      Color? paragraphColor,
      LivenessEnvironments? environment}) async {
    final Map<String, dynamic>? response =
        await methodChannel.invokeMapMethod('openCSLiveness', {
      "accessToken": accessToken,
      "transactionId": transactionId,
      "vocalGuidance": vocalGuidance == true,
      "primaryColor": primaryColor?.toHexString(enableAlpha: false),
      "secondaryColor": secondaryColor?.toHexString(enableAlpha: false),
      "titleColor": titleColor?.toHexString(enableAlpha: false),
      "paragraphColor": paragraphColor?.toHexString(enableAlpha: false),
      "environment": environment?.value,
    });

    if (response != null) {
      return CSLivenessResult.fromJson(
          response.cast().map((k, v) => MapEntry(k.toString(), v)));
    }

    throw "No response from native side";
  }
}
