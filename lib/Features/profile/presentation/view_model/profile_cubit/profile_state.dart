part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class GetUserName extends ProfileState {}

final class GetUserPhone extends ProfileState {}
