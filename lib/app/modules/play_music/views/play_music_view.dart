import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Tracker/views/tracker_view.dart';
import '../../layout/controllers/layout_controller.dart';

class PlayMusicView extends StatefulWidget {
  const PlayMusicView({super.key});

  @override
  State<PlayMusicView> createState() => _PlayMusicViewState();
}

class _PlayMusicViewState extends State<PlayMusicView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}';
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _scaleAnim = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LayoutController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final song = controller.currentSong.value;
        if (song == null) {
          return const Center(
            child: Text(
              'Không có bài hát nào đang phát',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                song.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        song.imageUrl,
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 280,
                          height: 280,
                          color: Colors.grey[800],
                          child: const Icon(Icons.music_note, color: Colors.white54, size: 64),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    song.artist,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    final pos = controller.position.value;
                    final dur = controller.duration.value.inSeconds > 0
                        ? controller.duration.value
                        : const Duration(seconds: 1);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          Slider(
                            value: pos.inSeconds.clamp(0, dur.inSeconds).toDouble(),
                            min: 0,
                            max: dur.inSeconds.toDouble(),
                            onChanged: (value) => controller.seekTo(value),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(pos), style: const TextStyle(color: Colors.white70)),
                              Text(_formatDuration(dur), style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                        onPressed: controller.skipPrevious,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: controller.togglePlayPause,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                        onPressed: controller.skipNext,
                      ),
                    ],
                  )),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        onPressed: () {
                          Get.to(() => const TrackerView());
                        },
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
                  const SizedBox(height: 24),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}