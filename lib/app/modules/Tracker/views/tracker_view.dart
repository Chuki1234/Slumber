import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  String _getWeekday(int weekday) => ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][weekday - 1];
  String _getMonth(int m) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  void _startHold() {
    _isHolding = true;
    _holdTimer = Timer(const Duration(seconds: 3), () {
      if (_isHolding) Get.back(); // Quay lại SleeptrackerView và khôi phục BottomNavigationBar
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
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/Background.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                // Top info
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
                        style: const TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(date.value,
                        style: const TextStyle(fontSize: 16, color: Colors.white70)),
                  ],
                )),
                const Spacer(),

                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _optionTile(Icons.music_note, "Sound & Music", onTap: () {}),
                      const Divider(color: Colors.white30),
                      _optionTile(Icons.alarm, "Alarm", trailing: "04:30 - 05:00", onTap: () {}),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Wake up button
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Long press to wake up", style: TextStyle(color: Colors.white60, fontSize: 12)),
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

  Widget _optionTile(IconData icon, String label, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
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