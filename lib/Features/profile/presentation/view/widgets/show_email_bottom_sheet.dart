import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class ShowEmailBottomSheet {
  void showEmailBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "الخصوصية والامان",
                      style: AppStyles.styleText20.copyWith(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Icon(
                        Icons.privacy_tip,
                        color: BlocProvider.of<ThemeAppCubit>(context)
                            .kprimayColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
                thickness: 2,
              ),
              const SizedBox(height: 20),
              Text(
                textAlign: TextAlign.right,
                "نحن ملتزمون بحماية خصوصيتك وضمان أمان معلوماتك الشخصية. يتم تشفير جميع البيانات التي تقدمها وتخزينها بشكل آمن. لا نقوم بمشاركة معلوماتك مع أي طرف ثالث دون موافقتك الصريحة. ثقتك بنا أمر بالغ الأهمية، ولهذا نقوم بتحديث ممارسات الأمان لدينا باستمرار لضمان حماية بياناتك. باستخدامك لهذا التطبيق، فإنك توافق على سياسة الخصوصية وشروط الاستخدام الخاصة بنا.",
                style: AppStyles.styleText16.copyWith(
                    color:
                        BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
