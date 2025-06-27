import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../play_music/views/play_music_view.dart';
import '../controllers/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: Column(
          children: [
            Expanded(child: controller.pages[controller.currentIndex.value]),
            // Mini player
            if (controller.currentSong.value != null)
              Dismissible(
                key: const ValueKey('mini_player'),
                direction: DismissDirection.horizontal,
                onDismissed: (_) => controller.stop(),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const PlayMusicView(),
                      transition: Transition.downToUp,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    color: Colors.grey[850],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ảnh nhạc
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            controller.currentSong.value!.imageUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white54,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Tiêu đề
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.currentSong.value!.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                controller.currentSong.value!.artist,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Nút điều khiển
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildControlIcon(
                              Icons.skip_previous,
                              controller.skipPrevious,
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: controller.togglePlayPause,
                              child: Obx(
                                () => Icon(
                                  controller.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildControlIcon(
                              Icons.skip_next,
                              controller.skipNext,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: const Color(0xFF201F31),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bedtime_outlined),
              activeIcon: Icon(Icons.bedtime),
              label: 'Sleep',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Daily',
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              activeIcon: Icon(Icons.pie_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildControlIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
