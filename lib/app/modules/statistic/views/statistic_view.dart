import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/statistic_controller.dart';

class StatisticView extends GetView<StatisticController> {
  const StatisticView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSleepScoreCard(),
                      const SizedBox(height: 20),
                      _buildTimeChart(),
                      const SizedBox(height: 20),
                      _buildNoiseChart(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepScoreCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(
            () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sleep Score',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${controller.sleepScore.value}',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Time in bed: ${controller.timeInBed.value}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Text(
                  'Quality: ${controller.sleepQuality.value}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChart() {
    List<Map<String, dynamic>> data = controller.isBedtimeMode.value
        ? controller.bedtimeData
        : controller.wakeupData;

    const List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    double parseTime(String time) {
      final parts = time.split(':');
      double h = double.parse(parts[0]);
      double m = double.parse(parts[1]) / 60;
      if (h >= 18) h -= 24; // shift giờ từ 18h trở đi về đầu trục
      return h + m + 6;
    }

    // Lấy các giá trị thời gian hợp lệ
    List<double> validTimes = data.map((e) => parseTime(e['time'])).toList();
    double avgTime = validTimes.reduce((a, b) => a + b) / validTimes.length;

    final earliest = data.reduce((a, b) =>
    parseTime(a['time']) < parseTime(b['time']) ? a : b);
    final latest = data.reduce((a, b) =>
    parseTime(a['time']) > parseTime(b['time']) ? a : b);

    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bedtime/Wake up time',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              _toggleButton('Went to bed', true),
              const SizedBox(width: 8),
              _toggleButton('Woke up', false),
              const Spacer(),
              Text('Avg ${_formatTime(avgTime)}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendDot(color: Colors.orange),
              Text(' Earliest ${earliest['time']}', style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 12),
              _legendDot(color: Colors.cyan),
              Text(' Latest ${latest['time']}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 12,
                minY: 0,
                maxY: 6,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: Colors.white12, strokeWidth: 1),
                  getDrawingVerticalLine: (_) =>
                      FlLine(color: Colors.white12, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 36,
                      getTitlesWidget: (value, _) {
                        if (value >= 0 && value < weekDays.length) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              weekDays[value.toInt()],
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 28,
                      getTitlesWidget: (value, _) {
                        return Text(_formatTime(value),
                            style: const TextStyle(color: Colors.white54, fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.cyanAccent,
                    dotData: FlDotData(show: true),
                    spots: List.generate(7, (i) {
                      final time = data[i]['time'];
                      final t = parseTime(time);
                      return FlSpot(t, i.toDouble());
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _toggleButton(String text, bool isBedtime) {
    final isSelected = controller.isBedtimeMode.value == isBedtime;
    return GestureDetector(
      onTap: () => controller.isBedtimeMode.value = isBedtime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.white54),
        ),
      ),
    );
  }

  Widget _legendDot({required Color color}) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: Icon(Icons.circle, size: 10, color: color),
  );

  String _formatTime(double time) {
    final h = time.floor();
    final m = ((time - h) * 60).round();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  Widget _buildNoiseChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Noise and Movement',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) => Text(
                        '${value.toInt()}',
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final day = controller.weeklyNoise[value.toInt()]['day'];
                        return Text(
                          day,
                          style: const TextStyle(color: Colors.white70),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: controller.weeklyNoise.asMap().entries.map((entry) {
                  final i = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: data['max'].toDouble(), width: 6, color: Colors.redAccent),
                    BarChartRodData(toY: data['min'].toDouble(), width: 6, color: Colors.cyanAccent),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
