import 'package:oauth2/oauth2.dart' as oauth2;

class AuthService {
  Future<String> authenticate() async {
    final authorizationEndpoint =
        Uri.parse('http://192.168.1.124:8080/realms/propet/protocol/openid-connect/token');

    final username = 'nero';
    final password = '123';

    final identifier = 'propet-web';
    final secret = 'my client secret';

    var client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint, username, password,
        identifier: identifier, secret: secret);

    return client.credentials.toJson();
  }
}
