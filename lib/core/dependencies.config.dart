// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:propet_mobile/core/auth/auth_service.dart' as _i4;
import 'package:propet_mobile/core/services/dio_http.dart' as _i8;
import 'package:propet_mobile/core/services/secure_storage_service.dart' as _i3;
import 'package:propet_mobile/services/pet_service.dart' as _i6;
import 'package:propet_mobile/services/user_service.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioConfiguration = _$DioConfiguration();
    gh.singleton<_i3.SecureStorageService>(_i3.SecureStorageService());
    await gh.singletonAsync<_i4.AuthService>(
      () {
        final i = _i4.AuthService(gh<_i3.SecureStorageService>());
        return i.loginFromSecureStorage().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i5.Dio>(dioConfiguration.dio(gh<_i4.AuthService>()));
    gh.factory<_i6.PetService>(() => _i6.PetService(gh<_i5.Dio>()));
    gh.factory<_i7.UserService>(() => _i7.UserService(gh<_i5.Dio>()));
    return this;
  }
}

class _$DioConfiguration extends _i8.DioConfiguration {}