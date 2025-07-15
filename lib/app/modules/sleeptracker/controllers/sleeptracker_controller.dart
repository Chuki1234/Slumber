import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/alarm_sound_service.dart';
import '../../../data/models/alarm_sound.dart';

class SleepTrackerController extends GetxController {
  final bedTime = TimeOfDay(hour: 22, minute: 0).obs;
  final alarmStart = TimeOfDay(hour: 6, minute: 0).obs;
  final alarmEnd = TimeOfDay(hour: 6, minute: 30).obs;
  final updatedAlarmStart = Rx<TimeOfDay?>(null);
  final smartAlarmOffsetMinutes = 0.obs;
  final RxBool isSmartAlarmEnabled = true.obs;
  final snoozeMinutes = 5.obs;

  final _player = AudioPlayer();
  Timer? _previewTimer;

  // ✅ Âm thanh
  var alarmSounds = <AlarmSound>[].obs;
  var selectedAlarmSound = Rxn<AlarmSound>();
  var alarmVolume = 1.0.obs;
  var selectedRingtoneName = "Ocean waves".obs;
  var vibrationEnabled = true.obs;

  // 🔁 Gọi khi app khởi động
  @override
  void onInit() {
    super.onInit();
    loadBedTime(); // Load từ SharedPreferences
  }

  // 🔁 Gọi khi app đóng
  @override
  void onClose() {
    _player.dispose();
    _previewTimer?.cancel();
    super.onClose();
  }

  // -----------------------------
  // 🎯 Time updates
  // -----------------------------

  void updateBedTime(TimeOfDay newTime) {
    bedTime.value = newTime;
    saveBedTime(newTime);
  }

  void updateAlarmStart(TimeOfDay newTime) {
    alarmStart.value = newTime;
    // Có thể save nếu cần
  }

  void updateAlarmEnd(TimeOfDay newTime) {
    updatedAlarmStart.value = newTime;
    alarmEnd.value = newTime;
  }

  void updateSmartAlarmOffset(int minutes) {
    smartAlarmOffsetMinutes.value = minutes;
  }

  void updateSnoozeMinutes(int value) {
    snoozeMinutes.value = value;
  }

  // -----------------------------
  // 💾 SharedPreferences: lưu & load bedtime
  // -----------------------------

  Future<void> saveBedTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bed_hour', time.hour);
    await prefs.setInt('bed_minute', time.minute);
  }

  Future<void> loadBedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('bed_hour') ?? 22;
    final minute = prefs.getInt('bed_minute') ?? 0;
    bedTime.value = TimeOfDay(hour: hour, minute: minute);
  }

  // -----------------------------
  // 🔊 Preview âm thanh
  // -----------------------------

  Future<void> loadAlarmSounds() async {
    final sounds = await AlarmSoundService().fetchAllSounds();
    alarmSounds.assignAll(sounds);
    if (selectedAlarmSound.value == null && sounds.isNotEmpty) {
      selectedAlarmSound.value = sounds.first;
    }
  }

  Future<void> playPreview(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();

      _previewTimer?.cancel();
      _previewTimer = Timer(const Duration(seconds: 5), () {
        _player.stop();
      });
    } catch (e) {
      print("❌ Error playing preview: $e");
    }
  }

  void stopPreview() {
    _player.stop();
    _previewTimer?.cancel();
  }

  // -----------------------------
  // 🕓 Format tiện lợi
  // -----------------------------

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
