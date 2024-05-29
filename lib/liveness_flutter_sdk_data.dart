class CSLivenessResult {
  final bool real;
  final String responseMessage;
  final String sessionId;
  final String image;

  CSLivenessResult(this.real, this.responseMessage, this.sessionId, this.image);

  factory CSLivenessResult.fromJson(Map<String, dynamic> json) {
    return CSLivenessResult(
      json['real'],
      json['responseMessage'],
      json['sessionId'],
      json['image'],
    );
  }
}
