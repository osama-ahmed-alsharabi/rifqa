import 'package:rifqa/Features/home/data/model/category_model.dart';

abstract class CategoryModelData {
  static List<CategoryModel> categories = [
    CategoryModel(
      title: "بحــــار",
      image: "assets/images/sea.png",
      items: [],
    ),
    CategoryModel(
      title: "مدن تاريخية",
      image: "assets/images/historic_cities.png",
      items: [],
    ),
    CategoryModel(
      title: "صحــراء",
      image: "assets/images/desert.png",
      items: [],
    ),
    CategoryModel(
      title: "جبـــال",
      image: "assets/images/mountains.png",
      items: [],
    ),
    CategoryModel(
      title: "شـواطـئ",
      image: "assets/images/beaches.png",
      items: [],
    ),
    CategoryModel(
      title: "منتجعات وشاليهات",
      image: "assets/images/resorts_bungalows.png",
      items: [],
    ),
  ];
}
