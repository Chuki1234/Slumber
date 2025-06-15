import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';

class BedtimeView extends StatefulWidget {
  const BedtimeView({super.key});

  @override
  State<BedtimeView> createState() => _BedtimeViewState();
}

class _BedtimeViewState extends State<BedtimeView> {
  final controller = Get.find<SleepTrackerController>();
  bool isReminderEnabled = true;

  int selectedRemindHours = 0;
  int selectedRemindMinutes = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.2),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    'BedTime',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Obx(() {
                    final time = controller.bedTime.value;
                    final hour = time.hour.toString().padLeft(2, '0');
                    final minute = time.minute.toString().padLeft(2, '0');
                    return Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "$hour:$minute",
                            style: const TextStyle(
                              fontSize: 42,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            icon: const Icon(Icons.access_time),
                            label: const Text("Change Time", style: TextStyle(fontSize: 16)),
                            onPressed: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime: controller.bedTime.value,
                              );
                              if (!context.mounted) return;
                              if (newTime != null) {
                                controller.updateBedTime(newTime);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 48),
                // _optionListTile(
                //   title: 'Discover',
                //   trailing: const SizedBox(height: 24),
                // ),
                const SizedBox(height: 17),
                // Khối nhắc ngủ với Switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B174A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Dòng Remind me to sleep + Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Remind me to sleep',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: isReminderEnabled,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.deepPurpleAccent,
                              inactiveTrackColor: Colors.grey.shade700,
                              onChanged: (val) {
                                setState(() => isReminderEnabled = val);
                              },
                            ),
                          ],
                        ),

                        if (isReminderEnabled) ...[
                          const SizedBox(height: 12), // 👈 Thêm khoảng trước dòng phân cách
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 12), // 👈 Thêm khoảng sau dòng phân cách

                          GestureDetector(
                            onTap: () => _showRemindDialog(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Remind in advance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      selectedRemindHours > 0
                                          ? '${selectedRemindHours}h ${selectedRemindMinutes}min'
                                          : '${selectedRemindMinutes} min',
                                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionListTile({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFF2B174A),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null)
                Center(child: trailing)
              else
                const Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 17),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemindDialog(BuildContext context) {
    final hourOptions = [0, 1, 2, 3];
    final minuteOptions = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];

    int tempHour = selectedRemindHours;
    int tempMinute = selectedRemindMinutes;

    final hourController = FixedExtentScrollController(initialItem: hourOptions.indexOf(tempHour));
    final minuteController = FixedExtentScrollController(initialItem: minuteOptions.indexOf(tempMinute));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: const Color(0xFF1C103B),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Remind in advance',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeSelector(
                          controller: hourController,
                          options: hourOptions,
                          unit: 'h',
                          onChanged: (i) => setStateDialog(() => tempHour = hourOptions[i]),
                        ),
                        const SizedBox(width: 12),
                        _buildTimeSelector(
                          controller: minuteController,
                          options: minuteOptions,
                          unit: 'min',
                          onChanged: (i) => setStateDialog(() => tempMinute = minuteOptions[i]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedRemindHours = tempHour;
                            selectedRemindMinutes = tempMinute;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildTimeSelector({
    required List<int> options,
    required String unit,
    required Function(int) onChanged,
    required FixedExtentScrollController controller,
  }) {
    return SizedBox(
      height: 160,
      width: 100,
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: options.length,
              builder: (context, index) {
                final value = options[index];
                return Center(
                  child: Text(
                    '$value $unit',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}