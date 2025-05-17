import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  String? name;
  Future<String?> getUserName() async {
    String? name = await SharedPreferencesService.getUserName();
    emit(GetUserName());
    return name;
  }

  Future<String?> getUserPhone() async {
    String? phone = await SharedPreferencesService.getUserPhone();
    emit(GetUserPhone());
    return phone;
  }
}
