import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/auth/auth_service.dart';
import 'package:propet_mobile/core/services/dio_interceptors.dart';
import 'package:propet_mobile/environment.dart';

@module
abstract class DioConfiguration {

  @Singleton()
  Dio dio(AuthService service) {
    final options = BaseOptions(baseUrl: AppEnvironment.api);
    final dio = Dio(options);

    // Add interceptos
    AppInterceptors interceptors = AppInterceptors(auth: service); 
    dio.interceptors.add(interceptors);

    return dio;
  }
}
