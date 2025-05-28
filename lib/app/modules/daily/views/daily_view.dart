import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';
import '../controllers/daily_controller.dart';

class DailyView extends GetView<DailyController> {
  final sleepController = Get.find<SleepTrackerController>();
  DailyView({super.key});

  String calculateSleepDuration(TimeOfDay bedTime, TimeOfDay alarmStart) {
    final bedTimeInMinutes = bedTime.hour * 60 + bedTime.minute;
    final alarmTimeInMinutes = alarmStart.hour * 60 + alarmStart.minute;

    int durationInMinutes;
    if (alarmTimeInMinutes >= bedTimeInMinutes) {
      durationInMinutes = alarmTimeInMinutes - bedTimeInMinutes;
    } else {
      durationInMinutes = (24 * 60 - bedTimeInMinutes) + alarmTimeInMinutes;
    }

    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon';
    } else if (hour >= 18 && hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
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
            color: Colors.black.withOpacity(0.3),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Obx(() => Text(
                    controller.date.value,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 32),
                  const Text('Sleep goal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B1545),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                '🛏 Bedtime ${sleepController.formatTime(sleepController.bedTime.value)}',
                                style: const TextStyle(color: Colors.white),
                              )),
                              const SizedBox(height: 7),
                              Obx(() => Text(
                                '\u23F0 Alarm ${sleepController.formatTime(sleepController.alarmStart.value)}',
                                style: const TextStyle(color: Colors.white),
                              )),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Text('⏰ Goal', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 7),
                            Obx(() => Text(
                              calculateSleepDuration(
                                sleepController.bedTime.value,
                                sleepController.alarmStart.value,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Track now', style: TextStyle(color: Colors.deepPurpleAccent), textAlign: TextAlign.center),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('Diary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Wrap(
                          spacing: 8,
                          children: controller.selectedTags.map((t) => Chip(label: Text(t), backgroundColor: Colors.white24, labelStyle: const TextStyle(color: Colors.white))).toList(),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.pinkAccent),
                          onPressed: () => controller.openDialog(context),
                        )
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
                          child: Obx(() => Text(
                            controller.diaryText.value.isEmpty
                                ? 'Write something to record this special day...'
                                : controller.diaryText.value,
                            style: TextStyle(
                              color: controller.diaryText.value.isEmpty ? Colors.white54 : Colors.white,
                            ),
                          )),
                        ),
                        const Icon(Icons.edit, color: Colors.white)
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: const Text('Sleep now', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}