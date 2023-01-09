// ignore_for_file: public_member_api_docs, sort_constructors_first
const String _authException =
    "Não foi possível autenticar-se. Verifique a sua conexão e a suas credenciais";

const String _permissionException =
    "A permisão para uso da câmera é necessária";

const String _cancelByUserException = "Operação cancelada pelo usuário";

class CSLivenessGenericException implements Exception {
  final String message;
  CSLivenessGenericException({required this.message});

  @override
  String toString() => '$message';
}

class CSLivenessAuthException implements Exception {
  final String message;
  CSLivenessAuthException({this.message = _authException});
}

class CSLivenessPermissionException implements Exception {
  final String message;
  CSLivenessPermissionException({this.message = _permissionException});
}

class CSLivenessCancelByUserException implements Exception {
  final String message;
  CSLivenessCancelByUserException({this.message = _cancelByUserException});
}
