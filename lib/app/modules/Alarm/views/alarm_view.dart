import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/alarm_controller.dart';

class AlarmView extends GetView<AlarmController> {
  const AlarmView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1, // 👉 chuyển sang tab Alarm
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/Background.png', fit: BoxFit.cover),
            SafeArea(
              child: Column(
                children: [
                  // Tab bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                        const Expanded(
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white70,
                            indicatorColor: Colors.white,
                            tabs: [
                              Tab(text: 'Bed Time'),
                              Tab(text: 'Alarm'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Time Picker
                  Obx(() {
                    final time = controller.selectedTime.value;
                    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
                    final minute = time.minute.toString().padLeft(2, '0');
                    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$hour:$minute $period",
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple[300],
                            ),
                            onPressed: () => controller.pickTime(context),
                            child: const Text("Change Time"),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  // Alarm + Smart Alarm toggle
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: const Text("Alarm", style: TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Obx(() => SwitchListTile(
                      title: const Text("Smart Alarm", style: TextStyle(color: Colors.white)),
                      value: controller.isSmartAlarm.value,
                      onChanged: controller.toggleSmartAlarm,
                      activeColor: Colors.white,
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}