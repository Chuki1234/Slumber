import 'package:get/get.dart';
import 'package:slumber/app/modules/discover/views/discover_view.dart';
import '../controllers/discover_controller.dart';

class DiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscoverController>(() => DiscoverController());
  }
}