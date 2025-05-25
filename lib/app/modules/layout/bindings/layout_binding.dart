import 'package:get/get.dart';
import 'package:slumber/app/modules/daily/controllers/daily_controller.dart';
import 'package:slumber/app/modules/discover/controllers/discover_controller.dart';
import 'package:slumber/app/modules/statistic/controllers/statistic_controller.dart';
import '../../Alarm/controllers/alarm_controller.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';
import '../controllers/layout_controller.dart';
import '../../sleeptracker/views/sleeptracker_view.dart';
import '../../discover/views/discover_view.dart';
import '../../daily/views/daily_view.dart';
import '../../statistic/views/statistic_view.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(
          () => LayoutController(pages: [
        SleeptrackerView(),
        DiscoverView(),
        DailyView(),
        StatisticView(),
      ]),
    );
    Get.lazyPut<SleepTrackerController>(() => SleepTrackerController());
    Get.lazyPut<DiscoverController>(() => DiscoverController());
    Get.lazyPut<DailyController>(() => DailyController());
    Get.lazyPut<StatisticController>(() => StatisticController());
    Get.lazyPut<AlarmController>(() => AlarmController());
  }
}