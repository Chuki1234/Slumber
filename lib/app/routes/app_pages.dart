import 'package:get/get.dart';

import '../modules/Alarm/bindings/alarm_binding.dart';
import '../modules/Alarm/views/alarm_view.dart';
import '../modules/Bedtime/bindings/bedtime_binding.dart';
import '../modules/Bedtime/views/bedtime_view.dart';
import '../modules/daily/bindings/daily_binding.dart';
import '../modules/daily/views/daily_view.dart';
import '../modules/discover/bindings/discover_binding.dart';
import '../modules/discover/views/discover_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/layout/bindings/layout_binding.dart';
import '../modules/layout/views/layout_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/sleeptracker/bindings/sleeptracker_binding.dart';
import '../modules/sleeptracker/views/sleeptracker_view.dart';
import '../modules/statistic/bindings/statistic_binding.dart';
import '../modules/statistic/views/statistic_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT,
      page: () => LayoutView(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SLEEPTRACKER,
      page: () => SleeptrackerView(),
      binding: SleeptrackerBinding(),
    ),
    GetPage(
      name: _Paths.DISCOVER,
      page: () => const DiscoverView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: _Paths.DAILY,
      page: () => DailyView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIC,
      page: () => const StatisticView(),
      binding: StatisticBinding(),
    ),
    GetPage(
        name: AppRoutes.home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
        name: AppRoutes.bedtime,
        page: () => BedtimeView(),
        binding: BedtimeBinding()),
    GetPage(
        name: AppRoutes.alarm,
        page: () => AlarmView(),
        binding: AlarmBinding()),
    GetPage(
      name: _Paths.ALARM,
      page: () => const AlarmView(),
      binding: AlarmBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
