import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/daily_controller.dart';

class DailyView extends GetView<DailyController> {
  const DailyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DailyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DailyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
