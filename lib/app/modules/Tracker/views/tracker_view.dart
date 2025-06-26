import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Alarm/bindings/alarm_binding.dart';
import '../../Alarm/views/alarm_view.dart';
import '../../discover/views/discover_view.dart';
import '../../discover/bindings/discover_binding.dart';
import '../../layout/controllers/layout_controller.dart';
import '../../sleeptracker/controllers/sleeptracker_controller.dart';

class TrackerView extends StatefulWidget {
  const TrackerView({super.key});

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {
  final controller = Get.find<SleepTrackerController>();
  final musicController = Get.find<LayoutController>();

  final RxString time = ''.obs;
  final RxString date = ''.obs;
  final RxDouble ambientNoise = (-41.0).obs;

  Timer? _clockTimer;
  Timer? _holdTimer;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _updateClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClock());
  }

  void _updateClock() {
    final now = DateTime.now();
    time.value = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    date.value = "${_getWeekday(now.weekday)}, ${_getMonth(now.month)} ${now.day}";
  }

  String _getWeekday(int weekday) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
  String _getMonth(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];

  void _startHold() {
    _isHolding = true;
    _holdTimer = Timer(const Duration(seconds: 1), () {
      if (_isHolding) Get.back();
    });
  }

  void _cancelHold() {
    _isHolding = false;
    _holdTimer?.cancel();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/Background.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.translate(
                          offset: const Offset(-17, 0),
                          child: Image.asset(
                            'assets/images/Logo.png',
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Obx(() => Text(
                        "Ambient noise\n${ambientNoise.value.toStringAsFixed(0)} dB",
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Obx(() => Column(
                  children: [
                    Text(
                      time.value,
                      style: const TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date.value,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _optionTile(
                        icon: Icons.music_note,
                        label: "Sound & Music",
                        subtitle: Obx(() {
                          final song = musicController.currentSong.value;
                          return Text(
                            song != null ? song.title : "No song playing",
                            style: const TextStyle(color: Colors.white60, fontSize: 14),
                          );
                        }),
                        trailingColor: Colors.grey,
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            Get.to(() =>  DiscoverView(fromTracker: true), binding: DiscoverBinding());
                          });
                        },
                      ),
                      const Divider(color: Colors.white30),
                      _optionTile(
                        icon: Icons.alarm,
                        label: "Alarm",
                        trailing: Obx(() {
                          final start = controller.alarmStart.value;
                          final offset = controller.smartAlarmOffsetMinutes.value;
                          final isSmartOn = controller.isSmartAlarmEnabled.value;

                          String format(TimeOfDay t) =>
                              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

                          late final String timeText;

                          if (!isSmartOn || offset == 0) {
                            timeText = format(start);
                          } else {
                            final totalMin = start.hour * 60 + start.minute + offset;
                            final end = TimeOfDay(
                              hour: (totalMin ~/ 60) % 24,
                              minute: totalMin % 60,
                            );
                            timeText = '${format(start)} - ${format(end)}';
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeText,
                                style: const TextStyle(color: Colors.white70, fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          );
                        }),
                        onTap: () => Get.to(() => const AlarmView(), binding: AlarmBinding()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onLongPressStart: (_) => _startHold(),
                        onLongPressEnd: (_) => _cancelHold(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Wake up",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Long press to wake up",
                        style: TextStyle(color: Colors.white60, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String label,
    Widget? trailing,
    Widget? subtitle,
    Color? trailingColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Icon(icon, color: Colors.grey),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: subtitle,
      trailing: trailing ?? Icon(Icons.chevron_right, color: trailingColor ?? Colors.white),
    );
  }
}