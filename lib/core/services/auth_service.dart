import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/services/secure_storage_service.dart';
import 'package:propet_mobile/environment.dart';

@Singleton()
class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final SecureStorageService storage;
  final String _redirectUrl = 'com.duendesoftware.demo:/oauthredirect';
  final String _postLogoutRedirectUrl = 'com.duendesoftware.demo:/';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access'
  ];
  TokenResponse? _token;

  AuthService(this.storage);

  String? get accessToken => _token?.accessToken;

  Future<void> login() async {
    _token = await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        AppEnvironment.clientId,
        _redirectUrl,
        issuer: AppEnvironment.issuerUrl,
        allowInsecureConnections: true,
        scopes: _scopes,
      ),
    );
    await _saveToken();
  }

  Future<void> logout() async {
    await _appAuth.endSession(
      EndSessionRequest(
        idTokenHint: _token?.idToken,
        postLogoutRedirectUrl: _postLogoutRedirectUrl,
        issuer: AppEnvironment.issuerUrl,
      ),
    );
    _token = null;
  }

  bool isAuthenticated() {
    return _token != null;
  }

  Future<String?> getAccessTokenAndRefresh() async {
    if (_token == null) return null;

    var token = _token!;

    if (token.accessToken != null &&
        token.accessTokenExpirationDateTime!.isAfter(DateTime.now())) {
      return token.accessToken;
    }

    if (token.refreshToken != null) {
      await refreshToken(_token!.refreshToken!);
      return _token!.accessToken;
    }

    return null;
  }

  Future<void> _saveToken() async {
    var refreshToken = _token!.refreshToken!;
    await storage.writeSecureData(StorageItem("token", refreshToken));
  }

  Future<void> autoLogin() async {
    var token = await storage.readSecureData("token");
    await refreshToken(token!);
  }

  Future<void> refreshToken(String refreshToken) async {
    try {
      _token = await _appAuth.token(
        TokenRequest(
          AppEnvironment.clientId,
          _redirectUrl,
          refreshToken: refreshToken,
          allowInsecureConnections: true,
          issuer: AppEnvironment.issuerUrl,
          scopes: _scopes,
        ),
      );
      await _saveToken();
    } on PlatformException catch(ex) {
      debugPrint(ex.toString());
      _token = null;
    }
  }
}
