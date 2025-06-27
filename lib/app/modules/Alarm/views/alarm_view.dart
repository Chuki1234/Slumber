import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Bedtime/views/bedtime_view.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';
import '../controllers/alarm_controller.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final controller = Get.find<SleepTrackerController>();
  final alarmController = Get.find<AlarmController>(); // ✅ THÊM DÒNG NÀY

  @override
  void initState() {
    super.initState();
    alarmController.loadAlarmSounds(); // ✅ GỌI LOAD NHẠC CHUÔNG
  }

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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    'Alarm',
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
                    final time = controller.alarmStart.value;
                    final hour = time.hour.toString().padLeft(2, '0');
                    final minute = time.minute.toString().padLeft(2, '0');
                    return Container(
                      width: 320,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 2.5,
                        ),
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
                                  initialTime: controller.alarmStart.value,
                                );
                                if (!context.mounted) return;

                                if (newTime != null) {
                                  // ✅ 1. Cập nhật vào AlarmController
                                  final alarmController = Get.find<AlarmController>();
                                  alarmController.updateAlarmTime(newTime);

                                  // ✅ 2. Đồng bộ lại vào SleepTrackerController
                                  controller.alarmStart.value = newTime;

                                  print("🕒 Đã cập nhật báo thức thành: ${newTime.hour}:${newTime.minute}");
                                }
                              }

                          ),
                        ],
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

