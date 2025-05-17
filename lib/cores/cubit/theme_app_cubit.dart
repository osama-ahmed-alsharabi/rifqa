import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rifqa/cores/services/shared_preferences_service.dart';

part 'theme_app_state.dart';

class ThemeAppCubit extends Cubit<ThemeAppState> {
  ThemeAppCubit() : super(ThemeAppInitial());
  Color kprimayColor = Colors.black;
  changeThemeApp(bool isDark) async {
    await SharedPreferencesService.saveThemeAPp(isDark);
    if (isDark) {
      kprimayColor = const Color(0xFF166787);
      emit(ThemeAppDark());
    } else {
      kprimayColor = const Color.fromARGB(255, 30, 30, 30);
      emit(ThemeAppLight());
    }
  }
}
