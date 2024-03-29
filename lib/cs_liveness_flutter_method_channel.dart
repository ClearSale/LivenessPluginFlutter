import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cs_liveness_flutter_platform_interface.dart';

class MethodChannelCsLiveness extends CsLivenessPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('cs_liveness_flutter');

  @override
  Future<String?> livenessRecognition(
      {required String clientId, required String clientSecret, required bool vocalGuidance}) async {
    return await methodChannel.invokeMethod<String>('livenessRecognition',
        {"clientId": clientId, "clientSecret": clientSecret, "vocalGuidance": vocalGuidance});
  }
}
