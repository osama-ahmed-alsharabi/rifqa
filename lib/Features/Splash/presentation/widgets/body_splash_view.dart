import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/Features/profile/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/services/supabase_service.dart';
import 'package:rifqa/cores/services/user_service.dart';
import 'package:rifqa/cores/utils/image_const.dart';
import 'package:rifqa/main.dart';

class BodySplashView extends StatefulWidget {
  const BodySplashView({super.key});

  @override
  State<BodySplashView> createState() => _BodySplashViewState();
}

class _BodySplashViewState extends State<BodySplashView> {
  late bool isLoggedInVarible;
  late String? hasName;
  late String? userId;
  bool isUserActive = true;
  final supabase = SupabaseService().client;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    isLoggedInVarible = await SharedPreferencesService.isLoggedIn();
    hasName = await BlocProvider.of<ProfileCubit>(context).getUserName();
    userId = await SharedPreferencesService.getUserId();

    BlocProvider.of<FetchCategoryDataCubit>(context).fetch();

    if (isLoggedInVarible && userId != null) {
      isUserActive = await _checkUserActiveStatus();
    }

    Future.delayed(const Duration(seconds: 3))
        .then((_) => _navigateBasedOnStatus());
  }

  Future<bool> _checkUserActiveStatus() async {
    try {
      final userService = UserService(supabase);
      return await userService.checkUserActive(userId!);
    } catch (e) {
      return true;
    }
  }

  void _navigateBasedOnStatus() {
    if (!mounted) return;

    if (!isUserActive) {
      _showDeactivationMessage();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.kLoginRoute,
        (route) => false,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        isFirstOpen
            ? isLoggedInVarible
                ? AppRouter.kMainRoute
                : AppRouter.kLoginRoute
            : AppRouter.kIntroRoute,
        arguments: hasName == null ? true : false,
      );
    }
  }

  void _showDeactivationMessage() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إيقاف حسابك. يرجى التواصل مع الإدارة'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ImageConst.kLogo),
      ],
    );
  }
}
