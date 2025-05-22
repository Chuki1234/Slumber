import 'package:get/get.dart';

import '../controllers/bedtime_controller.dart';

class BedtimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BedtimeController>(
      () => BedtimeController(),
    );
  }
}
