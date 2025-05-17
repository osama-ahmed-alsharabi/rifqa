import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view/widgets/body_login_widget.dart';
import 'package:rifqa/Features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:rifqa/cores/services/supabase_service.dart';
import 'package:rifqa/cores/services/user_service.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => LoginCubit(
            userService: RepositoryProvider.of<UserService>(context),
            supabaseService: RepositoryProvider.of<SupabaseService>(context),
          ),
          child: const BodyLoginWidget(),
        ),
      ),
    );
  }
}
