import 'package:flutter/services.dart';
import 'package:liveness_flutter_sdk/liveness_flutter_sdk_data.dart';

import 'liveness_flutter_sdk_platform_interface.dart';

class LivenessFlutterSdk {
  Future<CSLivenessResult> openCSLiveness(
      {String? accessToken,
      String? transactionId,
      String? clientId,
      String? clientSecretId,
      String? identifierId,
      String? cpf,
      bool? vocalGuidance,
      Color? primaryColor,
      Color? secondaryColor,
      Color? titleColor,
      Color? paragraphColor}) {
    return LivenessFlutterSdkPlatform.instance.openCSLiveness(
        accessToken: accessToken,
        transactionId: transactionId,
        clientId: clientId,
        clientSecretId: clientSecretId,
        identifierId: identifierId,
        cpf: cpf,
        vocalGuidance: vocalGuidance,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        titleColor: titleColor,
        paragraphColor: paragraphColor);
  }
}
