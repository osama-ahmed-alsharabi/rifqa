import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/reservation/presentation/views/reservations_list_screen.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/utils/app_styles.dart';
import 'package:rifqa/cores/utils/image_const.dart';

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
      child: Column(children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(ImageConst.kLogo))),
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
                      BlocProvider.of<ThemeAppCubit>(context).kprimayColor ==
                              const Color(0xFF166787)
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color:
                          BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
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
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRouter.kUserManagesRoute);
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
                      Icons.people_alt_outlined,
                      color:
                          BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
                    )),
                Text("المستخدمين",
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
                          isAdmin: true,
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
                FittedBox(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.receipt_long_outlined,
                        color: BlocProvider.of<ThemeAppCubit>(context)
                            .kprimayColor,
                      )),
                ),
                Text("الحجوزات",
                    style: AppStyles.styleText16.copyWith(
                        color: BlocProvider.of<ThemeAppCubit>(context)
                            .kprimayColor)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
