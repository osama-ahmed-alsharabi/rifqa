import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/edit_category_item/edit_category_item_state.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';

class EditingCategoryItemCubit extends Cubit<EditingCategoryItemState> {
  EditingCategoryItemCubit() : super(EditingCategoryItemInitial());

  Future<void> updateCategoryItem({
    required CategoryItemModel categoryItem,
    required String name,
    required String description,
    required List<String> activities,
    File? newImage,
  }) async {
    emit(EditingCategoryItemLoading());
    try {
      String imageUrl = categoryItem.imageUrl;

      if (newImage != null) {
        imageUrl = await CategoryService().uploadImage(newImage);
      }
      CategoryItemModel newCategory = CategoryItemModel(
          id: categoryItem.id,
          name: name,
          description: description,
          type: categoryItem.type,
          imageUrl: imageUrl,
          activities: activities,
          createdAt: categoryItem.createdAt,
          updatedAt: DateTime.timestamp());
      await CategoryService().updateCategory(newCategory);

      emit(EditingCategoryItemSuccess());
    } catch (e) {
      emit(EditingCategoryItemFailure(e.toString()));
    }
  }
}
