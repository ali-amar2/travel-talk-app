import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadPostImage({
    required File file,
    required String userId,
  }) async {
    final extension = path.extension(file.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
    final storagePath = '$userId/posts/$fileName';

    await _client.storage
        .from('post-images')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('post-images').getPublicUrl(storagePath);
  }

  Future<String> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    final extension = path.extension(file.path);
    final fileName =
        'profile_${DateTime.now().millisecondsSinceEpoch}$extension';
    final storagePath = '$userId/profile/$fileName';

    await _client.storage
        .from('post-images')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('post-images').getPublicUrl(storagePath);
  }

  Future<String> uploadTripImage({
    required File file,
    required String userId,
  }) async {
    final extension = path.extension(file.path);
    final fileName = 'trip_${DateTime.now().millisecondsSinceEpoch}$extension';
    final storagePath = '$userId/trips/$fileName';

    await _client.storage
        .from('post-images')
        .upload(
          storagePath,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from('post-images').getPublicUrl(storagePath);
  }
}
