import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:propet_mobile/environment.dart';
import 'package:propet_mobile/models/userinfo.dart';

@Injectable()
class UserService {
  final Dio http;
  // Url exclusiva do keycloak, uma forma mais inteligencia seria usar o endpoint
  //'.well-known/openid-configuration' para descobrir a url do endpoint
  final String oidcUserInfoUrl =
      "${AppEnvironment.issuerUrl}/protocol/openid-connect/userinfo";

  UserService(this.http);

  Future<UserInfo> getUserInfo() async {
    var result = await http.get(oidcUserInfoUrl);
    var user = UserInfo.fromJson(result.data);
    return user;
  }
}
