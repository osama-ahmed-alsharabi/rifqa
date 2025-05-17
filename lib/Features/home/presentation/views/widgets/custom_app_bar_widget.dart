import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class CustomAppBarWidget extends StatelessWidget {
  final bool admin;
  final String title;
  final CategoryModel? categoryModel;
  final Color? color;
  const CustomAppBarWidget(
      {super.key,
      this.admin = false,
      this.title = "Rifqa",
      this.categoryModel,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        admin
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.kAddingViewItemRoute,
                        arguments: categoryModel);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green,
                          ),
                          child: const Icon(FontAwesomeIcons.plus)),
                    ),
                  ),
                ),
              )
            : Flexible(
                child: Image.asset(
                  ImageConst.kIconLogo,
                  width: 100,
                  color: color,
                ),
              ),
        FittedBox(
            child: Text(title,
                style: AppStyles.styleText24
                    .copyWith(fontSize: 36, color: color))),
        Flexible(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              ImageConst.kIconArrow,
              width: 100,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
