import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/user_management/user_management_cubit.dart';
import 'package:rifqa/Features/admin/presentation/widgets/body_user_view_widget.dart';
import 'package:rifqa/cores/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManageView extends StatelessWidget {
  const UserManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) =>
            UserManagementCubit(UserService(Supabase.instance.client)),
        child: const Scaffold(
          body: UserDetailsListWidget(),
        ),
      ),
    );
  }
}
