import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view/widgets/auth_image_widget.dart';
import 'package:rifqa/Features/auth/presentation/view_model/signup_cubit/signup_cubit.dart';
import 'package:rifqa/Features/auth/presentation/view_model/signup_cubit/signup_state.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';
import 'package:rifqa/cores/widgets/custom_snack_bar.dart';
import 'package:rifqa/cores/widgets/custom_text_field_widget.dart';

class BodySignUpViewWidget extends StatefulWidget {
  const BodySignUpViewWidget({
    super.key,
  });

  @override
  State<BodySignUpViewWidget> createState() => _BodySignUpViewWidgetState();
}

class _BodySignUpViewWidgetState extends State<BodySignUpViewWidget> {
  GlobalKey<FormState> formkey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  final _cityController = TextEditingController();
  bool showPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _nationalityController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupError) {
            state.errorMessage.replaceFirst("Exception: ", "");
            CustomSnackBar.showSnackBar(
                Colors.red, state.errorMessage, context);
          } else if (state is SignupSuccess) {
            CustomSnackBar.showSnackBar(
                Colors.green, "تم إنشاء حساب بنجاح", context);
            Navigator.pop(context);
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
                  text: "إنشاء حساب",
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextFieldWidget(
                    controller: _nameController, labelText: 'الاسم ..      '),
                CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    labelText: 'العمر ..      '),
                CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: _nationalityController,
                    labelText: 'رقم البطاقة ..      '),
                CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    labelText: 'رقم الجوال1 ..      '),
                CustomTextFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: _secondaryPhoneController,
                    labelText: 'رقم الجوال2 ..      '),
                CustomTextFieldWidget(
                    controller: _cityController,
                    labelText: 'المحافظة ..      '),
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
                    controller: _passwordController,
                    labelText: 'كلمة السر ..      '),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "لدي حساب بالفعل",
                    style: AppStyles.styleText12,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButtonWidget(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      await BlocProvider.of<SignupCubit>(context).signupCubit(
                          name: _nameController.text.trim(),
                          password: _passwordController.text.trim(),
                          age: int.parse(_ageController.text.trim()),
                          nationality: _nationalityController.text.trim(),
                          phoneNumber: _phoneController.text.trim(),
                          secondaryPhoneNumber:
                              _secondaryPhoneController.text.trim(),
                          city: _cityController.text.trim());
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  widget: state is SignupLoading
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
