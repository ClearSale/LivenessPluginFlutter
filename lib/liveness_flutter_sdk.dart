
import 'liveness_flutter_sdk_platform_interface.dart';

class LivenessFlutterSdk {
  Future<String?> getPlatformVersion() {
    return LivenessFlutterSdkPlatform.instance.getPlatformVersion();
  }
}
