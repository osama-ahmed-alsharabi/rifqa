import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/adding_category_item_data_cubit/adding_category_item_data_cubit.dart';
import 'package:rifqa/Features/admin/presentation/widgets/body_adding_view_item_widget.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';

class AddingViewItem extends StatelessWidget {
  const AddingViewItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CategoryModel? categoryModel =
        ModalRoute.of(context)?.settings.arguments as CategoryModel;
    log(categoryModel.title);
    return SafeArea(
      child: BlocProvider(
        create: (context) => AddingCategoryItemDataCubit(),
        child: Scaffold(
          body: BodyAddingViewItemWidget(
            categoryModel: categoryModel,
          ),
        ),
      ),
    );
  }
}
