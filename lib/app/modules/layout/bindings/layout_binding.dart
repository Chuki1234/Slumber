import 'package:get/get.dart';
import '../controllers/layout_controller.dart';
import '../../sleeptracker/views/sleeptracker_view.dart';
import '../../discover/views/discover_view.dart';
import '../../daily/views/daily_view.dart';
import '../../statistic/views/statistic_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(
          () => LayoutController(pages: const [
        SleeptrackerView(),
        DiscoverView(),
        DailyView(),
        StatisticView(),
      ]),
    );
  }
}
