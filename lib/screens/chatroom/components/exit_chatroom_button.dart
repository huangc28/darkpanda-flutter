import 'package:flutter/material.dart';

class ExitChatroomButton extends StatelessWidget {
  const ExitChatroomButton({
    this.onExit,
  });

  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.logout_outlined,
        color: Colors.white,
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: onExit,
    );
  }
}
