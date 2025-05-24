import 'package:get/get.dart';

import '../controllers/sleeptracker_controller.dart';
import 'package:get/route_manager.dart';

class SleeptrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepTrackerController>(
      () => SleepTrackerController(),
    );
  }
}
