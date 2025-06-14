import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  DiscoverView({Key? key}) : super(key: key);

  final GlobalKey soundsKey = GlobalKey();
  final GlobalKey musicKey = GlobalKey();
  final GlobalKey storiesKey = GlobalKey();

  final TextStyle defaultTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  void _scrollToSection(int index) {
    GlobalKey key;
    switch (index) {
      case 0:
        key = soundsKey;
        break;
      case 1:
        key = musicKey;
        break;
      case 2:
        key = storiesKey;
        break;
      default:
        key = soundsKey;
    }
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.tabController.addListener(() {
      if (controller.tabController.indexIsChanging) {
        _scrollToSection(controller.tabController.index);
      }
    });

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            TabBar(
              controller: controller.tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              indicatorColor: Colors.cyanAccent,
              labelStyle: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Sounds'),
                Tab(text: 'Music'),
                Tab(text: 'Stories'),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sounds section
                    Container(
                      key: soundsKey,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Sleep Sounds',
                        style: defaultTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.soundsList.length,
                        itemBuilder: (context, index) {
                          final item = controller.soundsList[index];
                          return _buildSoundCard(item);
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Music section
                    Container(
                      key: musicKey,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Music',
                        style: defaultTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.musicList.length,
                        itemBuilder: (context, index) {
                          final item = controller.musicList[index];
                          return _buildMusicCard(item);
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Stories section
                    Container(
                      key: storiesKey,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Stories',
                        style: defaultTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.storiesList.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                      itemBuilder: (context, index) {
                        final item = controller.storiesList[index];
                        return ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.book, color: Colors.white),
                          ),
                          title: Text(
                            item['title'] ?? 'No title',
                            style: defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            item['subtitle'] ?? '',
                            style: defaultTextStyle.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Player bar
            Obx(() {
              if (controller.playingIndex.value == -1) {
                return const SizedBox.shrink();
              }
              final music = controller.musicList[controller.playingIndex.value];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey.shade900.withOpacity(0.9),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey.shade700,
                        child: const Icon(Icons.music_note, color: Colors.white54),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            music['title'] ?? 'No title',
                            style: defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '⏱ ${music['duration'] ?? 'N/A'}',
                            style: defaultTextStyle.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller.playMusic(controller.playingIndex.value);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        controller.stopMusic();
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundCard(Map<String, String?> item) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 140,
                  height: 100,
                  color: Colors.grey.shade700,
                  child: const Icon(Icons.image, color: Colors.white54, size: 40),
                ),
              ),
              if (item['tag'] != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['tag']!,
                      style: defaultTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item['title'] ?? 'No title',
            style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item['subtitle'] ?? '',
            style: defaultTextStyle.copyWith(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicCard(Map<String, String?> item) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 140,
              height: 100,
              color: Colors.grey.shade700,
              child: const Icon(Icons.music_note, color: Colors.white54, size: 40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['title'] ?? 'No title',
            style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item['duration'] ?? '',
            style: defaultTextStyle.copyWith(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}