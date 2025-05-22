import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bedtime_controller.dart';

class BedtimeView extends GetView<BedtimeController> {
  const BedtimeView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/Background.png', fit: BoxFit.cover),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    const SizedBox(height: 32),
                    // Time Picker
                    Obx(() {
                      final time = controller.selectedTime.value;
                      final hour = time.hourOfPeriod.toString().padLeft(2, '0');
                      final minute = time.minute.toString().padLeft(2, '0');
                      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "$hour:$minute $period",
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple[400],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              icon: const Icon(Icons.access_time),
                              label: const Text("Change Time", style: TextStyle(fontSize: 16)),
                              onPressed: () => controller.pickTime(context),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 36),
                    // Discover
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Card(
                        color: Colors.deepPurple.shade800.withOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: const Text("Discover", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          onTap: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Remind me
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Card(
                        color: Colors.deepPurple.shade800.withOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: const Text("Remind me", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          trailing: const Text("5 minutes", style: TextStyle(color: Colors.white)),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}