import 'package:liveness_flutter_sdk/liveness_flutter_sdk_extend_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_data.dart';

import 'liveness_flutter_sdk_platform_interface.dart';

/// An implementation of [LivenessFlutterSdkPlatform] that uses method channels.
class MethodChannelLivenessFlutterSdk extends LivenessFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('liveness_flutter_sdk');

  @override
  Future<CSLivenessResult> openCSLiveness(
      String clientId,
      String clientSecretId,
      String identifierId,
      String cpf,
      Color primaryColor,
      Color secondaryColor,
      Color titleColor,
      Color paragraphColor) async {
    final Map<dynamic, dynamic>? response =
    await methodChannel.invokeMapMethod('openCSLiveness', {
      "clientId": clientId,
      "clientSecretId": clientSecretId,
      "identifierId": identifierId,
      "cpf": cpf,
      "primaryColor": primaryColor.toHexString(),
      "secondaryColor": secondaryColor.toHexString(),
      "titleColor": titleColor.toHexString(),
      "paragraphColor": paragraphColor.toHexString()
    });

    if (response != null) {
      return CSLivenessResult.fromJson(
          response.cast() as Map<String, dynamic>);
    }

    throw "No response from native side";
  }
}
