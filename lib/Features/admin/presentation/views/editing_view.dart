import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/edit_category_item/edit_category_item_cubit.dart';
import 'package:rifqa/Features/admin/presentation/widgets/body_editing_view_widget.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';

class EditingView extends StatelessWidget {
  const EditingView({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryItemModel categoryItemModel =
        ModalRoute.of(context)!.settings.arguments as CategoryItemModel;
    return SafeArea(
      child: BlocProvider(
        create: (context) => EditingCategoryItemCubit(),
        child: Scaffold(
          body: BodyEditingViewWidget(
            categoryItemModel: categoryItemModel,
          ),
        ),
      ),
    );
  }
}
