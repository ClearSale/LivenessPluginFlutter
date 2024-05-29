class CSLivenessResult {
  final bool real;
  final String sessionId;
  final String image;
  final String? responseMessage;

  CSLivenessResult(this.real, this.sessionId, this.image, this.responseMessage);

  factory CSLivenessResult.fromJson(Map<String, dynamic> json) {
    return CSLivenessResult(
      json['real'],
      json['sessionId'],
      json['image'],
      json['responseMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "real": real,
      "responseMessage": responseMessage,
      "sessionId": sessionId,
      "image": image,
    };
  }
}
