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

  // Trạng thái để tránh hiển thị nhiều lần cùng 1 phút
  TimeOfDay? _lastReminderShownAt;

  /// Chọn giờ đi ngủ từ time picker
  void pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: bedTime.value,
    );
    if (newTime != null) {
      bedTime.value = newTime;
    }
  }

  /// Cập nhật thời gian nhắc trước
  void updateReminder(Duration duration) {
    remindBefore.value = duration;
  }

  /// Cập nhật trạng thái bật/tắt nhắc
  void setReminderEnabled(bool enabled) {
    isReminderEnabled.value = enabled;
  }

  /// Bắt đầu kiểm tra giờ nhắc
  void startReminderLoop(BuildContext context) {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!isReminderEnabled.value) return;

      final now = TimeOfDay.now();
      final reminderTime = _getReminderTime();

      // Chỉ hiển thị nếu trùng giờ và chưa hiện trong phút này
      if (_isSameTime(reminderTime, now) &&
          !_isSameTime(_lastReminderShownAt, now)) {
        _lastReminderShownAt = now;
        _showReminderSnackbar(context);
      }
    });
  }

  /// Tính giờ nhắc trước giờ ngủ
  TimeOfDay _getReminderTime() {
    final bed = bedTime.value;
    final totalMinutes = bed.hour * 60 + bed.minute;
    final reminderMinutes = remindBefore.value.inMinutes;
    final adjusted = (totalMinutes - reminderMinutes + 1440) % 1440;
    return TimeOfDay(hour: adjusted ~/ 60, minute: adjusted % 60);
  }

  /// So sánh 2 thời điểm giờ:phút
  bool _isSameTime(TimeOfDay? t1, TimeOfDay? t2) {
    if (t1 == null || t2 == null) return false;
    return t1.hour == t2.hour && t1.minute == t2.minute;
  }

  /// Hiển thị nhắc nhở dạng SnackBar
  void _showReminderSnackbar(BuildContext context) {
    if (!context.mounted) return;
    Get.snackbar(
      'Nhắc nhở đi ngủ',
      'Đã đến giờ đi ngủ! Hãy chuẩn bị nghỉ ngơi.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.deepPurpleAccent,
      colorText: Colors.white,
    );
  }

  /// Hủy Timer khi dispose
  @override
  void onClose() {
    _reminderTimer?.cancel();
    super.onClose();
  }
}