import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/views/add_category_item_view.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/data/model/category_model_data.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/category_items_view.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/catergory_item_widget.dart';

class GridListWidget extends StatefulWidget {
  final bool admin;
  const GridListWidget({super.key, this.admin = false});

  @override
  State<GridListWidget> createState() => _GridListWidgetState();
}

class _GridListWidgetState extends State<GridListWidget> {
  List<CategoryModel>? categories;
  @override
  void initState() {
    categories = BlocProvider.of<FetchCategoryDataCubit>(context).categoryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchCategoryDataCubit, FetchCategoryDataState>(
        listener: (context, state) {
      if (state is FetchCategoryDataSuccess) {}
    }, builder: (context, state) {
      return state is FetchCategoryDataSuccess
          ? SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverGrid.builder(
                itemCount: CategoryModelData.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => widget.admin
                                    ? AddCategoryItemView(
                                        categoryModel: categories![index],
                                      )
                                    : CategoryItemsView(
                                        categoryModel: categories![index],
                                      )));
                      },
                      child: CategoryItemWidget(
                        categoryModel: categories![index],
                      ));
                },
              ),
            )
          : state is FetchCategoryDataLoading
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : state is FetchCategoryDataLoading
                  ? const SliverToBoxAdapter(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const SliverToBoxAdapter(
                      child: Text("لايوجد اتصال بالانترنت"));
    });
  }
}
