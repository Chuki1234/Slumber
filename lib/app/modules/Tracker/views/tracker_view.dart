import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sleeptracker/views/sleeptracker_view.dart';

class TrackerView extends StatefulWidget {
  const TrackerView({super.key});

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {
  final RxString time = ''.obs;
  final RxString date = ''.obs;
  final RxDouble ambientNoise = (-41.0).obs; // giá trị giả định

  Timer? _timer;
  bool _isHolding = false;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    time.value = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    date.value = "${_getWeekday(now.weekday)}, ${_formatDate(now)}";
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[weekday - 1];
  }

  String _formatDate(DateTime dt) {
    return "${_month(dt.month)} ${dt.day}";
  }

  String _month(int month) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return m[month - 1];
  }

  void _startHold() {
    _isHolding = true;
    _holdTimer = Timer(const Duration(seconds: 3), () {
      if (_isHolding) {
        Get.off(() => SleeptrackerView());
      }
    });
  }

  void _cancelHold() {
    _isHolding = false;
    _holdTimer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/Background.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                // Logo + Ambient Noise
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Slumber", style: TextStyle(color: Colors.white)),
                      Obx(() => Text(
                        "Ambient noise\n${ambientNoise.value.toStringAsFixed(0)} dB",
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
                      )),
                    ],
                  ),
                ),

                const Spacer(),

                // Clock
                Obx(() => Column(
                  children: [
                    Text(time.value,
                        style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(date.value,
                        style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                )),

                const Spacer(),

                // Music + Alarm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _optionItem(icon: Icons.music_note, label: "Sound & Music", onTap: () {}),
                      const Divider(color: Colors.white30),
                      _optionItem(
                        icon: Icons.alarm,
                        label: "Alarm",
                        trailing: "04:30 - 05:00",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Wake Up button
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
                            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Long press to wake up",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
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

  Widget _optionItem({required IconData icon, required String label, String? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.white10,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: trailing != null
          ? Text(trailing, style: const TextStyle(color: Colors.white70, fontSize: 14))
          : const Icon(Icons.chevron_right, color: Colors.white),
    );
  }
}