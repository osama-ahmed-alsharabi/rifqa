import 'package:flutter/material.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class CustomSnackBar {
  static void showSnackBar(Color color, String message, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.all(15),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(
            textAlign: TextAlign.right,
            message,
            style: AppStyles.styleText16.copyWith(color: Colors.white),
          ),
        ),
      );
}
