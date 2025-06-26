import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';

import '../../../../service/alarm_sound_service.dart';
import '../../../data/models/alarm_sound.dart';

class AlarmController extends GetxController {

  /// ⏰ Thời gian báo thức
  final Rx<TimeOfDay> alarmTime = TimeOfDay(hour: 7, minute: 0).obs;

  /// Trạng thái báo thức đã được kích hoạt chưa
  final isTriggered = false.obs;

  /// 🔉 Danh sách nhạc chuông từ Supabase
  var alarmSounds = <AlarmSound>[].obs;

  /// Nhạc chuông đã chọn
  var selectedAlarmSound = Rxn<AlarmSound>();

  /// Âm lượng báo thức (0.0 - 1.0)
  var alarmVolume = 1.0.obs;

  /// Có rung khi báo không
  var vibrationEnabled = true.obs;

  /// Smart Alarm offset (nếu có)
  var smartAlarmOffsetMinutes = 0.obs;

  /// Số phút hoãn lại khi snooze
  var snoozeMinutes = 5.obs;

  /// Audio player
  final _player = AudioPlayer();
  Timer? _previewTimer;

  /// Chọn thời gian báo thức mới
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: alarmTime.value,
    );
    if (picked != null && picked != alarmTime.value) {
      alarmTime.value = picked;
      isTriggered.value = false;
    }
  }

  /// Load danh sách âm thanh từ Supabase
  Future<void> loadAlarmSounds() async {
    final sounds = await AlarmSoundService().fetchAllSounds();
    alarmSounds.assignAll(sounds);
    if (selectedAlarmSound.value == null && sounds.isNotEmpty) {
      selectedAlarmSound.value = sounds.first;
    }
  }

  /// Nghe thử trong 5 giây
  Future<void> playPreview(String url) async {
    try {
      await _player.setUrl(url);
      await _player.setVolume(alarmVolume.value);
      await _player.play();

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

  /// Phát chuông khi đến giờ (loop)
  Future<void> playAlarmSound() async {
    try {
      final sound = selectedAlarmSound.value;
      if (sound == null) return;

      await _player.setUrl(sound.publicUrl);
      await _player.setLoopMode(LoopMode.one); // 🔁 lặp liên tục
      await _player.setVolume(alarmVolume.value);
      await _player.play();
    } catch (e) {
      print("❌ Alarm playback error: $e");
    }
  }

  /// Dừng báo thức
  void stopAlarmSound() {
    _player.stop();
    isTriggered.value = true; // ✅ khóa lại để không báo lại trong phút này
  }
  DateTime? _lastTriggerTime;
  /// Kiểm tra nếu đến giờ thì kích hoạt báo thức
  void checkAlarmAndTrigger(Function onTrigger) {
    final now = TimeOfDay.now();
    final alarm = alarmTime.value;

    final alreadyTriggeredThisMinute = _lastTriggerTime != null &&
        DateTime.now().difference(_lastTriggerTime!).inMinutes < 1;

    if (now.hour == alarm.hour &&
        now.minute == alarm.minute &&
        !alreadyTriggeredThisMinute) {
      _lastTriggerTime = DateTime.now(); // ghi nhận đã kêu
      onTrigger();
    }
  }
  void updateAlarmTime(TimeOfDay newTime) {
    alarmTime.value = newTime;
    isTriggered.value = false; // reset báo thức
  }

  @override
  void onClose() {
    _player.dispose();
    _previewTimer?.cancel();
    super.onClose();
  }
}