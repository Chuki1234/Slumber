import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/data/models/alarm_sound.dart';

class AlarmSoundService {
  final _client = Supabase.instance.client;

  Future<List<AlarmSound>> fetchAllSounds() async {
    final res = await _client
        .from('alarm_sounds')
        .select()
        .order('created_at', ascending: true);

    return (res as List)
        .map((json) => AlarmSound.fromJson(json))
        .toList();
  }
}