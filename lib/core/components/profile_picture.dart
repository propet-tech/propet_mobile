import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:propet_mobile/models/userinfo.dart';

class ProfilePicture extends StatelessWidget {
  final UserInfo userInfo;

  const ProfilePicture({super.key, required this.userInfo});

  String nameAbbreviation(String name) {
    String result = "";
    var words = name.split(" ");
    var maxWords = words.length >= 2 ? 2 : 1;

    for (int i = 0; i < maxWords; i++) {
      result += words[i][0].toUpperCase();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, limits) {
        if (userInfo.picture != null) {
          return CircleAvatar(
            backgroundImage: ExtendedNetworkImageProvider(
              userInfo.picture!,
              cache: true,
            ),
            radius: min(limits.maxHeight / 2, limits.maxWidth / 2),
          );
        }

        return CircleAvatar(
          radius: min(limits.maxHeight / 2, limits.maxWidth / 2),
          child: Text(
            nameAbbreviation(userInfo.name),
            style: TextStyle(
              fontSize: min(limits.maxHeight / 2, limits.maxWidth / 2),
            ),
          ),
        );
      },
    );
  }
}
