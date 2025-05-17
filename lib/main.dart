import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rifqa/Features/chat/presentation/view_model/ai_chat_cubit/ai_chat_cubit.dart';
import 'package:rifqa/Features/home/presentation/view_model/fetch_category_data_cubit/fetch_category_data_cubit.dart';
import 'package:rifqa/Features/profile/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:rifqa/Features/reservation/data/repo/reservation_repo_impl.dart';
import 'package:rifqa/Features/reservation/presentation/view_model/reservation_cubit/reservation_cubit_cubit.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';
import 'package:rifqa/cores/routes/app_router.dart';
import 'package:rifqa/cores/services/service_provider.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:rifqa/cores/services/simple_bloc_observer.dart';
import 'package:rifqa/cores/utils/image_const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late bool isFirstOpen;
late bool isDark;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setupHotelFinderDependencies();
  Bloc.observer = SimpleBlocObserver();
  await Supabase.initialize(
    url: 'https://fbroukvihufrjvfkdmur.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZicm91a3ZpaHVmcmp2ZmtkbXVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU0NTI1MzUsImV4cCI6MjA2MTAyODUzNX0.lnNR1edlEnzZH1JU4Xv6FNmkB1CY0ZWoLUA7oGThbas',
  );
  await SharedPreferencesService.init();
  isDark = await SharedPreferencesService.getThemeApp() ?? true;
  await SharedPreferencesService.saveThemeAPp(isDark);
  isFirstOpen = await SharedPreferencesService.isNotFirstOpen();
  runApp(const ServiceProvider(child: Rifqa()));
}

class Rifqa extends StatelessWidget {
  const Rifqa({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => FetchCategoryDataCubit(),
        ),
        BlocProvider(
          create: (context) => AiChatCubit(),
        ),
        BlocProvider(
            create: (context) => ThemeAppCubit()..changeThemeApp(isDark)),
        BlocProvider(
          create: (context) => ReservationCubit(
            ReservationRepoImpl(Supabase.instance.client),
          ),
        ),
      ],
      child: const TheMaterialAppWidget(),
    );
  }
}

class TheMaterialAppWidget extends StatelessWidget {
  const TheMaterialAppWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeAppCubit, ThemeAppState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(useMaterial3: false).copyWith(
            scaffoldBackgroundColor:
                BlocProvider.of<ThemeAppCubit>(context).kprimayColor,
            textTheme: ThemeData.dark().textTheme.apply(
                  fontFamily: ImageConst.kPrimayFonts,
                ),
          ),
          routes: AppRouter.routes,
          initialRoute: AppRouter.kSplashRoute,
        );
      },
    );
  }
}
