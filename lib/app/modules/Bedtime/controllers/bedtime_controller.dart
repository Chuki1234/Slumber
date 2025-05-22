import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedtimeController extends GetxController {
  //TODO: Implement BedtimeController

  final count = 0.obs;
  @override
  final selectedTime = TimeOfDay(hour: 22, minute: 0).obs;

  void pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
    }
  }
}