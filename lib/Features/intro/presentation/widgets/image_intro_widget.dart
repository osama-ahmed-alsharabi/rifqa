import 'package:flutter/material.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class ImageIntroWidget extends StatelessWidget {
  const ImageIntroWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImageConst.kIntro,
          fit: BoxFit.fill,
        ),
        Image.asset(ImageConst.kLogo),
      ],
    );
  }
}
