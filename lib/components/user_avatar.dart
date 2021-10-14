import 'package:flutter/material.dart';

// const radius = 28.0;

Widget UserAvatar(String url, {double radius = 28.0}) => CircleAvatar(
      radius: radius,
      backgroundImage: url == "" || url == null
          ? AssetImage('assets/default_avatar.png')
          : NetworkImage(url),
      backgroundColor: Colors.transparent,
    );
