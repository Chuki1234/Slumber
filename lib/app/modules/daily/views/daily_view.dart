
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daily_controller.dart';

class DailyView extends GetView<DailyController> {
  const DailyView({super.key});

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
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    'Good evening, hope you have a nice day <3\n${controller.time.value}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
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
                            children: const [
                              Text('🛏 Bedtime 09:30', style: TextStyle(color: Colors.white)),
                              SizedBox(height: 4),
                              Text('\u23F0 Alarm 04:40 - 05:00', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Text('⏰ Goal', style: TextStyle(color: Colors.white54)),
                            const SizedBox(height: 4),
                            const Text('19 h 30 min', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Track now'),
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
                        const Icon(Icons.edit, color: Colors.white38)
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