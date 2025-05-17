import 'package:rifqa/Features/home/data/model/category_item_model.dart';

class CategoryModel {
  final String title;
  final String image;
  final List<CategoryItemModel> items;

  CategoryModel({required this.title, required this.image, required this.items});
}