// import 'dart:html';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hookup4u2/common/common.dart';
import 'package:hookup4u2/features/chat/chat.dart';
import 'package:hookup4u2/features/home/bloc/anon_profile_bloc.dart';
import 'package:hookup4u2/features/home/domain/model/anon_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AnonConvoRepo {
  Future<String> getUuid() async {
    if (!kIsWeb) return '';

    final sharedPref = await SharedPreferences.getInstance();
    final data = sharedPref.getString(kProfileKey);

    if (data != null) {
      return AnonProfile.fromJson(jsonDecode(data)).id;
    }

    debugPrint('SHOULD_NOT_BE_HERE');
    final newId = const Uuid().v4();
    await sharedPref.setString('id', newId);

    return newId;
  }

  Future<Conversation?> _getConvo(String aiProfileId, String anonId) async {
    try {
      final convo = await supabaseClient
          .from('conversations')
          .select('*,ai_profiles(*,ai_profile_images(*))')
          .eq('anon_profiles_id', anonId)
          .eq('ai_profiles_id', aiProfileId)
          .eq('type', 'anon')
          .single();

      return Conversation.fromJson(convo);
    } catch (err) {
      debugPrint('Failed to get convo: $err');
      return null;
    }
  }

  _createConvo(String aiProfileId, String anonId) async {
    return supabaseClient.from('conversations').upsert({
      'anon_profiles_id': anonId,
      'ai_profiles_id': aiProfileId,
      'type': 'anon',
    }, onConflict: 'anon_profiles_id,ai_profiles_id');
  }

  Future<Conversation> getOrCreateConvo(String aiProfileId, String anonId) async {
    final existingConvo = await _getConvo(aiProfileId, anonId);
    if (existingConvo != null) {
      return existingConvo;
    }

    await _createConvo(aiProfileId, anonId);

    final newConvo = await _getConvo(aiProfileId, anonId);

    if (newConvo == null) {
      throw 'Failed to create convo';
    }

    return newConvo;
  }
}
