import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/services/supabase_category_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class CategoryItemWidgetDetails extends StatefulWidget {
  final bool admin;
  final CategoryItemModel item;
  const CategoryItemWidgetDetails({
    super.key,
    this.admin = false,
    required this.item,
  });

  @override
  State<CategoryItemWidgetDetails> createState() =>
      _CategoryItemWidgetDetailsState();
}

class _CategoryItemWidgetDetailsState extends State<CategoryItemWidgetDetails> {
  showDialogBox() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              backgroundColor:
                  BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              icon: const Icon(FontAwesomeIcons.trashCan),
              content: const Text('هل أنت متأكد من حذف القسم؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('لا'),
                ),
                TextButton(
                  onPressed: () async {
                    await CategoryService()
                        .deleteCategory(widget.item.id!, widget.item.imageUrl);
                    await BlocProvider.of<FetchCategoryDataCubit>(context)
                        .fetch();
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('نعم'),
                ),
              ]));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              FittedBox(
                                child: Text(
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  widget.item.name,
                                  style: AppStyles.styleText16.copyWith(
                                      color: BlocProvider.of<ThemeAppCubit>(
                                              context)
                                          .kprimayColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              widget.admin
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialogBox();
                                      },
                                      child: const Icon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.red,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          Expanded(
                            child: Text(
                              textAlign: TextAlign.right,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              widget.item.description,
                              style: AppStyles.styleText12.copyWith(
                                  color: BlocProvider.of<ThemeAppCubit>(context)
                                      .kprimayColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                        color: BlocProvider.of<ThemeAppCubit>(context)
                            .kprimayColor,
                      )),
                      errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error, color: Colors.red)),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              style:
                  AppStyles.styleText20.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              " . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ")
        ],
      ),
    );
  }
}
