import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/utils/app_styles.dart';

class ProfileItemList extends StatelessWidget {
  final String text;
  final IconData icon;
  const ProfileItemList({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.07,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xffEDEDED),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          FittedBox(
            child: Text(
              text,
              style: AppStyles.styleText16.copyWith(
                  color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor),
            ),
          ),
          Flexible(
            child: Icon(
              icon,
              color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
            ),
          ),
        ],
      ),
    );
  }
}
