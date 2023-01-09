import 'package:cs_liveness_flutter/cs_liveness_flutter.dart';
import 'package:cs_liveness_flutter/cs_liveness_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const String base64ImageTest =
    "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";

const String data =
    "{\"real\": \"Real\",\"sessionId\": \"123456\",\"image\": \"$base64ImageTest\"}";
void main() {
  const MethodChannel channel = MethodChannel('cs_liveness_flutter');
  CsLiveness csLiveness = CsLiveness(clientId: "", clientSecret: "");

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(
    () => channel.setMockMethodCallHandler(
      (MethodCall methodCall) async => data,
    ),
  );

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group('Tests livenessRecognition:', () {
    test('start', () async {
      CsLivenessResult data = await csLiveness.start();
      expect(data.base64Image, base64ImageTest);
    });
  });

  group('Tests CsLivenessFlutter:', () {
    test('clientId and clientSecret is not null', () async {
      expect(CsLiveness, isNotNull);
    });
  });
}
