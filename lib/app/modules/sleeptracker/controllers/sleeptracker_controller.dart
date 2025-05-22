import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SleeptrackerController extends GetxController {
  final bedTime = TimeOfDay(hour: 22, minute: 0).obs;
  final alarmStart = TimeOfDay(hour: 6, minute: 0).obs;
  final alarmEnd = TimeOfDay(hour: 6, minute: 15).obs;

  void setBedTime(TimeOfDay time) {
    bedTime.value = time;
  }

  void setAlarmStart(TimeOfDay time) {
    alarmStart.value = time;
  }

  void setAlarmEnd(TimeOfDay time) {
    alarmEnd.value = time;
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Returns the sleep duration between bedTime and alarmStart
  Duration get sleepDuration {
    final bed = bedTime.value;
    final wake = alarmStart.value;
    final bedMinutes = bed.hour * 60 + bed.minute;
    final wakeMinutes = wake.hour * 60 + wake.minute;
    int diff = wakeMinutes - bedMinutes;
    if (diff <= 0) diff += 24 * 60;
    return Duration(minutes: diff);
  }

  /// Returns a formatted string like "8h 0m"
  String get sleepDurationString {
    final d = sleepDuration;
    return '${d.inHours}h ${d.inMinutes % 60}m';
  }
}