import 'package:flutter/material.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/body_category_item_view_widget.dart';

class CategoryItemsView extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItemsView({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      body: BodyCategoryItemsViewWidget(
        categoryModel: categoryModel,
      ),
    ));
  }
}