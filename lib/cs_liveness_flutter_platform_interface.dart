import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cs_liveness_flutter_method_channel.dart';

abstract class CsLivenessPlatform extends PlatformInterface {
  CsLivenessPlatform() : super(token: _token);

  static final Object _token = Object();

  static CsLivenessPlatform _instance = MethodChannelCsLiveness();

  static CsLivenessPlatform get instance => _instance;

  static set instance(CsLivenessPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> livenessRecognition(
      {required String clientId, required String clientSecret, required bool vocalGuidance}) {
    throw UnimplementedError('livenessRecognition() has not been implemented.');
  }
}
