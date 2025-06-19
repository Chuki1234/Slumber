import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/play_music_controller.dart';

class PlayMusicView extends GetView<PlayMusicController> {
  const PlayMusicView({super.key});

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final music = controller.music;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 48),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        music['image_url'] ?? '',
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 240,
                          height: 240,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.white54, size: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    music['title'] ?? 'No title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    music['author'] ?? 'anonymous',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    music['duration'] != null ? '${music['duration']} min' : '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Obx(() {
                      final pos = controller.position.value;
                      final dur = controller.duration.value.inSeconds > 0
                          ? controller.duration.value
                          : Duration(minutes: music['duration'] ?? 0);
                      return Column(
                        children: [
                          Slider(
                            value: pos.inSeconds.toDouble().clamp(0, dur.inSeconds.toDouble()),
                            min: 0,
                            max: dur.inSeconds.toDouble(),
                            onChanged: (value) => controller.seekTo(value),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(pos), style: const TextStyle(color: Colors.white54)),
                              Text(_formatDuration(dur), style: const TextStyle(color: Colors.white54)),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                        onPressed: () {}, // Implement skip previous if needed
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: controller.playPause,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                        onPressed: () {}, // Implement skip next if needed
                      ),
                    ],
                  )),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Sleep now',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}