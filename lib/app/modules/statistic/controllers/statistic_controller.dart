import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatisticController extends GetxController {
  /// Ngày đang chọn trong tuần
  Rx<DateTime> selectedDate = DateTime.now().obs;

  /// Tuần offset tính từ tuần hiện tại (0 = tuần này, +1 tuần sau, -1 tuần trước)
  RxInt weekOffset = 0.obs;

  /// Điểm số giấc ngủ
  RxInt sleepScore = 85.obs;

  /// Thời gian nằm trên giường (hiển thị)
  RxString timeInBed = '7h 45m'.obs;

  /// Chất lượng giấc ngủ
  RxString sleepQuality = 'Good'.obs;

  /// Dữ liệu tiếng ồn trong tuần hiện tại (max/min)
  RxList<Map<String, dynamic>> weeklyNoise = <Map<String, dynamic>>[].obs;

  // Dưới weeklyNoise
  RxBool isBedtimeMode = true.obs;
  RxInt selectedMode = 0.obs;

  final List<Map<String, dynamic>> bedtimeData = [
    {"day": "Sun", "time": "01:48"},
    {"day": "Mon", "time": "02:12"},
    {"day": "Tue", "time": "01:58"},
    {"day": "Wed", "time": "02:30"},
    {"day": "Thu", "time": "01:55"},
    {"day": "Fri", "time": "03:40"},
    {"day": "Sat", "time": "02:10"},
  ];

  final List<Map<String, dynamic>> wakeupData = [
    {"day": "Sun", "time": "07:00"},
    {"day": "Mon", "time": "06:40"},
    {"day": "Tue", "time": "08:15"},
    {"day": "Wed", "time": "07:30"},
    {"day": "Thu", "time": "06:50"},
    {"day": "Fri", "time": "08:00"},
    {"day": "Sat", "time": "09:10"},
  ];

  /// Khởi tạo dữ liệu mẫu khi controller được gọi
  @override
  void onInit() {
    super.onInit();
    loadWeeklyNoiseData();
  }

  void goToToday() {
    selectedDate.value = DateTime.now();
    weekOffset.value = 0;
    loadWeeklyNoiseData();
  }

  void nextWeek() {
    weekOffset.value++;
    loadWeeklyNoiseData();
  }

  void previousWeek() {
    weekOffset.value--;
    loadWeeklyNoiseData();
  }

  /// Nạp dữ liệu mẫu cho bar chart max/min noise trong 7 ngày của tuần hiện tại
  void loadWeeklyNoiseData() {
    final today = DateTime.now();
    final baseDate = today.subtract(Duration(days: today.weekday - 1));
    final startDate = baseDate.add(Duration(days: weekOffset.value * 7));

    // Ví dụ dữ liệu tiếng ồn theo từng ngày
    final List<Map<String, dynamic>> generated = List.generate(7, (i) {
      final d = startDate.add(Duration(days: i));
      final day = DateFormat('EEE').format(d);
      final max = 50 + i * 3;
      final min = 25 + i * 2;
      return {
        'day': day,
        'max': max,
        'min': min,
        'date': d,
      };
    });

    weeklyNoise.assignAll(generated);
  }




}