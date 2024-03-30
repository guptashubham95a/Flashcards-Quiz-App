import 'package:flutter/material.dart';

void showCustomSnackBar({
  required String content,
  required BuildContext context,
  Color? backgroundColor = Colors.lightGreen,
}) {
  ScaffoldMessenger.of(context)
      .removeCurrentSnackBar(); // Remove existing snackbars

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: backgroundColor, // Set background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Set border radius
      ),
    ),
  );
}
