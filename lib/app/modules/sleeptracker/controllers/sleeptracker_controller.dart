import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../service/alarm_sound_service.dart';
import '../../../data/models/alarm_sound.dart';

class SleepTrackerController extends GetxController {
  // Đã có sẵn
  final bedTime = TimeOfDay(hour: 19, minute: 55).obs;
  final alarmStart = TimeOfDay(hour: 6, minute: 25).obs;
  final alarmEnd = TimeOfDay(hour: 6, minute: 55).obs;
  final updatedAlarmStart = Rx<TimeOfDay?>(null);
  final smartAlarmOffsetMinutes = 0.obs;
  final RxBool isSmartAlarmEnabled = true.obs;
  var snoozeMinutes = 5.obs;
  final _player = AudioPlayer();
  Timer? _previewTimer;

  /// ✅ Nhạc chuông từ Supabase
  var alarmSounds = <AlarmSound>[].obs;
  var selectedAlarmSound = Rxn<AlarmSound>();

  /// ✅ Âm lượng báo thức (0.0 - 1.0)
  var alarmVolume = 1.0.obs;

  var selectedRingtoneName = "Ocean waves".obs;

  /// ✅ Bật rung
  var vibrationEnabled = true.obs;

  /// Format dạng 'hh:mm AM/PM'
  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void updateBedTime(TimeOfDay newTime) {
    bedTime.value = newTime;
  }

  void updateAlarmStart(TimeOfDay newTime) {
    alarmStart.value = newTime;
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

  /// ✅ Gọi từ AlarmView để load nhạc chuông từ Supabase
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
      print("Error playing preview: $e");
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