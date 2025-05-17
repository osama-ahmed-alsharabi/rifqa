import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view/widgets/body_signup_view_widget.dart';
import 'package:rifqa/Features/auth/presentation/view_model/signup_cubit/signup_cubit.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => SignupCubit(),
          child: const BodySignUpViewWidget(),
        ),
      ),
    );
  }
}
