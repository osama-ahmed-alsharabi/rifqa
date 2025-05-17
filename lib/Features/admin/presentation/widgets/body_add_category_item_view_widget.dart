import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/list_category_item_widget.details.dart';

class BodyAddCategoryItemsViewWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const BodyAddCategoryItemsViewWidget({
    super.key,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppBarWidget(
          admin: true,
          categoryModel: categoryModel,
        ),
        ListCategoryItemWidgetDetails(
          admin: true,
          categoryModel: categoryModel,
        ),
      ],
    );
  }
}
