import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

import '../../Alarm/controllers/alarm_controller.dart';

class TrackerController extends GetxController {
  final count = 0.obs;
  final selectedSongName = 'No song selected'.obs;
  final isAlarmRinging = false.obs;
  final showAlarmOverlay = false.obs;

  Timer? _checkTimer;
  final _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();

    _checkTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      final alarmController = Get.find<AlarmController>();
      final now = TimeOfDay.now();

      print("🕒 Now: ${now.hour}:${now.minute}, Alarm: ${alarmController.alarmTime.value.hour}:${alarmController.alarmTime.value.minute}");

      alarmController.checkAlarmAndTrigger(() async {
        print("⏰ Alarm triggered!");
        showAlarmOverlay.value = true;
        await triggerAlarmIfNeeded(); // 🔊 Chuông + Rung
      });
    });
  }

  @override
  void onClose() {
    _checkTimer?.cancel();
    stopAlarm();
    _audioPlayer.dispose();
    super.onClose();
  }

  void setSelectedSong(String name) {
    selectedSongName.value = name;
  }

  void increment() => count.value++;

  /// 🕒 Kiểm tra nếu đến giờ báo thức thì bật chuông
  Future<void> triggerAlarmIfNeeded() async {
    final alarmCtrl = Get.find<AlarmController>();
    final now = TimeOfDay.now();
    final alarm = alarmCtrl.alarmTime.value;

    if (!isAlarmRinging.value &&
        now.hour == alarm.hour &&
        now.minute == alarm.minute) {
      isAlarmRinging.value = true;

      // 📳 Rung nếu bật
      if (alarmCtrl.vibrationEnabled.value) {
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
        }
      }

      // 🔊 Phát nhạc chuông
      final sound = alarmCtrl.selectedAlarmSound.value;
      if (sound != null) {
        try {
          await _audioPlayer.setUrl(sound.publicUrl);
          _audioPlayer.setVolume(alarmCtrl.alarmVolume.value);
          _audioPlayer.play();
        } catch (e) {
          print("❌ Lỗi phát chuông: $e");
        }
      }
    }
  }

  /// ⏹ Dừng báo thức
  void stopAlarm() {
    isAlarmRinging.value = false;
    Vibration.cancel();
    _audioPlayer.stop();

    final alarmCtrl = Get.find<AlarmController>();
    alarmCtrl.isTriggered.value = false; // ✅ Cho phép báo lại
  }

  /// 😴 Snooze báo thức X phút
  void snooze() {
    final alarmCtrl = Get.find<AlarmController>();
    final snoozeMin = alarmCtrl.snoozeMinutes.value;

    if (snoozeMin > 0) {
      final now = TimeOfDay.now();
      final snoozeTime = TimeOfDay(
        hour: (now.hour + ((now.minute + snoozeMin) ~/ 60)) % 24,
        minute: (now.minute + snoozeMin) % 60,
      );
      alarmCtrl.alarmTime.value = snoozeTime;
    }

    alarmCtrl.isTriggered.value = false; // ✅ cho phép báo lại
    stopAlarm(); // tắt chuông + vibration
  }

  /// 🔁 Gọi lại báo thức thủ công (dùng cho debug/test)
  Future<void> triggerAlarmManually() async {
    final alarmCtrl = Get.find<AlarmController>();
    final sound = alarmCtrl.selectedAlarmSound.value;
    isAlarmRinging.value = true;

    if (alarmCtrl.vibrationEnabled.value) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(pattern: [500, 1000, 500, 1000], repeat: 0);
      }
    }

    if (sound != null) {
      try {
        await _audioPlayer.setUrl(sound.publicUrl);
        _audioPlayer.setVolume(alarmCtrl.alarmVolume.value);
        _audioPlayer.play();
      } catch (e) {
        print("❌ Lỗi phát lại chuông sau snooze: $e");
      }
    }
  }
}