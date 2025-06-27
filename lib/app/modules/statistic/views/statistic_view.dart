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

    double parseTime(String time) {
      final parts = time.split(':');
      double h = double.parse(parts[0]);
      double m = double.parse(parts[1]) / 60;
      if (h >= 18) h -= 24;
      return h + m + 6; // shift time range to positive axis
    }

    double avgTime = data.map((e) => parseTime(e['time'])).reduce((a, b) => a + b) / data.length;
    final earliest = data.reduce((a, b) => parseTime(a['time']) < parseTime(b['time']) ? a : b);
    final latest = data.reduce((a, b) => parseTime(a['time']) > parseTime(b['time']) ? a : b);

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
                maxY: 6.5,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                      return Text(days[value.toInt()],
                          style: const TextStyle(color: Colors.white70, fontSize: 12));
                    }, interval: 1),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
                      return Text(_formatTime(value),
                          style: const TextStyle(color: Colors.white54, fontSize: 10));
                    }),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: false,
                    color: Colors.cyanAccent,
                    dotData: FlDotData(show: true),
                    isStrokeCapRound: true,
                    spots: List.generate(7, (i) {
                      final t = parseTime(data[i]['time']);
                      return FlSpot(t, i.toDouble());
                    }),
                  )
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
