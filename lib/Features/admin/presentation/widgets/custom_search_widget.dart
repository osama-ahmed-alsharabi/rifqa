import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchWidget({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          style: TextStyle(
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
            ),
            hintText: "بحث",
            hintStyle: AppStyles.styleText16.copyWith(
              color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
            ),
          ),
        ),
      ),
    );
  }
}
