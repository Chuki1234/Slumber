import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sleeptracker_controller.dart';

class SleeptrackerView extends GetView<SleeptrackerController> {
  const SleeptrackerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SleeptrackerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SleeptrackerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
