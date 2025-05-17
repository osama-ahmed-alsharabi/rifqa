import 'package:flutter/material.dart';
import 'package:rifqa/Features/Splash/presentation/splash_view.dart';
import 'package:rifqa/Features/admin/presentation/views/adding_view_item.dart';
import 'package:rifqa/Features/admin/presentation/views/admin_view.dart';
import 'package:rifqa/Features/admin/presentation/views/bookings_view.dart';
import 'package:rifqa/Features/admin/presentation/views/editing_view.dart';
import 'package:rifqa/Features/admin/presentation/views/user_manage_view.dart';
import 'package:rifqa/Features/auth/presentation/view/login_view.dart';
import 'package:rifqa/Features/auth/presentation/view/signup_view.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/details_view.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/home_view.dart';
import 'package:rifqa/Features/intro/presentation/intro_view.dart';
import 'package:rifqa/Features/profile/presentation/view/profile_view.dart';
import 'package:rifqa/cores/widgets/main_view.dart';

class AppRouter {
  static String kSplashRoute = 'splash';
  static String kSignUpRoute = 'signUp';
  static String kIntroRoute = 'intro';
  static String kHomeRoute = 'home';
  static String kMainRoute = 'main';
  static String kDetailsRoute = 'details';
  static String kProfileRoute = 'profile';
  static String kLoginRoute = 'login';
  static String kAdminViewRoute = 'adminView';
  static String kAddingViewItemRoute = 'addingViewItem';
  static String kEditingViewItemRoute = 'editingViewItem';
  static String kUserManagesRoute = 'usersManage';
  static String kBookingRoute = 'booking';
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRouter.kMainRoute: (context) => const MainView(),
    AppRouter.kSplashRoute: (context) => const SplashView(),
    AppRouter.kIntroRoute: (context) => const IntroView(),
    AppRouter.kSignUpRoute: (context) => const SignUpView(),
    AppRouter.kHomeRoute: (context) => const HomeView(),
    AppRouter.kDetailsRoute: (context) => const DetailsView(),
    AppRouter.kProfileRoute: (context) => const ProfileView(
          userName: "admin",
        ),
    AppRouter.kLoginRoute: (context) => const LoginView(),
    AppRouter.kAdminViewRoute: (context) => const AdminView(),
    AppRouter.kAddingViewItemRoute: (context) => const AddingViewItem(),
    AppRouter.kEditingViewItemRoute: (context) => const EditingView(),
    AppRouter.kUserManagesRoute: (context) => const UserManageView(),
    AppRouter.kBookingRoute: (context) => const BookingsView(),
  };
}
