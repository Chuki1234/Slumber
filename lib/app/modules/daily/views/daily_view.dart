import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Tracker/views/tracker_view.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';
import '../controllers/daily_controller.dart';

class DailyView extends GetView<DailyController> {
  final sleepController = Get.find<SleepTrackerController>();
  DailyView({super.key});

  String calculateSleepDuration(TimeOfDay bedTime, TimeOfDay alarmStart) {
    final bedTimeInMinutes = bedTime.hour * 60 + bedTime.minute;
    final alarmTimeInMinutes = alarmStart.hour * 60 + alarmStart.minute;
    int durationInMinutes = alarmTimeInMinutes - bedTimeInMinutes;
    if (durationInMinutes < 0) durationInMinutes += 1440;
    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;
    return minutes == 0
        ? '${hours}:00'
        : '${hours}:${minutes.toString().padLeft(2, '0')}';
  }

  String _formatTime24(TimeOfDay t) {
    return t.minute == 0
        ? '${t.hour}:00'
        : '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
  }

  List<Widget> buildDateSelector() {
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (i) {
      final date = weekStart.add(Duration(days: i));
      final isSelected =
          controller.selectedDate.value.day == date.day &&
          controller.selectedDate.value.month == date.month &&
          controller.selectedDate.value.year == date.year;

      return GestureDetector(
        onTap: () {
          controller.selectedDate.value = date;
          controller.loadDiaryForDate(date);
        },
        child: Container(
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Colors.white12,
            borderRadius: BorderRadius.circular(12),
            border:
                isSelected
                    ? Border.all(color: Colors.cyanAccent, width: 2)
                    : null,
          ),
          child: Column(
            children: [
              Text(
                DateFormat('EEE').format(date).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                '${date.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Text(
                                  controller.date.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            collapsedIconColor: Colors.transparent,
                            iconColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            maintainState: true,
                            children: [
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 64,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: buildDateSelector(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Good night, hope you have a nice day <3',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 24,
                          fontFamily: 'Georama',
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Sleep goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B1545),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Text(
                                      '🛏 Bedtime ${_formatTime24(sleepController.bedTime.value)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => Text(
                                      '⏰ Alarm ${_formatTime24(sleepController.alarmStart.value)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: Colors.white24,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '⏰ Goal',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => Text(
                                      calculateSleepDuration(
                                        sleepController.bedTime.value,
                                        sleepController.alarmStart.value,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Diary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                final tags = controller.selectedTags;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sleep notes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    tags.isEmpty
                                        ? const SizedBox()
                                        : Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children:
                                              tags.map((tag) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                  ],
                                );
                              }),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.pinkAccent,
                              ),
                              onPressed:
                                  () => controller.showTagDialog(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.diaryText.value.isEmpty
                                      ? 'Write something to record this special day...'
                                      : controller.diaryText.value,
                                  style: TextStyle(
                                    color:
                                        controller.diaryText.value.isEmpty
                                            ? Colors.white54
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed:
                                  () => controller.editDiaryText(context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const TrackerView());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            minimumSize: const Size.fromHeight(56), // chiều cao chuẩn như daily_view
                            padding: EdgeInsets.zero, // KHÔNG thêm padding để tránh khác nhau
                          ),
                          child: const Text(
                            'Sleep now',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
