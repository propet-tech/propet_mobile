import 'package:flutter_appauth/flutter_appauth.dart';

class AppTokenResponse {
  final TokenResponse tokenResponse;
  DateTime? refreshTokenExpirationDateTime;

  String? get accessToken {
    return tokenResponse.accessToken;
  }

  String? get refreshToken {
    return tokenResponse.refreshToken;
  }

  DateTime? get accessTokenExpirationDateTime {
    return tokenResponse.accessTokenExpirationDateTime;
  }

  String? get idToken {
    return tokenResponse.idToken;
  }

  AppTokenResponse(this.tokenResponse) {
    String json = tokenResponse.tokenAdditionalParameters!['refresh_expires_in'];
    int seconds = int.parse(json);
    refreshTokenExpirationDateTime = DateTime.now().add(Duration(seconds: seconds));
  }
}
