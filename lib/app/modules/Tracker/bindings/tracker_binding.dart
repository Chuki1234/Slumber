import 'package:get/get.dart';

import '../controllers/tracker_controller.dart';

class TrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackerController>(
      () => TrackerController(),
    );
  }
}
