import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sleeptracker_controller.dart';

class SleeptrackerView extends GetView<SleepTrackerController> {
  SleeptrackerView({super.key});

  int? _draggingHandle; // 0: bedTime, 1: alarmStart

  @override
  Widget build(BuildContext context) {
    const size = 320.0;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SLEEP TRACKER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Obx(
                      () => GestureDetector(
                    onPanStart: (details) => _onPanStart(details.localPosition, size),
                    onPanUpdate: (details) => _onPanUpdate(details.localPosition, size),
                    onPanEnd: (_) => _draggingHandle = null,
                    child: CustomPaint(
                      size: const Size(size, size),
                      painter: _SleepClockPainter(
                        bedTime: controller.bedTime.value,
                        alarmStart: controller.alarmStart.value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      _buildTimeRow(
                        icon: Icons.brightness_3,
                        label: 'Bedtime',
                        time: controller.bedTime,
                        color: const Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white),
                      const SizedBox(height: 16),
                      _buildTimeRow(
                        icon: Icons.notifications,
                        label: 'Alarm',
                        time: controller.alarmStart,
                        color: const Color(0xFFFACC15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Handle sleep now action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Sleep Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required Rx<TimeOfDay> time,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        Row(
          children: [
            Obx(() => Text(
              controller.formatTime(time.value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  void _onPanStart(Offset localPos, double size) {
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 * 0.8;
    final bedTimeAngle = _timeToAngle(controller.bedTime.value);
    final alarmStartAngle = _timeToAngle(controller.alarmStart.value);

    final bedTimePos = center + Offset(radius * math.cos(bedTimeAngle), radius * math.sin(bedTimeAngle));
    final alarmStartPos = center + Offset(radius * math.cos(alarmStartAngle), radius * math.sin(alarmStartAngle));

    final distToBed = (localPos - bedTimePos).distance;
    final distToAlarm = (localPos - alarmStartPos).distance;

    if (distToBed < 40 && distToBed < distToAlarm) {
      _draggingHandle = 0;
    } else if (distToAlarm < 40) {
      _draggingHandle = 1;
    } else {
      _draggingHandle = null;
    }

    if (_draggingHandle != null) {
      _onPanUpdate(localPos, size);
    }
  }

  void _onPanUpdate(Offset localPos, double size) {
    if (_draggingHandle == null) return;
    final center = Offset(size / 2, size / 2);
    final angle = (math.atan2(localPos.dy - center.dy, localPos.dx - center.dx) + 2 * math.pi) % (2 * math.pi);
    final adjustedAngle = (angle + math.pi / 2) % (2 * math.pi); // Adjust for 12 AM at the top
    final totalMinutes = (adjustedAngle / (2 * math.pi) * 1440).round() % 1440;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    final newTime = TimeOfDay(hour: hour, minute: minute);

    if (_draggingHandle == 0) {
      controller.bedTime.value = newTime;
    } else {
      controller.alarmStart.value = newTime;
    }
  }

  double _timeToAngle(TimeOfDay t) {
    final minutes = t.hour * 60 + t.minute;
    final angle = (minutes / 1440) * 2 * math.pi;
    return (angle - math.pi / 2) % (2 * math.pi); // Adjust for 12 AM at the top
  }
}

class _SleepClockPainter extends CustomPainter {
  final TimeOfDay bedTime;
  final TimeOfDay alarmStart;

  _SleepClockPainter({
    required this.bedTime,
    required this.alarmStart,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    final backgroundPaint = Paint()..color = Colors.grey.shade800;
    canvas.drawCircle(center, radius, backgroundPaint);

    final outerRingPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawCircle(center, radius + 20, outerRingPaint);

    final hourTickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final hourTickLength = radius * 0.1;
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 - math.pi / 2; // Adjust for 12 AM at the top
      final start = center + Offset(radius * math.cos(angle), radius * math.sin(angle));
      final end = center + Offset((radius - hourTickLength) * math.cos(angle), (radius - hourTickLength) * math.sin(angle));
      canvas.drawLine(start, end, hourTickPaint);
    }

    final textPainter = (String text) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return tp;
    };
    final numberAngles = List.generate(8, (i) => i * math.pi / 4 - math.pi / 2); // Adjust for 12 AM at the top
    final numberLabels = ['12 AM', '3 AM', '6 AM', '9 AM', '12 PM', '3 PM', '6 PM', '9 PM'];
    for (int i = 0; i < 8; i++) {
      final tp = textPainter(numberLabels[i]);
      final pos = center + Offset((radius + 30) * math.cos(numberAngles[i]), (radius + 30) * math.sin(numberAngles[i]));
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }

    final bedAngle = _timeToAngle(bedTime);
    final alarmAngle = _timeToAngle(alarmStart);
    double sweep = (alarmAngle - bedAngle) % (2 * math.pi);
    if (sweep < 0) sweep += 2 * math.pi;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [Colors.yellow, Colors.green, Colors.blue, Colors.indigo],
        startAngle: bedAngle,
        endAngle: bedAngle + sweep,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      bedAngle,
      sweep,
      false,
      arcPaint,
    );

    _drawHandle(canvas, center, radius, bedAngle, Colors.blueAccent, Icons.brightness_3);
    _drawHandle(canvas, center, radius, alarmAngle, Colors.pinkAccent, Icons.sunny);
  }

  void _drawHandle(Canvas canvas, Offset center, double radius, double angle, Color color, IconData icon) {
    final pos = center + Offset(radius * math.cos(angle), radius * math.sin(angle));
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(pos + const Offset(2, 2), 16, shadowPaint);
    final handlePaint = Paint()..color = color;
    canvas.drawCircle(pos, 16, handlePaint);
    final builder = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: 20, fontFamily: icon.fontFamily, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    builder.paint(canvas, pos - Offset(builder.width / 2, builder.height / 2));
  }

  double _timeToAngle(TimeOfDay t) {
    final minutes = t.hour * 60 + t.minute;
    return (minutes / 1440) * 2 * math.pi - math.pi / 2; // Adjust for 12 AM at the top
  }

  @override
  bool shouldRepaint(covariant _SleepClockPainter oldDelegate) {
    return oldDelegate.bedTime != bedTime || oldDelegate.alarmStart != alarmStart;
  }
}