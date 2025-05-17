import 'dart:async';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/admin/presentation/views/admin_view.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/home_view.dart';
import 'package:rifqa/Features/profile/presentation/view/profile_view.dart';
import 'package:rifqa/Features/profile/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:rifqa/cores/widgets/bottom_navigation_bar_widget.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _bottomBarController =
      NotchBottomBarController(index: 1);
  String? userName;
  StreamSubscription<List<Map<String, dynamic>>>? _userStatusSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomBarController.dispose();
    _userStatusSubscription?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) async {
    userName = await BlocProvider.of<ProfileCubit>(context).getUserName();
    _bottomBarController.index = index;
    setState(() {});
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onBottomBarTap(int index) async {
    userName = await BlocProvider.of<ProfileCubit>(context).getUserName();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool? admin = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileView(
            userName: userName ?? "admin",
          ),
          admin ? const AdminView() : const HomeView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        controller: _bottomBarController,
        admin: admin,
        onTap: _onBottomBarTap,
      ),
    );
  }
}
