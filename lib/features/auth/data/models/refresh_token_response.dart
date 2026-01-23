// Refresh Token Response Model
class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String type;

  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.type,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      type: json['type'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'type': type,
    };
  }
}

