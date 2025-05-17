import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/auth/presentation/view_model/signup_cubit/signup_state.dart';
import 'package:rifqa/cores/services/supabase_service.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signupCubit(
      {required String name,
      required String password,
      required int age,
      required String nationality,
      required String phoneNumber,
      required String secondaryPhoneNumber,
      required String city}) async {
    {
      try {
        emit(SignupLoading());
        await SupabaseService().signUp(
          name: name,
          password: password,
          age: age,
          nationality: nationality,
          phoneNumber: phoneNumber,
          secondaryPhoneNumber: secondaryPhoneNumber,
          city: city,
        );
        emit(SignupSuccess());

      } catch (error) {
        emit(SignupError(error.toString()));
      }
    }
  }
}
