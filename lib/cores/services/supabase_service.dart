import 'package:rifqa/cores/services/shared_preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/password_hasher.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  String _handleError(dynamic error) {
    try {
      // Handle String messages
      if (error is String) {
        if (error.toLowerCase().contains('user not found')) {
          return 'لم يتم العثور على المستخدم';
        }
        if (error.toLowerCase().contains('invalid password')) {
          return 'كلمة المرور غير صحيحة';
        }
        if (error.toLowerCase().contains('username already exists')) {
          return 'اسم المستخدم موجود بالفعل';
        }
        return 'حدث خطأ غير متوقع';
      }

      if (error is PostgrestException) {
        switch (error.code) {
          case 'PGRST204':
            return 'لم يتم العثور على البيانات';
          case '23505':
            return 'اسم المستخدم موجود مسبقاً';
          case 'PGRST116':
            return 'يوجد أكثر من مستخدم بنفس الاسم';
          default:
            return 'خطأ في قاعدة البيانات';
        }
      }

      if (error is AuthException) {
        return 'خطأ في نظام المصادقة';
      }

      if (error is Exception) {
        final message = error.toString();
        if (message.contains('JSON object requested')) {
          return 'خطأ في البيانات المسترجعة';
        }
        return 'حدث خطأ في النظام';
      }

      return 'حدث خطأ غير معروف';
    } catch (e) {
      return 'خطأ في معالجة البيانات';
    }
  }

  Future<Map<String, dynamic>> signInWithName({
    required String name,
    required String password,
  }) async {
    try {
      final results =
          await client.from('users').select().eq('name', name).limit(1000);

      if (results.isEmpty) {
        throw 'لم يتم العثور على المستخدم';
      }

      for (final user in results) {
        final storedHash = user['password_hash'] as String;
        final salt = user['salt'] as String;

        if (PasswordHasher.verifyPassword(password, storedHash, salt)) {
          await SharedPreferencesService.saveUserId(user['id'] as String);
          await SharedPreferencesService.saveUserPhone(
              user['phone_number'] as String);
          return user;
        }
      }

      throw 'كلمة المرور غير صحيحة';
    } catch (e) {
      throw e is String ? e : 'حدث خطأ غير متوقع';
    }
  }

  Future<List<Map<String, dynamic>>> getAllHotels() async {
    try {
      final response = await client.from('hotels').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createReservation({
    required String hotelId,
    required String reservationType,
    required int numberOfClients,
    required int durationDays,
  }) async {
    try {
      final userId = await SharedPreferencesService.getUserId();
      if (userId == null) throw 'يجب تسجيل الدخول أولاً';

      final response = await client
          .from('reservations')
          .insert({
            'user_id': userId,
            'hotel_id': hotelId,
            'reservation_type': reservationType,
            'number_of_clients': numberOfClients,
            'duration_days': durationDays,
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getUserReservations() async {
    try {
      final userId = await SharedPreferencesService.getUserId();
      if (userId == null) throw 'يجب تسجيل الدخول أولاً';

      final response = await client.from('reservations').select('''
          *,
          hotels:hotel_id (name, address, image_url)
        ''').eq('user_id', userId).order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    try {
      final userId = await SharedPreferencesService.getUserId();
      if (userId == null) throw 'يجب تسجيل الدخول أولاً';

      await client
          .from('reservations')
          .update({'status': 'cancelled'})
          .eq('id', reservationId)
          .eq('user_id', userId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> signUp({
    required String name,
    required String password,
    required int age,
    required String nationality,
    required String phoneNumber,
    required String secondaryPhoneNumber,
    required String city,
  }) async {
    try {
      final salt = PasswordHasher.generateSalt();
      final passwordHash = PasswordHasher.hashPassword(password, salt);

      final response = await client
          .from('users')
          .insert({
            'name': name,
            'password_hash': passwordHash,
            'salt': salt,
            'age': age,
            'nationality': nationality,
            'phone_number': phoneNumber,
            'secondary_phone_number': secondaryPhoneNumber,
            'city': city,
            'is_active': true,
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> signOut() async {}

  Future<Map<String, dynamic>?> getCurrentUser() async {
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await client.from('users').select('''
        id, 
        name, 
        age, 
        nationality,
        phone_number,
        secondary_phone_number,
        city,
        created_at
      ''');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await client.from('users').delete().eq('id', userId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? name,
    int? age,
    String? nationality,
    String? phoneNumber,
    String? secondaryPhoneNumber,
    String? city,
  }) async {
    try {
      final response = await client
          .from('users')
          .update({
            if (name != null) 'name': name,
            if (age != null) 'age': age,
            if (nationality != null) 'nationality': nationality,
            if (phoneNumber != null) 'phone_number': phoneNumber,
            if (secondaryPhoneNumber != null)
              'secondary_phone_number': secondaryPhoneNumber,
            if (city != null) 'city': city,
          })
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }
}
