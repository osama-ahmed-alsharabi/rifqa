sealed class LoginState {}

class UserDeactivated extends LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginShowPassword extends LoginState {}

final class LoginDoNotShowPassword extends LoginState {}

final class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure({required this.errorMessage});
}
