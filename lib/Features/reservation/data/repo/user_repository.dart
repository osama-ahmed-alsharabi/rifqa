import 'dart:convert';

import 'package:rifqa/Features/reservation/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient supabase;
  final SharedPreferences prefs;

  UserRepository({required this.supabase, required this.prefs});

  Future<UserApp?> verifyUser(String name, String password) async {
    final response = await supabase
        .from('users')
        .select()
        .eq('name', name)
        .eq('password', password)
        .maybeSingle();

    return response != null ? UserApp.fromMap(response) : null;
  }

  Future<void> saveUserLocally(UserApp user) async {
    await prefs.setString('current_user', jsonEncode(user.toMap()));
  }

  Future<UserApp?> getLocalUser() async {
    final userData = prefs.getString('current_user');
    return userData != null ? UserApp.fromMap(jsonDecode(userData)) : null;
  }

  Future<void> clearLocalUser() async {
    await prefs.remove('current_user');
  }

  Future<void> registerUser(UserApp user) async {
    await supabase.from('users').insert(user.toMap());
  }
}
