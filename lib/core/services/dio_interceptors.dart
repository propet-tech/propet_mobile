import 'package:dio/dio.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';

class AppInterceptors extends Interceptor {
  final AuthService auth;

  AppInterceptors({required this.auth});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await auth.getAccessToken();
    options.headers
        .addEntries([MapEntry("Authorization", "Bearer $accessToken")]);
    super.onRequest(options, handler);
  }
}
