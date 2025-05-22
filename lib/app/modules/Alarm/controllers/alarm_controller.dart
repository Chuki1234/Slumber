import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmController extends GetxController {
  //TODO: Implement AlarmController
  final selectedTime = TimeOfDay(hour: 6, minute: 0).obs;
  final isSmartAlarm = false.obs;

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }

  void toggleSmartAlarm(bool value) {
    isSmartAlarm.value = value;
  }
}