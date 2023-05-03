import 'package:get_it/get_it.dart';
import 'package:propet_mobile/services/auth_service.dart';

final getIt = GetIt.instance;

void setupProviders() {
  getIt.registerLazySingleton(() => AuthService());
}
