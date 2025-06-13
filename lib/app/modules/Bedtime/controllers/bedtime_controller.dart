import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedtimeController extends GetxController {
  var bedTime = TimeOfDay.now().obs;

  void pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: bedTime.value,
    );
    if (newTime != null) {
      bedTime.value = newTime;
    }
  }
}