import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/edit_category_item/edit_category_item_cubit.dart';
import 'package:rifqa/Features/admin/presentation/view_model/edit_category_item/edit_category_item_state.dart';
import 'package:rifqa/Features/admin/presentation/widgets/adding_image_to_database.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';
import 'package:rifqa/cores/widgets/custom_snack_bar.dart';
import 'package:rifqa/cores/widgets/custom_text_field_widget.dart';

class BodyEditingViewWidget extends StatefulWidget {
  final CategoryItemModel categoryItemModel;
  const BodyEditingViewWidget({
    super.key,
    required this.categoryItemModel,
  });

  @override
  State<BodyEditingViewWidget> createState() => _BodyEditingViewWidgetState();
}

class _BodyEditingViewWidgetState extends State<BodyEditingViewWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController activityInputController;
  late List<String> activitiesList;
  File? image;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.categoryItemModel.name);
    descriptionController =
        TextEditingController(text: widget.categoryItemModel.description);
    activityInputController = TextEditingController();
    activitiesList = List.from(widget.categoryItemModel.activities);
    currentImageUrl = widget.categoryItemModel.imageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    activityInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<EditingCategoryItemCubit, EditingCategoryItemState>(
        listener: (context, state) async {
          if (state is EditingCategoryItemFailure) {
            CustomSnackBar.showSnackBar(
                Colors.red, "حدث خطأ \n تأكد من الاتصال بالانترنت", context);
          }

          if (state is EditingCategoryItemSuccess) {
            await BlocProvider.of<FetchCategoryDataCubit>(context).fetch();
            CustomSnackBar.showSnackBar(
              Colors.green,
              "تم التعديل بنجاح",
              context,
            );
            Navigator.pushReplacementNamed(context, AppRouter.kMainRoute,
                arguments: true);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                const CustomAppBarWidget(
                  title: "تعديل",
                ),
                GestureDetector(
                  onTap: () async {
                    image = await CategoryService().pickImageFromGallery();
                    setState(() {});
                  },
                  child: AddinImageToDatabase(
                    image: image,
                    imageUrl: currentImageUrl,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFieldWidget(
                  controller: nameController,
                  labelText: "اسم المنطقة",
                ),
                CustomTextFieldWidget(
                  controller: descriptionController,
                  maxLines: 3,
                  labelText: "الوصف",
                ),
                CustomTextFieldWidget(
                  noVaidate: activitiesList.isEmpty ? false : true,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (activityInputController.text.trim().isNotEmpty) {
                        setState(() {
                          activitiesList
                              .add(activityInputController.text.trim());
                          activityInputController.clear();
                        });
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  controller: activityInputController,
                  labelText: "أدخل النشاط واضغط Enter",
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: activitiesList
                      .map((activity) => Chip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.white,
                            label: Text(
                              activity,
                              style: AppStyles.styleText20,
                            ),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                activitiesList.remove(activity);
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                CustomButtonWidget(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await BlocProvider.of<EditingCategoryItemCubit>(context)
                          .updateCategoryItem(
                        categoryItem: widget.categoryItemModel,
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        activities: activitiesList,
                        newImage: image,
                      );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  widget: state is EditingCategoryItemLoading
                      ? CircularProgressIndicator(
                          color: BlocProvider.of<ThemeAppCubit>(context)
                              .kprimayColor,
                        )
                      : Text(
                          "حفظ التعديلات",
                          textAlign: TextAlign.center,
                          style: AppStyles.styleText20.copyWith(
                            color: BlocProvider.of<ThemeAppCubit>(context)
                                .kprimayColor,
                          ),
                        ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
