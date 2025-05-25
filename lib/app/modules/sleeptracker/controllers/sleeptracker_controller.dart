import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SleepTrackerController extends GetxController {
  final bedTime = TimeOfDay(hour: 19, minute: 55).obs; // 7:55 PM
  final alarmStart = TimeOfDay(hour: 6, minute: 0).obs; // 6:00 AM
  final alarmEnd = TimeOfDay(hour: 6, minute: 15).obs; // 6:15 AM

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
    alarmEnd.value = newTime;
  }
}