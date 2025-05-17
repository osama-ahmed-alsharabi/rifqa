import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';

part 'adding_category_item_data_state.dart';

class AddingCategoryItemDataCubit extends Cubit<AddingCategoryItemDataState> {
  AddingCategoryItemDataCubit() : super(AddingCategoryItemDataInitial());

  Future<void> addingCategory({
    required String name,
    required String description,
    required String type,
    required String imageUrl,
    required List<String> activities,
  }) async {
    try {
      emit(AddingCategoryItemDataLoading());
      Future.delayed(const Duration(seconds: 3), () async {
        try {
          await CategoryService().createCategory(CategoryItemModel(
              id: null,
              name: name,
              description: description,
              type: type,
              imageUrl: imageUrl, 
              activities: activities,
              createdAt: DateTime.timestamp(),
              updatedAt: DateTime.timestamp()));
          emit(AddingCategoryItemDataScessus());
        } catch (e) {
          emit(
            AddingCategoryItemDataFailure(
              errorMessage: e.toString(),
            ),
          );
        }
      });
    } catch (e) {
      emit(
        AddingCategoryItemDataFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
