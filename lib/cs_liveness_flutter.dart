import 'dart:convert';

import 'package:cs_liveness_flutter/cs_liveness_exceptions.dart';
import 'package:cs_liveness_flutter/cs_liveness_flutter_platform_interface.dart';
import 'package:cs_liveness_flutter/cs_liveness_result.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class CsLiveness {
  late final String _clientId;
  late final String _clientSecret;
  late final bool _vocalGuidance;

  static const String _defaultError = "Não foi possível carregar a imagem.";
  static const String _authError = "AuthError";
  static const String _cameraError = "camera";
  static const String _userCancelError = "userCancel";
  static const String _imageKey = "image";
  static const String _sessionIdKey = "sessionId";
  static const String _realKey = "real";
  static const String _trueKey = "true";

  /// # CsLiveness
  ///
  /// Responsável pela comunicação entre o dispositivo e o sistema Liveness.
  ///
  /// Tem como parâmetros obrigatórios para a sua inicialização o [String] clientId e o [String] clientSecret (fornecidos pela ClearSale).
  ///
  /// ## Exemplo de uso:
  /// ```dart
  /// final CsLiveness _csLiveness = CsLiveness(clientId: "", clientSecret: "");
  ///
  /// String base64Image = await _csLiveness.start();
  ///
  /// Image? recognizedImage = _csLiveness.result?.image;
  /// String? sessionId = _csLiveness.result?.sessionId;
  /// bool? recognizedImage = _csLiveness.result?.real;
  ///
  /// ```
  CsLiveness({required String clientId, required String clientSecret, required bool vocalGuidance}) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _vocalGuidance = vocalGuidance;
  }

  /// ### Método para execucão do SDK
  ///
  /// Usado para realizar a comunicação com o Liveness ClearSale.
  ///
  /// É um método assíncrono e deve realizar o reconhecimento do rosto.
  ///
  /// #### Exemplo de uso:
  /// ```dart
  /// final csLiveness = CsLiveness(clientId: "", clientSecret: "");
  ///
  /// CsLivenessResult result = await csLiveness.start()
  ///
  /// // Results
  ///
  /// final livenessResult = await csLiveness.start();
  /// String? base64Image = livenessResult.base64Image;
  /// Image? recognizedImage = livenessResult.image;
  /// String? sessionId = livenessResult.sessionId;
  /// bool? recognizedImage = livenessResult.real;
  ///
  /// ```
  /// #### Possíveis Errors:
  /// * Throws a [CSLivenessAuthException]  se falha na autenticação.
  /// * Throws a [CSLivenessPermissionException]  se falhar premissões.
  /// * Throws a [CSLivenessCancelByUserException]  se usuário fechar ação.
  /// * Throws a [CSLivenessGenericException]  qualquer outro se não os anteriores.
  ///
  /// #### Links can be:
  ///
  /// [https://api.clearsale.com.br/docs/liveness/sdk/](https://api.clearsale.com.br/docs/liveness/sdk/)
  ///
  Future<CsLivenessResult> start() async {
    try {
      String? data = await CsLivenessPlatform.instance.livenessRecognition(
        clientId: _clientId,
        clientSecret: _clientSecret,
        vocalGuidance: _vocalGuidance
      );
      if (data != null && data.isNotEmpty) {
        final decodedData = json.decode(data);
        final image = decodedData[_imageKey].toString();
        final sessionId = decodedData[_sessionIdKey].toString();
        final realStr = decodedData[_realKey].toString();
        final real = (realStr.toLowerCase() == _realKey ||
            realStr.toLowerCase() == _trueKey);
        return CsLivenessResult(
          base64Image: image,
          image: image != null ? Image.memory(base64Decode(image)) : null,
          sessionId: sessionId,
          real: real,
        );
      } else {
        throw CSLivenessGenericException(message: _defaultError);
      }
    } on PlatformException catch (e) {
      if (e.code.toLowerCase().contains(_authError.toLowerCase())) {
        throw CSLivenessAuthException();
      } else if (e.code.toLowerCase().contains(_cameraError.toLowerCase())) {
        throw CSLivenessPermissionException();
      } else if (e.code.toLowerCase() == _userCancelError.toLowerCase()) {
        throw CSLivenessCancelByUserException();
      } else {
        throw CSLivenessGenericException(message: "$_defaultError: $e");
      }
    } catch (er) {
      throw CSLivenessGenericException(message: "$_defaultError: $er");
    }
  }
}
