import 'package:flutter/material.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class IntroTextWidget extends StatelessWidget {
  final String text;
  const IntroTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: FittedBox(
        child: Text(
          text,
          style: AppStyles.styleText12,
        ),
      ),
    );
  }
}
