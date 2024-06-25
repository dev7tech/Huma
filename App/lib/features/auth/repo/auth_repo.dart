import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/auth/models/models.dart';
import 'package:hookup4u2/features/user/models/profile.dart';
import 'package:hookup4u2/features/user/profile/cubit/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthFailure implements Exception {
  const AuthFailure([this.message = 'An unknown error occurred.']);
  final String message;

  factory AuthFailure.fromException(Object e) {
    if (e is AuthException) {
      return AuthFailure(e.message);
    }
    if (e is SocketException) {
      return const AuthFailure('No internet connection');
    }

    return const AuthFailure();
  }

  @override
  String toString() => message;
}

class StorageFailure implements Exception {
  const StorageFailure([this.message = 'An unknown error occurred.']);
  final String message;

  factory StorageFailure.fromException(Object e) {
    if (e is StorageException) {
      return StorageFailure(e.message);
    }
    if (e is SocketException) {
      return const StorageFailure('No internet connection');
    }

    return const StorageFailure();
  }

  @override
  String toString() => message;
}

class AuthRepo {
  AuthRepo({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  Stream<AppUser> onAuthStateChanged() =>
      _supabaseClient.auth.onAuthStateChange.map(
        (e) => AppUser.fromSession(e.session),
      );

  AppUser get currentUser =>
      AppUser.fromSession(_supabaseClient.auth.currentSession);

  login(String phone) async {
    return asyncExecutor(
      () => _supabaseClient.auth.signInWithOtp(phone: phone),
      AuthFailure.fromException,
    );
  }

  verifyOtp(String phone, String token) async {
    return asyncExecutor(
      () => _supabaseClient.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      ),
      AuthFailure.fromException,
    );
  }

  FutureOr<void> logOut() {
    _supabaseClient.auth.signOut();
  }

  Future<String> uploadUserPic(File img, [String bucket = 'profiles']) async {
    final bytes = await img.readAsBytes();
    final fileExt = img.path.split('.').last;
    final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
    final filePath = '${currentUser.id}/$fileName';

    try {
      await _supabaseClient.storage.from(bucket).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: XFile(img.path).mimeType),
          );

      return _supabaseClient.storage
          .from(bucket)
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
    } catch (e) {
      throw StorageFailure.fromException(e);
    }
  }

  Future<Profile> updateProfile(ProfileDto state) async {
    return asyncExecutor<Profile>(
      () async {
        final result = await _supabaseClient
            .from('profiles')
            .update(state.toMap())
            .eq('id', currentUser.id)
            .select('*')
            .single();

        return Profile.fromMap(result);
      },
      SupabaseFailure.fromException,
    );
  }

  Future<Profile?> getProfile(String userId) async {
    return asyncExecutor<Profile?>(
      () async {
        final result =
            await _supabaseClient.from('profiles').select('*').eq('id', userId);

        return result.isEmpty ? Profile.empty : Profile.fromMap(result[0]);
      },
      SupabaseFailure.fromException,
    );
  }

  bool isDevAvailable() {
    final phone = dotenv.env['DEV_PHONE'];
    final otp = dotenv.env['DEV_OTP'];

    return kDebugMode && phone != null && otp != null;
  }
}
