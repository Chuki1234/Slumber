import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Alarm/views/alarm_view.dart';
import '../../discover/views/discover_view.dart';
import '../../discover/bindings/discover_binding.dart';

class TrackerView extends StatefulWidget {
  const TrackerView({super.key});

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {
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

  String _getWeekday(int weekday) => ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][weekday - 1];
  String _getMonth(int m) => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m - 1];

  void _startHold() {
    _isHolding = true;
    _holdTimer = Timer(const Duration(seconds: 3), () {
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/Background.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Slumber", style: TextStyle(color: Colors.white, fontSize: 14)),
                      Obx(() => Text(
                        "Ambient noise\n${ambientNoise.value.toStringAsFixed(0)} dB",
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Clock center
                Expanded(
                  child: Obx(() => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        time.value,
                        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  )),
                ),

                // Nút và tùy chọn
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _optionTile(
                        icon: Icons.music_note,
                        label: "Sound & Music",
                        onTap: () => Get.to(() => DiscoverView(fromTracker: true), binding: DiscoverBinding()),
                      ),
                      const Divider(color: Colors.white30),
                      _optionTile(
                        icon: Icons.alarm,
                        label: "Alarm",
                        trailing: "04:30 - 05:00",
                        onTap: () => Get.to(() => const AlarmView()),
                      ),
                      const SizedBox(height: 32),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Long press to wake up", style: TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
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
    String? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: trailing != null
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      )
          : const Icon(Icons.chevron_right, color: Colors.white),
    );
  }
}