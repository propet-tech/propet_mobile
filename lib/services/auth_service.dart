import 'package:openid_client/openid_client_io.dart';

class AuthService {



  void authenticate() async {
    var uri = Uri.http(
      "192.168.1.124:8080",
      "realms/propet",
    );

    var issuer = await Issuer.discover(uri);
    var client = Client(issuer, "propet-web");

    final username = 'nero@neropolis.breno.com';
    final password = '123';

    var flow = Flow.password(client);

    flow.loginWithPassword(username: username, password: password).then((value) => print(value.getUserInfo()));

    
  }
}
