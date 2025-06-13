import 'package:get/get.dart';
import 'package:slumber/app/modules/Alarm/controllers/alarm_controller.dart';
import '../../Bedtime/controllers/bedtime_controller.dart';
import '../controllers/sleeptracker_controller.dart';

class SleeptrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepTrackerController>(() => SleepTrackerController());
    Get.lazyPut<BedtimeController>(() => BedtimeController());
    Get.lazyPut<AlarmController>(() => AlarmController());
  }
}