import 'package:get/get.dart';

import '../controllers/daily_controller.dart';

class DailyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyController>(
      () => DailyController(),
    );
  }
}
