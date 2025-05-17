import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItemWidget({
    super.key,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset(categoryModel.image).image, fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white,
          style: BorderStyle.solid,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.3,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                categoryModel.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.styleText12.copyWith(
                    color:
                        BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
