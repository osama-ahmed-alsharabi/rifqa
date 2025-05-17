import 'package:flutter/material.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class AuthImageWidget extends StatelessWidget {
  final String text;
  const AuthImageWidget({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Image.asset(
                ImageConst.kLogo,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              textAlign: TextAlign.center,
              text,
              style: AppStyles.styleText24,
            ),
          ),
        ],
      ),
    );
  }
}
