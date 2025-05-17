import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/google_map/presentation/views/map_home_view.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/custom_app_bar_widget.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class BodyDetailsView extends StatelessWidget {
  final CategoryItemModel categoryItemModel;
  const BodyDetailsView({
    super.key,
    required this.categoryItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomAppBarWidget(
            admin: false,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: AspectRatio(
                aspectRatio: 4 / 4,
                child: Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white, width: 3),
                      image: DecorationImage(
                          image:
                              Image.network(categoryItemModel.imageUrl).image,
                          fit: BoxFit.fill),
                    ),
                    child: const SizedBox()),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapHomeView(
                            withPlace: categoryItemModel.name,
                          )));
            },
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MapHomeView(withPlace: categoryItemModel.name)));
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "الفنادق",
                    style: TextStyle(
                        color: BlocProvider.of<ThemeAppCubit>(context)
                            .kprimayColor),
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          DetailsWidget(
            title: "الانشطة",
            activities: categoryItemModel.activities,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final String title;
  final String? categoryItemModeltext;
  final List<String>? activities;
  const DetailsWidget({
    super.key,
    this.categoryItemModeltext,
    required this.title,
    this.activities,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              title,
              style: AppStyles.styleText16,
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: activities == null
                    ? [Text(categoryItemModeltext ?? "no data")]
                    : activities!.map((element) => Text(element)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
