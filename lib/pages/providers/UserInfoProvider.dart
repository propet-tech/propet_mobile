import 'package:flutter/material.dart';
import 'package:propet_mobile/core/dependencies.dart';
import 'package:propet_mobile/models/userinfo.dart';
import 'package:propet_mobile/services/user_service.dart';

class UserInfoProvider with ChangeNotifier {

  late UserInfo userInfo;

  Future<void> init() async {
    userInfo = await getIt<UserService>().getUserInfo();
  }
}
