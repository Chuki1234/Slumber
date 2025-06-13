import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlarmController extends GetxController {
  // Define alarmTime as an observable
  var alarmTime = TimeOfDay.now().obs;

  // Method to pick a new time
  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: alarmTime.value,
    );
    if (picked != null && picked != alarmTime.value) {
      alarmTime.value = picked;
    }
  }
}