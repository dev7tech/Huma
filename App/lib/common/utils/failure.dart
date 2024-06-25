import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFailure implements Exception {
  const SupabaseFailure([this.message = 'An unknown error occurred.']);
  final String message;

  factory SupabaseFailure.fromException(Object e) {
    debugPrint("SUPABASE_FAILURE $e");
    if (e is PostgrestException) {
      return SupabaseFailure(e.message);
    }
    if (e is SocketException) {
      return const SupabaseFailure('No internet connection');
    }

    return const SupabaseFailure();
  }

  @override
  String toString() => message;
}
