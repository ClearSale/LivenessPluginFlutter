import 'package:flutter/widgets.dart';

class CsLivenessResult {
  String? _base64Image;

  /// [String?] Armazena o resultado do reconhecimento em forma de base64.
  String? get base64Image => _base64Image;

  Image? _image;

  /// [Image?] Armazena o resultado do reconhecimento em forma de [Image].
  Image? get image => _image;

  /// [String?] Armazena o ID da sessão de reconhecimento realizada.
  String? _sessionId;
  String? get sessionId => _sessionId;

  /// [bool?] Define se o rosto reconhecido é real ou não.
  bool? _real;
  bool? get real => _real;

  /// Classe que armazena o resultado da tentativa de recohecimento Liveness.
  CsLivenessResult({
    String? base64Image,
    Image? image,
    String? sessionId,
    bool? real,
  })  : this._base64Image = base64Image,
        this._image = image,
        this._sessionId = sessionId,
        this._real = real;
}
