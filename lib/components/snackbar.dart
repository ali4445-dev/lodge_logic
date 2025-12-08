import 'package:flutter/material.dart';

enum SnackbarType { success, error, confirmation, info }

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required SnackbarType type,
}) {
  // Define colors and icons for each type
  Color backgroundColor;
  IconData iconData;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green.shade600;
      iconData = Icons.check_circle_outline;
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red.shade600;
      iconData = Icons.error_outline;
      break;
    case SnackbarType.confirmation:
      backgroundColor = Colors.orange.shade600;
      iconData = Icons.help_outline;
      break;
    case SnackbarType.info:
      backgroundColor = Colors.blue.shade600;
      iconData = Icons.info_outline;
      break;
  }

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating, // makes it floating and more modern
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: Row(
      children: [
        Icon(
          iconData,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
