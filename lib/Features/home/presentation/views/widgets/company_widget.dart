import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                child: Text(
                  "شـــركــة الغــذيفــي للصـــــــرافة",
                  style: AppStyles.styleText24.copyWith(
                    fontSize: 28,
                    color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
                  ),
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(
                ImageConst.kCompanyIcon,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
