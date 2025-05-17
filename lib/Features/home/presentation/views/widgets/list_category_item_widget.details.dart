import 'package:flutter/material.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/category_item_widget_details.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class ListCategoryItemWidgetDetails extends StatelessWidget {
  final bool admin;
  final CategoryModel categoryModel;
  const ListCategoryItemWidgetDetails({
    super.key,
    this.admin = false,
    required this.categoryModel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: categoryModel.items.isEmpty
            ? Center(
                child: Text(
                  "لايوجد بيانات بعد",
                  style: AppStyles.styleText24,
                ),
              )
            : categoryModel.title != categoryModel.items.first.type
                ? Center(
                    child: Text(
                      "لايوجد بيانات بعد",
                      style: AppStyles.styleText24,
                    ),
                  )
                : ListView.builder(
                    itemCount: categoryModel.items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              admin
                                  ? AppRouter.kEditingViewItemRoute
                                  : AppRouter.kDetailsRoute,
                              arguments: categoryModel.items[index]);
                        },
                        child: CategoryItemWidgetDetails(
                          admin: admin,
                          item: categoryModel.items[index],
                        ),
                      );
                    },
                  ));
  }
}
