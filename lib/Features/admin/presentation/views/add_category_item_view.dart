import 'package:flutter/material.dart';
import 'package:rifqa/Features/admin/presentation/widgets/body_add_category_item_view_widget.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';

class AddCategoryItemView extends StatelessWidget {
  final CategoryModel categoryModel;
  const AddCategoryItemView({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BodyAddCategoryItemsViewWidget(
        categoryModel: categoryModel,
      ),
    ));
  }
}
