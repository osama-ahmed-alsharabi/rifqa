// cores/services/supabase_user_service.dart

import 'package:rifqa/Features/admin/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase;

  UserService(this._supabase);

  Future<List<UserModel>> getUsers() async {
    final response = await _supabase
        .from('users')
        .select('*')
        .order('created_at', ascending: false);

    return response.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  }

  Future<List<UserModel>> searchUsers(String query) async {
    final response = await _supabase
        .from('users')
        .select('*')
        .ilike('name', '%$query%')
        .order('created_at', ascending: false);

    return response.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    await _supabase
        .from('users')
        .update({'is_active': isActive}).eq('id', userId);
  }

  Future<bool> checkUserActive(String userId) async {
    final response = await _supabase
        .from('users')
        .select('is_active')
        .eq('id', userId)
        .single();

    return response['is_active'] as bool;
  }
}
