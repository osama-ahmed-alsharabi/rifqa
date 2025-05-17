import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/services/supabase_service.dart';
import 'package:rifqa/cores/services/user_service.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final supabaseClient = SupabaseService();
    final userService = UserService(supabaseClient.client);

    return RepositoryProvider.value(
      value: userService,
      child: RepositoryProvider.value(
        value: supabaseClient,
        child: child,
      ),
    );
  }
}
