import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../../../../service/alarm_sound_service.dart';
import '../../../data/models/alarm_sound.dart';

class AlarmController extends GetxController {
  /// 🔔 Thời gian báo thức
  var alarmTime = TimeOfDay.now().obs;

  /// 🔉 Danh sách nhạc chuông
  var alarmSounds = <AlarmSound>[].obs;

  /// ✅ Nhạc chuông đã chọn
  var selectedAlarmSound = Rxn<AlarmSound>();

  /// 🔊 Âm lượng (0.0 - 1.0)
  var alarmVolume = 1.0.obs;

  /// 📳 Rung
  var vibrationEnabled = true.obs;

  /// 🧠 Smart Alarm offset
  var smartAlarmOffsetMinutes = 0.obs;

  /// 😴 Snooze
  var snoozeMinutes = 5.obs;

  /// 📻 Audio player preview
  final _player = AudioPlayer();
  Timer? _previewTimer;

  /// 📅 Chọn thời gian
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: alarmTime.value,
    );
    if (picked != null && picked != alarmTime.value) {
      alarmTime.value = picked;
    }
  }

  /// 🔗 Load nhạc chuông từ Supabase
  Future<void> loadAlarmSounds() async {
    final sounds = await AlarmSoundService().fetchAllSounds();
    alarmSounds.assignAll(sounds);
    if (selectedAlarmSound.value == null && sounds.isNotEmpty) {
      selectedAlarmSound.value = sounds.first;
    }
  }

  /// ▶️ Nghe thử 5 giây
  Future<void> playPreview(String url) async {
    try {
      await _player.setUrl(url);
      _player.setVolume(alarmVolume.value);
      _player.play();

      _previewTimer?.cancel();
      _previewTimer = Timer(const Duration(seconds: 5), () {
        _player.stop();
      });
    } catch (e) {
      print("❌ Preview error: $e");
    }
  }

  void stopPreview() {
    _player.stop();
    _previewTimer?.cancel();
  }

  @override
  void onClose() {
    _player.dispose();
    _previewTimer?.cancel();
    super.onClose();
  }
}