import 'package:flutter/material.dart';

class NotificationBar extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  const NotificationBar(
      {super.key, required this.message, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(width: 16),
        Text(message),
      ],
    );
  }

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: NotificationBar(
            icon: Icons.done,
            message: message,
          ),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: NotificationBar(
            icon: Icons.error_outline,
            message: message,
          ),
        ),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.yellow,
        content: DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: NotificationBar(
            iconColor: Colors.black,
            icon: Icons.warning_outlined,
            message: message,
          ),
        ),
      ),
    );
  }
}
