import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/services/secure_storage_service.dart';
import 'package:propet_mobile/environment.dart';
import 'package:propet_mobile/models/userinfo/userinfo.dart';

@Singleton()
class AuthService extends ChangeNotifier {
  final _appAuth = const FlutterAppAuth();
  final _redirectUrl = 'com.duendesoftware.demo:/oauthredirect';
  final _postLogoutRedirectUrl = 'com.duendesoftware.demo:/';
  final _scopes = <String>['openid', 'profile', 'email', 'offline_access'];
  final _http = Dio();
  final _userInfoUrl =
      "${AppEnvironment.issuerUrl}/protocol/openid-connect/userinfo";
  final SecureStorageService storage;

  TokenResponse? _token;
  UserInfo? userinfo;
  Future? future;
  bool isCompleted = true;

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
    userinfo = await getUserInfo(_token!.accessToken!);
    await _saveToken(_token!.refreshToken!);
    notifyListeners();
  }

  Future<void> autoLogin() async {
    var token = await storage.readSecureData("token");
    _token = await _refreshToken(token!);
    userinfo = await getUserInfo(_token!.accessToken!);
    notifyListeners();
  }

  Future<UserInfo> getUserInfo(String token) async {
    var result = await _http.get(
      _userInfoUrl,
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    var user = UserInfo.fromJson(result.data);
    return user;
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
    notifyListeners();
  }

  bool isAuthenticated() {
    return _token != null;
  }

  Future<String?> getAccessTokenAndRefresh() async {
    if (_token == null) return null;
    final token = _token!;

    if (token.accessToken != null &&
        token.accessTokenExpirationDateTime!.isAfter(DateTime.now())) {
      return token.accessToken;
    }

    if (token.refreshToken != null && isCompleted) {
      future = _refreshToken(_token!.refreshToken!);
      print("first");
      isCompleted = false;
      _token = await future;
      isCompleted = true;

      print("first return");
      return _token!.accessToken;
    } else {
      print("bila");
      await future;

      print("bila return");
      return _token!.accessToken;
    }

    return null;
  }

  Future<TokenResponse?> _refreshToken(String refreshToken) async {
    final token = await _appAuth.token(
      TokenRequest(
        AppEnvironment.clientId,
        _redirectUrl,
        refreshToken: refreshToken,
        allowInsecureConnections: true,
        issuer: AppEnvironment.issuerUrl,
        scopes: _scopes,
      ),
    );

    await _saveToken(token!.refreshToken!);
    return token;
  }

  Future<void> _saveToken(String refreshToken) async {
    await storage.writeSecureData(StorageItem("token", refreshToken));
  }
}
