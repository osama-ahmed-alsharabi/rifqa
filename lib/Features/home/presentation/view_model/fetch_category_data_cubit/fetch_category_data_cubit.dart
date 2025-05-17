import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/data/model/category_model_data.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';

part 'fetch_category_data_state.dart';

class FetchCategoryDataCubit extends Cubit<FetchCategoryDataState> {
  FetchCategoryDataCubit() : super(FetchCategoryDataInitial());
  List<CategoryItemModel>? categoryItem;
  List<CategoryModel>? categoryModel;
  Future<void> fetch() async {
    emit(FetchCategoryDataLoading());
    categoryItem?.clear();
    categoryModel?.forEach((elemet){
      elemet.items.clear();
    });
    categoryModel = CategoryModelData.categories;
    try {
      categoryItem = await CategoryService().getAllCategories();
      for (var element in categoryItem!) {
        for (var element2 in categoryModel!) {
          if (element2.title == element.type) {
            element2.items.add(element);
          }
        }
      }
      emit(FetchCategoryDataSuccess(categoryItemModel: categoryModel!));
    } catch (e) {
      emit(FetchCategoryDataFailure(errorMessage: e.toString()));
    }
  }
}
