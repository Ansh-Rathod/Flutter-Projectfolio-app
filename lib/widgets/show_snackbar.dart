import 'package:flutter/material.dart';

showSnackBarToPage(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(18),
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: color,
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
