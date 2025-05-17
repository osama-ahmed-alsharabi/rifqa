abstract class EditingCategoryItemState {}

class EditingCategoryItemInitial extends EditingCategoryItemState {}

class EditingCategoryItemLoading extends EditingCategoryItemState {}

class EditingCategoryItemSuccess extends EditingCategoryItemState {}

class EditingCategoryItemFailure extends EditingCategoryItemState {
  final String error;
  EditingCategoryItemFailure(this.error);
}
