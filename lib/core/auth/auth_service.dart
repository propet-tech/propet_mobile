import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/auth/app_token_reesponse.dart';
import 'package:propet_mobile/core/services/secure_storage_service.dart';
import 'package:propet_mobile/environment.dart';

@Singleton()
class AuthService extends ChangeNotifier {

  final FlutterAppAuth appAuth = const FlutterAppAuth();
  final String _redirectUrl = 'com.duendesoftware.demo:/oauthredirect';
  final String _postLogoutRedirectUrl = 'com.duendesoftware.demo:/';
  final List<String> _scopes = <String>['openid', 'profile', 'email'];
  final SecureStorageService secureStorage;

  AppTokenResponse? _token;

  AuthService(this.secureStorage);

  Future<String?> getAccessToken() async {
    var token = _token!;
    if (token.accessToken != null &&
        token.accessTokenExpirationDateTime!.isAfter(DateTime.now())) {
      return token.accessToken;
    }

    if (token.refreshToken != null &&
        token.refreshTokenExpirationDateTime!.isAfter(DateTime.now())) {
      await _refresh(token.refreshToken!);
      return _token!.accessToken;
    }
  }

  bool isAuthenticated() {
    return _token != null &&
        _token!.accessTokenExpirationDateTime!.isAfter(DateTime.now());
  }

  @PostConstruct(preResolve: true)
  Future<void> loginFromSecureStorage() async {
    try {
      final refreshTokenExpiration =
          await secureStorage.readSecureData("refreshTokenExpirationDateTime");

      var expirationDateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(refreshTokenExpiration!));

      if (expirationDateTime.isAfter(DateTime.now())) {
        final refreshToken = await secureStorage.readSecureData("refreshToken");
        await _refresh(refreshToken!);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> login() async {
    final token = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AppEnvironment.clientId,
        _redirectUrl,
        issuer: AppEnvironment.issuerUrl,
        allowInsecureConnections: true,
        scopes: _scopes,
      ),
    );
    _token = AppTokenResponse(token!);
    await _saveToken();
    notifyListeners();
  }

  Future<void> _refresh(String refreshToken) async {
    var token = await appAuth.token(
      TokenRequest(
        AppEnvironment.clientId,
        _redirectUrl,
        refreshToken: refreshToken,
        allowInsecureConnections: true,
        issuer: AppEnvironment.issuerUrl,
        scopes: _scopes,
      ),
    );
    _token = AppTokenResponse(token!);
    await _saveToken();
  }

  Future<void> _saveToken() async {
    await secureStorage.writeSecureData(
      StorageItem(
        "refreshToken",
        _token!.refreshToken!,
      ),
    );
    await secureStorage.writeSecureData(
      StorageItem(
        "refreshTokenExpirationDateTime",
        _token!.refreshTokenExpirationDateTime!.millisecondsSinceEpoch
            .toString(),
      ),
    );
  }

  Future<void> logout() async {
    // TODO Mudar para uma exeception
    if (_token == null) return;
    await appAuth.endSession(
      EndSessionRequest(
        idTokenHint: _token!.idToken,
        postLogoutRedirectUrl: _postLogoutRedirectUrl,
        issuer: AppEnvironment.issuerUrl,
      ),
    );
    _token = null;
    notifyListeners();
  }
}
