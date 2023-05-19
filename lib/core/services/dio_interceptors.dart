import 'package:dio/dio.dart';
import 'package:propet_mobile/core/services/auth_service.dart';

class AppInterceptors extends Interceptor {
  final AuthService app;

  AppInterceptors({required this.app});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? accessToken = await app.getAccessTokenAndRefresh();

    options.headers
        .addEntries([MapEntry("Authorization", "Bearer $accessToken")]);
    super.onRequest(options, handler);
  }
}
