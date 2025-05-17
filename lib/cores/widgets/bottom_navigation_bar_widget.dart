import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final NotchBottomBarController controller;
  final bool admin;
  final Function(int)? onTap;
  const BottomNavigationBarWidget(
      {super.key, required this.controller, this.admin = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      elevation: 0,
      kIconSize: 15,
      kBottomRadius: 20,
      onTap: (value) {
        onTap?.call(value);
      },
      notchBottomBarController: controller,
      bottomBarItems: [
        BottomBarItem(
          inActiveItem: Icon(
            Icons.person,
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          ),
          activeItem: Icon(
            Icons.person,
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          ),
          itemLabel: '',
        ),
        BottomBarItem(
          inActiveItem: Icon(
            Icons.home_filled,
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          ),
          activeItem: Icon(
            Icons.home_filled,
            color: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
          ),
          itemLabel: '',
        ),
      ],
    );
  }
}