// 👉 Sleep goal nằm giữa và căn giữa
                Center(
                  child: Obx(() {
                    final bedTime = controller.bedTime.value;
                    final alarmTime = controller.alarmStart.value;

                    int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
                    final diff = (toMinutes(alarmTime) - toMinutes(bedTime) + 1440) % 1440;
                    final hours = diff ~/ 60;
                    final minutes = diff % 60;
                    final goalText = minutes == 0 ? '$hours h' : '$hours h $minutes m';

                    return Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                            children: [
                              const TextSpan(text: 'Your sleep goal is '),
                              TextSpan(
                                text: goalText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7F7CFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Based on your bedtime and alarm time',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B174A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // 🎵 Alarm Ringtone
                        Obx(() {
                          final sound = alarmController.selectedAlarmSound.value;
                          return ListTile(
                            title: const Text("Alarm ringtone", style: TextStyle(color: Colors.white)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  sound?.name ?? "None",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right, color: Colors.white70),
                              ],
                            ),
                            onTap: () => _showRingtonePicker(context),
                          );
                        }),

                        const Divider(color: Colors.white24, height: 1),

                        // 🔊 Volume Slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.volume_mute, color: Colors.white70),
                              Expanded(
                                child: Obx(() {
                                  return Slider(
                                    value: controller.alarmVolume.value,
                                    min: 0.0,
                                    max: 1.0,
                                    divisions: 10,
                                    onChanged: (value) => controller.alarmVolume.value = value,
                                    activeColor: Colors.deepPurpleAccent,
                                    inactiveColor: Colors.white30,
                                  );
                                }),
                              ),
                              const Icon(Icons.volume_up, color: Colors.white70),
                            ],
                          ),
                        ),

                        const Divider(color: Colors.white24, height: 1),

                        // 📳 Vibration
                        Obx(() {
                          return SwitchListTile(
                            title: const Text("Vibration", style: TextStyle(color: Colors.white)),
                            value: controller.vibrationEnabled.value,
                            onChanged: (val) => controller.vibrationEnabled.value = val,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.deepPurpleAccent,
                            inactiveTrackColor: Colors.grey.shade700,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // _optionListTile(
                //   title: 'Bedtime',
                //   onTap: () {
                //     // Gọi controller nếu cần
                //     // Get.put(BedtimeController()); // nếu chưa dùng binding
                //     Get.to(() => const BedtimeView()); // nếu có binding thì thêm: , binding: BedtimeBinding()
                //   },
                // ),
                const SizedBox(height: 16),

                Obx(() {
                  final isEnabled = controller.isSmartAlarmEnabled.value;
                  final offset = controller.smartAlarmOffsetMinutes.value;
                  final start = controller.alarmStart.value;

                  final totalMin = (start.hour * 60 + start.minute - offset + 1440) % 1440;
                  final startSmart = TimeOfDay(hour: totalMin ~/ 60, minute: totalMin % 60);

                  String format(TimeOfDay t) =>
                      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

                  // 👉 Khi Smart Alarm TẮT → chỉ hiện một ListTile giống nút Alarm
                  if (!isEnabled) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B174A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Smart alarm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.deepPurpleAccent,
                              inactiveTrackColor: Colors.grey.shade700,
                              onChanged: (val) => controller.isSmartAlarmEnabled.value = val,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 👉 Khi Smart Alarm BẬT → full UI
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B174A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Smart alarm + switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Text('Smart alarm',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                                SizedBox(width: 6),
                                Icon(Icons.help_outline, size: 16, color: Colors.white54),
                              ],
                            ),
                            Switch(
                              value: isEnabled,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.deepPurpleAccent,
                              onChanged: (val) => controller.isSmartAlarmEnabled.value = val,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () => _showSmartAlarmDialog(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Wake up period',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                              Row(
                                children: [
                                  Text('$offset min',
                                      style: const TextStyle(fontSize: 16, color: Colors.white70)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'The smart alarm will wake you up at the best time between ${format(startSmart)} - ${format(start)}',
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () => _showSnoozeDialog(context),
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B174A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Snooze',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Obx(() {
                            final snooze = alarmController.snoozeMinutes.value;                            return Row(
                              children: [
                                Text(
                                  snooze == 0 ? 'Off' : '$snooze min',
                                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              ),
            )
        ],
      ),
    );
  }

  Widget _optionListTile({required String title, Widget? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF2B174A),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing ??
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  void _showRingtonePicker(BuildContext context) {
    final controller = Get.find<AlarmController>();

    int tempIndex = controller.alarmSounds.indexWhere((s) =>
    s.id == controller.selectedAlarmSound.value?.id);
    if (tempIndex == -1) tempIndex = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: const Color(0xFF1C103B),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: controller.alarmSounds.isEmpty
                    ? const SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                  ),
                )
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Alarm ringtone',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 24),

                    // Vòng chọn nhạc chuông
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.15),
                      ),
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        diameterRatio: 1.2,
                        controller: FixedExtentScrollController(initialItem: tempIndex),
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setStateDialog(() {
                            tempIndex = index;
                          });
                          controller.playPreview(controller.alarmSounds[index].publicUrl);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: controller.alarmSounds.length,
                          builder: (context, index) {
                            final sound = controller.alarmSounds[index];
                            return Center(
                              child: Text(
                                sound.name,
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.stopPreview();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.selectedAlarmSound.value = controller.alarmSounds[tempIndex];
                            controller.stopPreview();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSmartAlarmDialog(BuildContext context) {
    final minuteOptions = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];
    int tempMinute = controller.smartAlarmOffsetMinutes.value;
    final minuteController = FixedExtentScrollController(
      initialItem: minuteOptions.indexOf(tempMinute),
    );
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
                    'Smart alarm period',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.15),
                    ),
                    child: _buildTimeSelector(
                      controller: minuteController,
                      options: minuteOptions,
                      unit: 'min',
                      onChanged: (i) => setStateDialog(() => tempMinute = minuteOptions[i]),
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
                          controller.updateSmartAlarmOffset(tempMinute);
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

  void _showSnoozeDialog(BuildContext context) {
    final snoozeOptions = [0, 5, 10, 15, 20, 25, 30]; // bạn có thể thêm nhiều hơn
    int tempSnooze = controller.snoozeMinutes.value;
    final controllerScroll = FixedExtentScrollController(
      initialItem: snoozeOptions.indexOf(tempSnooze),
    );

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
                    'Snooze',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.15),
                    ),
                    child: _buildTimeSelector(
                      controller: controllerScroll,
                      options: snoozeOptions,
                      unit: 'min',
                      onChanged: (i) => setStateDialog(() => tempSnooze = snoozeOptions[i]),
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
                          alarmController.snoozeMinutes.value = tempSnooze;                          Navigator.pop(context);
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
                    value == 0 ? 'Off' : '$value $unit',
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
