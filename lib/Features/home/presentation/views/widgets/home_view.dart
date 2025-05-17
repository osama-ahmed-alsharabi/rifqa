import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rifqa/Features/chat/presentation/view/chat_ai_view.dart';
import 'package:rifqa/Features/google_map/presentation/views/map_home_view.dart';
import 'package:rifqa/Features/home/presentation/views/widgets/body_home_view_widget.dart';
import 'package:rifqa/Features/reservation/presentation/views/reservations_list_screen.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final pageController = PageController(initialPage: 2);
  final NotchBottomBarController controller =
      NotchBottomBarController(index: 2);

  String? name;
  getUserName() async {
    name = await SharedPreferencesService.getUserName();
    return name;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeAppCubit, ThemeAppState>(
      builder: (context, state) {
        return SafeArea(
            child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            drawer: Drawer(
              width: MediaQuery.sizeOf(context).width * 0.75,
              backgroundColor:
                  BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
              child: Column(children: [
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage(ImageConst.kLogo))),
                  accountName: SizedBox(),
                  accountEmail: SizedBox(),
                ),
                GestureDetector(
                  onTap: () async {
                    bool? isDark = await SharedPreferencesService.getThemeApp();
                    await BlocProvider.of<ThemeAppCubit>(context)
                        .changeThemeApp(!isDark!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              BlocProvider.of<ThemeAppCubit>(context)
                                          .kprimayColor ==
                                      const Color(0xFF166787)
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            )),
                        Text("مظهر التطبيق",
                            style: AppStyles.styleText16.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReservationsListScreen(
                                  isAdmin: false,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.receipt_long_outlined,
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            )),
                        Text("السجل الخاص",
                            style: AppStyles.styleText16.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AiChatScreen(userLocation: "صنعاء")));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.brain,
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            )),
                        Text("المرشد الذكي",
                            style: AppStyles.styleText16.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapHomeView()));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.hotel,
                              color: BlocProvider.of<ThemeAppCubit>(context)
                                  .kprimayColor,
                            )),
                        Text("الفنادق القريبة",
                            style: AppStyles.styleText16.copyWith(
                                color: BlocProvider.of<ThemeAppCubit>(context)
                                    .kprimayColor)),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            body: const BodyHomeViewWidget(),
          ),
        ));
      },
    );
  }
}
