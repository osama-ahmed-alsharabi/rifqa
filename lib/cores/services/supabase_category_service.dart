import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rifqa/Features/home/data/model/category_item_model.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      bool isGranted = await requestImagePermission();
      if (!isGranted) {
        throw 'يجب السماح بالوصول إلى الملفات لاختيار صورة.';
      }

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      return File(image.path);
    } catch (e) {
      throw Exception('حدث خطأ أثناء اختيار الصورة: ${_getErrorMessage(e)}');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      final extension = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final filePath = 'category-images/$fileName';

      await _client.storage.from('category-images').upload(
            filePath,
            imageFile,
            fileOptions: FileOptions(contentType: 'image/$extension'),
          );

      return _client.storage.from('category-images').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('فشل في رفع الصورة: ${_getErrorMessage(e)}');
    }
  }

  Future<bool> requestImagePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isGranted ||
          await Permission.photos.isGranted) {
        return true;
      }

      if (Platform.isAndroid && Platform.version.contains("13")) {
        var mediaStatus = await Permission.photos.request();
        return mediaStatus.isGranted;
      } else {
        var storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Future<CategoryItemModel> createCategory(CategoryItemModel category) async {
    try {
      final response = await _client
          .from('category_item')
          .insert(category.toJson())
          .select()
          .single();

      return CategoryItemModel.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إنشاء التصنيف: ${_getErrorMessage(e)}');
    }
  }

  Future<List<CategoryItemModel>> getAllCategories() async {
    try {
      final response = await _client
          .from('category_item')
          .select('*')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CategoryItemModel.fromJson(json))
          .toList();
    } catch (e) {
      throw 'فشل في جلب التصنيفات: ${_getErrorMessage(e)}';
    }
  }

  Future<CategoryItemModel> updateCategory(CategoryItemModel category) async {
    try {
      final response = await _client
          .from('category_item')
          .update(category.toJson())
          .eq('id', category.id!)
          .select()
          .single();

      return CategoryItemModel.fromJson(response);
    } catch (e) {
      throw 'فشل في تحديث التصنيف: ${_getErrorMessage(e)}';
    }
  }

  Future<void> deleteCategory(String id, String imagePath) async {
    try {
      if (imagePath.isNotEmpty) {
        final fileName = imagePath.split('/').last;
        await _client.storage.from('category-images').remove([fileName]);
      }

      await _client.from('category_item').delete().eq('id', id);
    } catch (e) {
      throw 'فشل في حذف التصنيف: ${_getErrorMessage(e)}';
    }
  }

  String _getErrorMessage(Object e) {
    if (e is PostgrestException) {
      return e.message;
    } else if (e is StorageException) {
      return e.message;
      // ?? 'خطأ في التخزين';
    } else {
      return e.toString().replaceAll('Exception: ', '');
    }
  }
}
