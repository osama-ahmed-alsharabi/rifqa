import 'package:flutter/material.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/body_details_view.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryItemModel categoryItemModel =
        ModalRoute.of(context)!.settings.arguments as CategoryItemModel;
    return SafeArea(
      child: Scaffold(
        body: BodyDetailsView(
          categoryItemModel: categoryItemModel,
        ),
      ),
    );
  }
}
