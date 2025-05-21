import 'package:get/get.dart';

import '../controllers/sleeptracker_controller.dart';

class SleeptrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleeptrackerController>(
      () => SleeptrackerController(),
    );
  }
}
