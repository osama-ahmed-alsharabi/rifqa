abstract final class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupError extends SignupState {
  final String errorMessage;
  SignupError(this.errorMessage);
}

final class SignupSuccess extends SignupState {}
