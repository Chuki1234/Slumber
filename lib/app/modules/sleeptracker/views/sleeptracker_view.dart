import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Alarm/controllers/alarm_controller.dart';
import '../../Alarm/views/alarm_view.dart';
import '../../Bedtime/controllers/bedtime_controller.dart';
import '../../Bedtime/views/bedtime_view.dart';
import '../../Tracker/views/tracker_view.dart';
import '../controllers/sleeptracker_controller.dart';

class SleeptrackerView extends GetView<SleepTrackerController> {
  SleeptrackerView({super.key});

  int? _draggingHandle; // 0 = bedTime, 1 = alarmStart
  double? _startAngle;

  static const int _minDiffMinutes = 180; // 1/8 vòng = 3 giờ

  @override
  Widget build(BuildContext context) {
    const size = 320.0;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Background.png', fit: BoxFit.cover),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.15), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
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
                        onPanStart: (d) => _onPanStart(d.localPosition, size),
                        onPanUpdate: (d) => _onPanUpdate(d.localPosition, size),
                        onPanEnd: (_) {
                          _draggingHandle = null;
                          _startAngle = null;
                        },
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
                            label: 'Bedtime',
                            time: controller.bedTime,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          const Divider(color: Colors.white, thickness: 2),
                          const SizedBox(height: 5),
                          _buildTimeRow(
                            label: 'Alarm',
                            time: controller.alarmStart,
                            color: Colors.white,
                            updatedTime: controller.updatedAlarmStart,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const TrackerView());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sleep now',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHM(TimeOfDay t) =>
      '${t.hour}:${t.minute.toString().padLeft(2, '0')}';

  Widget _buildTimeRow({
    required String label,
    required Rx<TimeOfDay> time,
    required Color color,
    Rx<TimeOfDay?>? updatedTime,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'Bedtime') {
          Get.put(BedtimeController());
          Get.to(() => const BedtimeView());
        } else if (label == 'Alarm') {
          Get.put(AlarmController());
          Get.to(() => AlarmView());
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                label == 'Alarm' ? Icons.notifications : Icons.nights_stay,
                color: label == 'Alarm' ? Colors.amber : Colors.indigo[200],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Obx(() {
                final base = time.value;
                final isSmartOn = controller.isSmartAlarmEnabled.value;
                final offset = (label == 'Alarm' && isSmartOn)
                    ? controller.smartAlarmOffsetMinutes.value
                    : 0;

                final totalMin = (base.hour * 60 + base.minute - offset + 1440) % 1440;
                final smartStart = TimeOfDay(
                  hour: totalMin ~/ 60,
                  minute: totalMin % 60,
                );

                final text = label == 'Alarm'
                    ? (offset == 0
                    ? _formatHM(base)
                    : '${_formatHM(smartStart)} - ${_formatHM(base)}')
                    : _formatHM(base);

                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                onPressed: () {
                  if (label == 'Bedtime') {
                    Get.put(BedtimeController());
                    Get.to(() => const BedtimeView());
                  } else if (label == 'Alarm') {
                    Get.put(AlarmController());
                    Get.to(() => const AlarmView());
                  }
                },
              ),
            ],
          ),
          if (updatedTime != null && updatedTime.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Updated Alarm',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                        () => Text(
                      _formatHM(updatedTime.value!),
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _onPanStart(Offset p, double size) {
    final center = Offset(size / 2, size / 2);
    final r = size / 2 * 0.8;
    Offset _pos(TimeOfDay t) =>
        center +
            Offset(r * math.cos(_timeToAngle(t)), r * math.sin(_timeToAngle(t)));
    final distBed = (p - _pos(controller.bedTime.value)).distance;
    final distAlarm = (p - _pos(controller.alarmStart.value)).distance;

    if (distBed < 40 && distBed < distAlarm) {
      _draggingHandle = 0;
    } else if (distAlarm < 40) {
      _draggingHandle = 1;
    }

    if (_draggingHandle != null) {
      _onPanUpdate(p, size);
    } else {
      _startAngle = math.atan2(p.dy - center.dy, p.dx - center.dx);
    }
  }

  void _onPanUpdate(Offset p, double size) {
    final center = Offset(size / 2, size / 2);

    if (_draggingHandle == null) {
      if (_startAngle == null) return;

      final currentAngle = math.atan2(p.dy - center.dy, p.dx - center.dx);
      final deltaAngle = currentAngle - _startAngle!;
      _startAngle = currentAngle;

      final deltaM = ((deltaAngle / (2 * math.pi)) * 1440).round();

      void shiftTime(Rx<TimeOfDay> time) {
        final totalM =
            (time.value.hour * 60 + time.value.minute + deltaM + 1440) % 1440;
        time.value = TimeOfDay(hour: totalM ~/ 60, minute: totalM % 60);
      }

      shiftTime(controller.bedTime);
      shiftTime(controller.alarmStart);
      return;
    }

    final ang =
        ((math.atan2(p.dy - center.dy, p.dx - center.dx) + 2 * math.pi) %
            (2 * math.pi) +
            math.pi / 2) %
            (2 * math.pi);
    final newM = ((ang / (2 * math.pi)) * 1440).round() % 1440;
    final newT = TimeOfDay(hour: newM ~/ 60, minute: newM % 60);
    final other =
    _draggingHandle == 0
        ? controller.alarmStart.value
        : controller.bedTime.value;
    final otherM = other.hour * 60 + other.minute;
    final cw = (otherM - newM + 1440) % 1440;
    final ccw = 1440 - cw;
    int pushed = otherM;
    if (cw < _minDiffMinutes)
      pushed = (newM + _minDiffMinutes) % 1440;
    else if (ccw < _minDiffMinutes)
      pushed = (newM - _minDiffMinutes + 1440) % 1440;
    final pushedT = TimeOfDay(hour: pushed ~/ 60, minute: pushed % 60);
    if (_draggingHandle == 0) {
      controller.bedTime.value = newT;
      controller.alarmStart.value = pushedT;
    } else {
      controller.alarmStart.value = newT;
      controller.bedTime.value = pushedT;
    }
  }

  double _timeToAngle(TimeOfDay t) =>
      (t.hour * 60 + t.minute) / 1440 * 2 * math.pi - math.pi / 2;
}

class _SleepClockPainter extends CustomPainter {
  final TimeOfDay bedTime;
  final TimeOfDay alarmStart;
  const _SleepClockPainter({required this.bedTime, required this.alarmStart});

  @override
  void paint(Canvas c, Size s) {
    final ctr = Offset(s.width / 2, s.height / 2);
    final innerR = s.width / 2 * 0.75;
    final arcR = innerR + 35;

    c.drawCircle(
      ctr,
      arcR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..color = const Color(0xFF384056),
    );

    c.drawCircle(ctr, arcR - 15, Paint()..color = const Color(0xFF262D3A));

    final hourP =
    Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final minP =
    Paint()
      ..color = Colors.white54
      ..strokeWidth = 1;
    final hourLen = innerR * 0.12;
    final minLen = innerR * 0.08;
    for (int i = 0; i < 60; i++) {
      final a = i * 2 * math.pi / 60 - math.pi / 2;
      final cosA = math.cos(a);
      final sinA = math.sin(a);
      final p1 = ctr + Offset(innerR * cosA, innerR * sinA);
      final p2 =
          ctr +
              Offset(
                (innerR - (i % 5 == 0 ? hourLen : minLen)) * cosA,
                (innerR - (i % 5 == 0 ? hourLen : minLen)) * sinA,
              );
      c.drawLine(p1, p2, i % 5 == 0 ? hourP : minP);
    }

    const lbls = ['0', '6', '12', '18'];
    for (int i = 0; i < 4; i++) {
      final a = i * math.pi / 2 - math.pi / 2;
      final pos =
          ctr +
              Offset(
                (innerR - hourLen - 15) * math.cos(a),
                (innerR - hourLen - 15) * math.sin(a),
              );
      final tp = TextPainter(
        text: TextSpan(
          text: lbls[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(c, pos - Offset(tp.width / 2, tp.height / 2));
    }

    final startA = _timeToAngle(bedTime);
    final endA = _timeToAngle(alarmStart);
    double sweep = (endA - startA) % (2 * math.pi);
    if (sweep < 0) sweep += 2 * math.pi;
    c.drawArc(
      Rect.fromCircle(center: ctr, radius: arcR),
      startA,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF6C5DD3),
    );

    void drawH(IconData ic, double ang) {
      final pos = ctr + Offset(arcR * math.cos(ang), arcR * math.sin(ang));
      c.drawCircle(pos, 16, Paint()..color = const Color(0xFF262D3A));
      final tp = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(ic.codePoint),
          style: TextStyle(
            fontSize: 16,
            color: Colors.yellow,
            fontFamily: ic.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(c, pos - Offset(tp.width / 2, tp.height / 2));
    }

    drawH(Icons.nights_stay_rounded, startA);
    drawH(Icons.wb_sunny, endA);
  }

  double _timeToAngle(TimeOfDay t) =>
      (t.hour * 60 + t.minute) / 1440 * 2 * math.pi - math.pi / 2;

  @override
  bool shouldRepaint(covariant _SleepClockPainter old) =>
      old.bedTime != bedTime || old.alarmStart != alarmStart;
}