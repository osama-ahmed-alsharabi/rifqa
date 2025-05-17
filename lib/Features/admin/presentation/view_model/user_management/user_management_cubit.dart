// features/admin/presentation/view_model/user_management_cubit/user_management_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/data/model/user_model.dart';
import 'package:rifqa/cores/services/user_service.dart';

part 'user_management_state.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserService _userService;

  UserManagementCubit(this._userService) : super(UserManagementInitial());

  Future<void> fetchUsers() async {
    emit(UserManagementLoading());
    try {
      final users = await _userService.getUsers();
      emit(UserManagementLoaded(users));
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }

  Future<void> searchUsers(String query) async {
    emit(UserManagementLoading());
    try {
      final users = await _userService.searchUsers(query);
      emit(UserManagementLoaded(users));
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      await _userService.toggleUserStatus(userId, isActive);
      await fetchUsers();
    } catch (e) {
      emit(UserManagementError(e.toString()));
    }
  }
}
