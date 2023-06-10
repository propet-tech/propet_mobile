import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/core/dio_image_provider.dart';
import 'package:propet_mobile/core/services/auth_service.dart';
import 'package:propet_mobile/core/services/dio_interceptors.dart';
import 'package:propet_mobile/environment.dart';

@module
abstract class DioConfiguration {

  @Singleton()
  Dio dio(AuthService app) {
    final options = BaseOptions(baseUrl: "http://${AppEnvironment.api}");
    final dio = Dio(options);

    // Add interceptos
    AppInterceptors interceptors = AppInterceptors(app: app); 
    dio.interceptors.add(interceptors);

    // Image
    final dioImage = Dio();
    dioImage.interceptors.add(interceptors);
    DioImage.defaultDio = dioImage;

    return dio;
  }
}
