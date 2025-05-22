import 'package:get/get.dart';

import '../controllers/daily_controller.dart';

class SleepDiaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyController>(() => DailyController());
  }
}