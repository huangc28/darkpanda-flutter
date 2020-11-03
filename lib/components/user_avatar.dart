import 'package:flutter/material.dart';

const radius = 28.0;

Widget UserAvatar(String url) => CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
      backgroundColor: Colors.brown.shade800,
    );
