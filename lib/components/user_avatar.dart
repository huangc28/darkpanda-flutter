import 'package:flutter/material.dart';

const radius = 28.0;

Widget UserAvatar(String url) => CircleAvatar(
      radius: radius,
      backgroundImage: url == ""
          ? NetworkImage(
              'https://flutter-examples.com/wp-content/uploads/2019/09/blossom.jpg')
          : NetworkImage(url),
      backgroundColor: Colors.brown.shade800,
    );
