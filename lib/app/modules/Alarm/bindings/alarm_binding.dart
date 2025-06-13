import 'package:get/get.dart';

import '../../Bedtime/controllers/bedtime_controller.dart';
import '../controllers/alarm_controller.dart';

class AlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlarmController>(
      () => AlarmController(),
    );
    Get.lazyPut<BedtimeController>(
        () => BedtimeController()); // Ensure BedtimeController is available
  }
}
