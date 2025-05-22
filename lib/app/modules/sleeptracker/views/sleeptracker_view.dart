import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sleeptracker_controller.dart';

class SleeptrackerView extends GetView<SleeptrackerController> {
  const SleeptrackerView({super.key});

  double _timeToPercent(TimeOfDay t) => (t.hour * 60 + t.minute) / 1440 * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.black);
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  const Text(
                    'SLEEP TRACKER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() {
                    final bedTime = controller.bedTime.value;
                    final alarmTime = controller.alarmStart.value;
                    final bedPercent = _timeToPercent(bedTime);
                    final alarmPercent = _timeToPercent(alarmTime);

                    // Arc calculation (handles wrap-around)
                    double start = bedPercent;
                    double end = alarmPercent;
                    double arcLength = end - start;
                    if (arcLength <= 0) arcLength += 100;

                    return SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Arc between bed and alarm (iOS style)
                          SleekCircularSlider(
                            initialValue: arcLength,
                            min: 0,
                            max: 100,
                            appearance: CircularSliderAppearance(
                              size: 260,
                              startAngle: 270 + (start / 100 * 360),
                              angleRange: (arcLength / 100 * 360),
                              customColors: CustomSliderColors(
                                trackColor: Colors.transparent,
                                progressBarColor: const Color(0xFF4A90E2),
                                dotColor: Colors.transparent,
                              ),
                              customWidths: CustomSliderWidths(
                                handlerSize: 0,
                                trackWidth: 0,
                                progressBarWidth: 24,
                              ),
                            ),
                            onChange: (_) {},
                            innerWidget: (_) => const SizedBox(),
                          ),
                          // Bedtime handle (blue)
                          SleekCircularSlider(
                            initialValue: bedPercent,
                            min: 0,
                            max: 100,
                            appearance: CircularSliderAppearance(
                              size: 260,
                              startAngle: 270,
                              angleRange: 360,
                              customColors: CustomSliderColors(
                                trackColor: Colors.transparent,
                                progressBarColor: Colors.transparent,
                                dotColor: const Color(0xFF4A90E2),
                              ),
                              customWidths: CustomSliderWidths(
                                handlerSize: 18,
                                trackWidth: 0,
                                progressBarWidth: 0,
                              ),
                            ),
                            onChange: (value) {
                              final total = (value / 100 * 1440).round();
                              final hour = total ~/ 60;
                              final minute = total % 60;
                              controller.setBedTime(TimeOfDay(hour: hour, minute: minute));
                            },
                            innerWidget: (_) => const SizedBox(),
                          ),
                          // Alarm handle (orange)
                          SleekCircularSlider(
                            initialValue: alarmPercent,
                            min: 0,
                            max: 100,
                            appearance: CircularSliderAppearance(
                              size: 260,
                              startAngle: 270,
                              angleRange: 360,
                              customColors: CustomSliderColors(
                                trackColor: Colors.transparent,
                                progressBarColor: Colors.transparent,
                                dotColor: Colors.orangeAccent,
                              ),
                              customWidths: CustomSliderWidths(
                                handlerSize: 18,
                                trackWidth: 0,
                                progressBarWidth: 0,
                              ),
                            ),
                            onChange: (value) {
                              final total = (value / 100 * 1440).round();
                              final hour = total ~/ 60;
                              final minute = total % 60;
                              controller.setAlarmStart(TimeOfDay(hour: hour, minute: minute));
                            },
                            innerWidget: (_) => const SizedBox(),
                          ),
                          // Center info
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'BED TIME - ALARM',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${controller.formatTime(bedTime)} - ${controller.formatTime(alarmTime)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 40),
                  // Bed Time
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.bedtime),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          Icon(Icons.nights_stay, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Bed Time', style: TextStyle(color: Colors.white)),
                        ]),
                        Obx(() => Text(
                          controller.formatTime(controller.bedTime.value),
                          style: const TextStyle(color: Colors.white),
                        )),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white),
                  // Alarm
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.alarm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: const [
                          Icon(Icons.notifications_active, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Alarm', style: TextStyle(color: Colors.white)),
                        ]),
                        Obx(() => Text(
                          '${controller.formatTime(controller.alarmStart.value)} - ${controller.formatTime(controller.alarmEnd.value)}',
                          style: const TextStyle(color: Colors.white),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}