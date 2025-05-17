import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/intro/presentation/widgets/image_intro_widget.dart';
import 'package:rifqa/Features/intro/presentation/widgets/intro_text_widget.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';

class BodyIntroViewWidget extends StatelessWidget {
  const BodyIntroViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ImageIntroWidget(),
          const Divider(color: Colors.white, thickness: 10),
          const SizedBox(height: 50),
          Text(
            'مرحبًا بك في تطبيق رفيقه! ',
            style: AppStyles.styleText20,
          ),
          const Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                IntroTextWidget(
                    text: "أهــلاً وسهــلاً بــك فـي دلــيلك السياحي المفضل،"),
                IntroTextWidget(
                    text: "الـذي صُمم خصيصًــا ليصبح رفيقـك الدائم  في كل"),
                IntroTextWidget(
                    text: "رحـلاتك واستكشــافاتك. سواء كنت تبحث  عن معالم"),
                IntroTextWidget(
                    text: " سيـاحية خلابة، مطاعم لذيذة،  أو حتى تجارب فريدة،"),
                IntroTextWidget(
                    text:
                        "“رفيقــه” سيكــــون دليلــك الأمثل لتجربة لا تُنسى."),
              ],
            ),
          ),
          CustomButtonWidget(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRouter.kLoginRoute);
            },
            widget: Text(
              "تسجيل الدخول",
              textAlign: TextAlign.center,
              style: AppStyles.styleText20.copyWith(
                color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
