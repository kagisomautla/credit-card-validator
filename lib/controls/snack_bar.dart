import 'package:credit_card_validator/controls/text.dart';
import 'package:flutter/material.dart';

void snackBarControl({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blue,
      content: TextControl(
        text: message,
        color: Colors.white,
      ),
    ),
  );
}
