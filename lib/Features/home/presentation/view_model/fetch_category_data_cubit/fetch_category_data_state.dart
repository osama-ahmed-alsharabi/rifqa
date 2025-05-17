part of 'fetch_category_data_cubit.dart';

@immutable
sealed class FetchCategoryDataState {}

final class FetchCategoryDataInitial extends FetchCategoryDataState {}

final class FetchCategoryDataLoading extends FetchCategoryDataState {}

final class FetchCategoryDataSuccess extends FetchCategoryDataState {
   final List<CategoryModel> categoryItemModel;

  FetchCategoryDataSuccess({required this.categoryItemModel});
}

final class FetchCategoryDataFailure extends FetchCategoryDataState {
  final String errorMessage;

  FetchCategoryDataFailure({required this.errorMessage});

}
