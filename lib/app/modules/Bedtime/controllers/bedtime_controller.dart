import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../sleeptracker/controllers/sleeptracker_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BedtimeController extends GetxController {
  var bedTime = TimeOfDay.now().obs;
  var remindBefore = const Duration(minutes: 30).obs;
  var isReminderEnabled = true.obs;

  Timer? _reminderTimer;
  TimeOfDay? _lastReminderShownAt;
  Future<void> saveBedTime(TimeOfDay t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bed_hour', t.hour);
    await prefs.setInt('bed_minute', t.minute);
  }
  /// Cập nhật giờ đi ngủ và khởi động lại vòng nhắc
  void updateBedTime(TimeOfDay newTime, BuildContext context) {
    bedTime.value = newTime;
    saveBedTime(newTime);

    // Đồng bộ cho SleepTracker
    final sleepCtrl = Get.find<SleepTrackerController>();
    sleepCtrl.bedTime.value = newTime;

    startReminderLoop(context);
  }



  /// Cập nhật khoảng thời gian nhắc và khởi động lại vòng nhắc
  void updateReminder(Duration duration, BuildContext context) {
    remindBefore.value = duration;
    print('🔔 Cập nhật remindBefore: ${duration.inMinutes} phút');
    startReminderLoop(context);
  }

  /// Bật/tắt nhắc nhở
  void setReminderEnabled(bool enabled) {
    isReminderEnabled.value = enabled;
    print('✅ Nhắc nhở: ${enabled ? 'Bật' : 'Tắt'}');
  }

  /// Vòng kiểm tra nhắc nhở
  void startReminderLoop(BuildContext context) {
    _reminderTimer?.cancel();

    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isReminderEnabled.value) {
        print('❌ Nhắc nhở đang tắt');
        return;
      }

      final now = TimeOfDay.now();
      final reminderTime = _getReminderTime();

      // Log chi tiết mỗi phút
      print('--------------------------');
      print('🕓 Hiện tại     : ${_formatTime(now)}');
      print('🛌 Giờ đi ngủ   : ${_formatTime(bedTime.value)}');
      print('🔔 Nhắc trước  : ${remindBefore.value.inMinutes} phút');
      print('⏰ Nhắc lúc     : ${_formatTime(reminderTime)}');
      print('--------------------------');

      if (_isSameTime(reminderTime, now) &&
          !_isSameTime(_lastReminderShownAt, now)) {
        print('✅ Đã đến thời điểm cần nhắc!');
        _lastReminderShownAt = now;
        _showReminderSnackbar(context);
      } else {
        print('⏱️ Chưa đến giờ nhắc hoặc đã nhắc rồi.');
      }
    });

    print('🔁 Đã khởi động vòng kiểm tra nhắc nhở');
  }

  /// Tính thời điểm cần nhắc
  TimeOfDay _getReminderTime() {
    final bed = bedTime.value;
    final totalMinutes = bed.hour * 60 + bed.minute;
    final reminderMinutes = remindBefore.value.inMinutes;
    final adjusted = (totalMinutes - reminderMinutes + 1440) % 1440;
    return TimeOfDay(hour: adjusted ~/ 60, minute: adjusted % 60);
  }

  /// So sánh giờ và phút
  bool _isSameTime(TimeOfDay? t1, TimeOfDay? t2) {
    if (t1 == null || t2 == null) return false;
    return t1.hour == t2.hour && t1.minute == t2.minute;
  }

  /// Hiển thị nhắc nhở (SnackBar)

  void _showReminderSnackbar(BuildContext context) {
    if (!context.mounted) return;

    // 🔊 Phát âm thanh cảnh báo
    final player = AssetsAudioPlayer.newPlayer();
    player.open(
      Audio("assets/sounds/bedtime_alert.mp3"), // Đường dẫn đến file âm thanh
      autoStart: true,
      showNotification: false,
    );

    // 📢 Hiện Snackbar
    Get.snackbar(
      '⏰ Nhắc nhở đi ngủ',
      'Sắp đến giờ đi ngủ rồi! Hãy chuẩn bị nghỉ ngơi nha 😴',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.deepPurpleAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );

    print('🔔 Đã phát âm + hiện nhắc nhở');
  }


  /// Format TimeOfDay thành HH:mm
  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Dọn dẹp khi controller bị hủy
  @override
  void onClose() {
    _reminderTimer?.cancel();
    super.onClose();
  }
}
