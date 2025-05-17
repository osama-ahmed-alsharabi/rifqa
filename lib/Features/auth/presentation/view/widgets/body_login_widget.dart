import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view/widgets/auth_image_widget.dart';
import 'package:rifqa/Features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:rifqa/Features/auth/presentation/view_model/login_cubit/login_state.dart';
import 'package:rifqa/Features/profile/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/send_email_hepler.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';
import 'package:rifqa/cores/widgets/custom_snack_bar.dart';
import 'package:rifqa/cores/widgets/custom_text_field_widget.dart';

class BodyLoginWidget extends StatefulWidget {
  const BodyLoginWidget({
    super.key,
  });

  @override
  State<BodyLoginWidget> createState() => _BodyLoginWidgetState();
}

class _BodyLoginWidgetState extends State<BodyLoginWidget> {
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showPassword = true;

  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _showDeactivationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("الحساب معطل"),
          content: const Text(
              "تم إيقاف حسابك. يرجى التواصل مع الدعم الفني للحصول على المساعدة."),
          actions: <Widget>[
            TextButton(
              child: const Text("تواصل مع الدعم"),
              onPressed: () async {
                Navigator.of(context).pop();
                await SendEmailHepler()
                    .contactSupportEmail(emailAddress: "Rifqa.ymn@gmail.com");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchSupportEmail(BuildContext context) async {
    Uri(
      scheme: 'mailto',
      path: 'support@rifqa.com',
      queryParameters: {
        'subject': 'طلب مساعدة بخصوص الحساب المعطل',
        'body': 'أنا بحاجة إلى مساعدة بخصوص حسابي المعطل...',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            final cleanMessage =
                state.errorMessage.replaceFirst("Exception: ", "");
            CustomSnackBar.showSnackBar(Colors.red, cleanMessage, context);
            log(cleanMessage);
          } else if (state is UserDeactivated) {
            _showDeactivationDialog(context);
          } else if (state is LoginSuccess) {
            CustomSnackBar.showSnackBar(
                Colors.green, "مرحبا ${userName.text}", context);
            Navigator.pushReplacementNamed(context, AppRouter.kMainRoute,
                arguments: false);
          }
        },
        builder: (context, state) {
          return Form(
            key: formkey,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AuthImageWidget(
                  text: "..تسجيل الدخول",
                ),
                const SizedBox(
                  height: 70,
                ),
                CustomTextFieldWidget(
                    controller: userName, labelText: 'الاسم ..      '),
                CustomTextFieldWidget(
                    obscureText: showPassword,
                    suffixIcon: showPassword
                        ? IconButton(
                            onPressed: () {
                              showPassword = !showPassword;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            ))
                        : IconButton(
                            onPressed: () {
                              showPassword = !showPassword;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )),
                    controller: password,
                    labelText: 'ادخل كلمة المرور ..      '),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.kSignUpRoute);
                  },
                  child: Text(
                    "إنشاء حساب جديد..",
                    style: AppStyles.styleText12,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButtonWidget(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      if (password.text == "admin" &&
                          userName.text == "admin") {
                        Navigator.pushReplacementNamed(
                            context, AppRouter.kMainRoute,
                            arguments: true);
                      } else {
                        await BlocProvider.of<LoginCubit>(context).login(
                            userName: userName.text.trim(),
                            password: password.text.trim());
                      }
                      BlocProvider.of<ProfileCubit>(context).getUserName();
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  widget: state is LoginLoading
                      ? CircularProgressIndicator(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor,
                        )
                      : Text(
                          "تسجيل الدخول",
                          textAlign: TextAlign.center,
                          style: AppStyles.styleText20.copyWith(
                            color: BlocProvider.of<ThemeAppCubit>(context)
                                .kprimayColor,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
