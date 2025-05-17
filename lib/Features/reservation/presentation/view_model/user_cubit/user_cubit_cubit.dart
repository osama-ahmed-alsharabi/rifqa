import 'package:bloc/bloc.dart';
import 'package:rifqa/Features/reservation/data/models/user.dart';
import 'package:rifqa/Features/reservation/data/repo/user_repository.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/user_cubit/user_cubit_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository repo;

  UserCubit({required this.repo}) : super(UserInitial());

  Future<void> login(String name, String password) async {
    emit(UserLoading());
    try {
      final user = await repo.verifyUser(name, password);
      if (user != null) {
        await repo.saveUserLocally(user);
        emit(UserLoaded(user));
      } else {
        emit(const UserError('Invalid credentials'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> register(String name, String password) async {
    emit(UserLoading());
    try {
      final user = UserApp(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        password: password,
      );
      await repo.registerUser(user);
      await repo.saveUserLocally(user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> loadCurrentUser() async {
    emit(UserLoading());
    try {
      final user = await repo.getLocalUser();
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserInitial());
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> logout() async {
    await repo.clearLocalUser();
    emit(UserInitial());
  }
}
