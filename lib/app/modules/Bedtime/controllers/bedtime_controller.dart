import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedtimeController extends GetxController {
  // Giờ đi ngủ
  var bedTime = TimeOfDay.now().obs;

  // Thời gian nhắc trước khi ngủ
  var remindBefore = const Duration(minutes: 5).obs;

  // Bật/tắt nhắc nhở
  var isReminderEnabled = true.obs;

  // Timer kiểm tra định kỳ
  Timer? _reminderTimer;

  // Tránh nhắc nhở lặp lại trong cùng một phút
  TimeOfDay? _lastReminderShownAt;

  /// Chọn giờ đi ngủ
  void pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: bedTime.value,
    );
    if (newTime != null) {
      bedTime.value = newTime;
      print('Giờ đi ngủ đã chọn: $newTime');
    }
  }

  /// Cập nhật khoảng thời gian nhắc
  void updateReminder(Duration duration) {
    remindBefore.value = duration;
    print('Cập nhật remindBefore: ${duration.inMinutes} phút');
  }

  /// Bật/tắt nhắc nhở
  void setReminderEnabled(bool enabled) {
    isReminderEnabled.value = enabled;
    print('Nhắc nhở: ${enabled ? 'Bật' : 'Tắt'}');
  }

  /// Bắt đầu kiểm tra nhắc nhở
  void startReminderLoop(BuildContext context) {
    _reminderTimer?.cancel();

    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isReminderEnabled.value) {
        print('Nhắc nhở đang tắt');
        return;
      }

      final now = TimeOfDay.now();
      final reminderTime = _getReminderTime();

      print('🕑 Bây giờ: ${now.format(context)} | Nhắc lúc: ${reminderTime.format(context)}');

      if (_isSameTime(reminderTime, now) &&
          !_isSameTime(_lastReminderShownAt, now)) {
        _lastReminderShownAt = now;
        _showReminderSnackbar(context);
      }
    });

    print('🔁 Đã bắt đầu vòng kiểm tra nhắc nhở');
  }

  /// Tính thời điểm cần nhắc
  TimeOfDay _getReminderTime() {
    final bed = bedTime.value;
    final totalMinutes = bed.hour * 60 + bed.minute;
    final reminderMinutes = remindBefore.value.inMinutes;
    final adjusted = (totalMinutes - reminderMinutes + 1440) % 1440;
    return TimeOfDay(hour: adjusted ~/ 60, minute: adjusted % 60);
  }

  /// So sánh thời gian giờ-phút
  bool _isSameTime(TimeOfDay? t1, TimeOfDay? t2) {
    if (t1 == null || t2 == null) return false;
    return t1.hour == t2.hour && t1.minute == t2.minute;
  }

  /// Hiển thị SnackBar nhắc nhở
  void _showReminderSnackbar(BuildContext context) {
    if (!context.mounted) return;
    Get.snackbar(
      '⏰ Nhắc nhở đi ngủ',
      'Đã đến giờ đi ngủ! Hãy chuẩn bị nghỉ ngơi.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.deepPurpleAccent,
      colorText: Colors.white,
    );
    print('🔔 Đã hiển thị nhắc nhở đi ngủ');
  }

  /// Dọn dẹp timer khi dispose
  @override
  void onClose() {
    _reminderTimer?.cancel();
    super.onClose();
  }
}