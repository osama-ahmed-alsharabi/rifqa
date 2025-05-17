import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/view_model/adding_category_item_data_cubit/adding_category_item_data_cubit.dart';
import 'package:rifqa/Features/admin/presentation/widgets/adding_image_to_database.dart';
import 'package:rifqa/Features/home/data/model/category_model.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/widgets/custom_button_widget.dart';
import 'package:rifqa/cores/widgets/custom_snack_bar.dart';
import 'package:rifqa/cores/widgets/custom_text_field_widget.dart';

class BodyAddingViewItemWidget extends StatefulWidget {
  final CategoryModel categoryModel;
  const BodyAddingViewItemWidget({super.key, required this.categoryModel});

  @override
  State<BodyAddingViewItemWidget> createState() =>
      _BodyAddingViewItemWidgetState();
}

class _BodyAddingViewItemWidgetState extends State<BodyAddingViewItemWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController activityInputController = TextEditingController();
  List<String> activitiesList = [];
  File? image;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<AddingCategoryItemDataCubit,
          AddingCategoryItemDataState>(
        listener: (context, state) async {
          if (state is AddingCategoryItemDataFailure) {
            CustomSnackBar.showSnackBar(
                Colors.red, "حدث خظاء \n تأكد من الاتصال بالانترنت", context);
          }

          if (state is AddingCategoryItemDataScessus) {
            await BlocProvider.of<FetchCategoryDataCubit>(context).fetch();
            nameController.clear();
            descriptionController.clear();
            activitiesList.clear();
            image = null;
            setState(() {});
            CustomSnackBar.showSnackBar(
              Colors.green,
              "تمت الإضافة",
              context,
            );
            Navigator.pushNamed(context, AppRouter.kMainRoute, arguments: true);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                const CustomAppBarWidget(
                  title: "إضافة",
                ),
                GestureDetector(
                    onTap: () async {
                      image = await CategoryService().pickImageFromGallery();
                      setState(() {});
                    },
                    child: AddinImageToDatabase(
                      image: image,
                    )),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFieldWidget(
                    controller: nameController, labelText: "إضافة اسم منطقة"),
                CustomTextFieldWidget(
                    controller: descriptionController,
                    maxLines: 3,
                    labelText: "إضافة وصف"),
                CustomTextFieldWidget(
                  noVaidate: activitiesList.isEmpty ? false : true,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        activitiesList.add(activityInputController.text.trim());
                        activityInputController.clear();
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  controller: activityInputController,
                  hintText: "ثم قم بالنقر علئ اضافة    👈🏻",
                  labelText: "قم بإضافة نشاطات",
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
                const SizedBox(
                  height: 20,
                ),
                CustomButtonWidget(
                    onTap: () async {
                      String imageUrl = "";
                      if (formKey.currentState!.validate()) {
                        if (image == null) {
                          CustomSnackBar.showSnackBar(
                              Colors.red, "الرجاء إضافة صورة", context);
                          return;
                        }
                        try {
                          imageUrl =
                              await CategoryService().uploadImage(image!);
                        } catch (e) {
                          CustomSnackBar.showSnackBar(Colors.red,
                              "حدث خظاء \n تأكد من الاتصال بالانترنت", context);
                        }
                        await BlocProvider.of<AddingCategoryItemDataCubit>(
                                context)
                            .addingCategory(
                          name: nameController.text.trim(),
                          description: nameController.text.trim(),
                          type: widget.categoryModel.title,
                          imageUrl: imageUrl,
                          activities: activitiesList,
                        );
                      } else {
                        autovalidateMode = AutovalidateMode.always;
                      }
                    },
                    widget: state is AddingCategoryItemDataLoading
                        ? CircularProgressIndicator(
                            color: BlocProvider.of<ThemeAppCubit>(context)
                                .kprimayColor,
                          )
                        : Text(
                            "إضافة",
                            textAlign: TextAlign.center,
                            style: AppStyles.styleText20.copyWith(
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            ),
                          )),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
