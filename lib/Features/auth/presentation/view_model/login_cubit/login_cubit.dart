import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view_model/login_cubit/login_state.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/services/supabase_service.dart';
import 'package:rifqa/cores/services/user_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserService _userService;
  final SupabaseService _supabaseService;

  LoginCubit({
    required UserService userService,
    required SupabaseService supabaseService,
  })  : _userService = userService,
        _supabaseService = supabaseService,
        super(LoginInitial());

  Future<void> login({
    required String userName,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      // First sign in
      final user = await SupabaseService().signInWithName(
        name: userName,
        password: password,
      );
      final String? userId = await SharedPreferencesService.getUserId();

      final isActive = await _userService.checkUserActive(userId!);
      if (!isActive) {
        await SupabaseService().signOut();
        emit(UserDeactivated());
        return;
      }

      await SharedPreferencesService.saveUserName(userName);
      emit(LoginSuccess());
    } catch (error) {
      emit(LoginFailure(errorMessage: error.toString()));
    }
  }
}
