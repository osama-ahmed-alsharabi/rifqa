part of 'adding_category_item_data_cubit.dart';

@immutable
sealed class AddingCategoryItemDataState {}

final class AddingCategoryItemDataInitial extends AddingCategoryItemDataState {}

final class AddingCategoryItemDataLoading extends AddingCategoryItemDataState {}

final class AddingCategoryItemDataScessus extends AddingCategoryItemDataState {}

final class AddingCategoryItemDataFailure extends AddingCategoryItemDataState {
  final String errorMessage;

  AddingCategoryItemDataFailure({required this.errorMessage});
}
