import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  final bool fromTracker;
  DiscoverView({Key? key, this.fromTracker = false}) : super(key: key);

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
      backgroundColor: Colors.black,
      appBar: fromTracker
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      )
          : null,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: controller.tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[400],
                    labelStyle: defaultTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    indicatorColor: Colors.transparent,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 3.0, color: Colors.cyanAccent),
                      insets: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(text: 'Sounds'),
                      Tab(text: 'Music'),
                      Tab(text: 'Stories'),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔊 Sounds Section
                        _buildSectionTitle('Sleep Sounds', soundsKey),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.soundsList.length,
                            itemBuilder: (context, index) =>
                                _buildSoundCard(controller.soundsList[index]),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // 🎵 Music Section
                        _buildSectionTitle('Music', musicKey),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.musicList.length,
                            itemBuilder: (context, index) =>
                                _buildMusicCard(controller.musicList[index]),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // 📖 Stories Section
                        _buildSectionTitle('Stories', storiesKey),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.storiesList.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final item = controller.storiesList[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item['image'] ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.blueGrey.shade700,
                                      child: const Icon(Icons.image, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                item['title'] ?? 'No title',
                                style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                item['subtitle'] ?? '',
                                style: defaultTextStyle.copyWith(color: Colors.white70),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔘 Mini Player Bar
                Obx(() {
                  if (controller.playingIndex.value == -1) return const SizedBox.shrink();
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
                                style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
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
                          onPressed: () => controller.playMusic(controller.playingIndex.value),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: controller.stopMusic,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title, Key key) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSoundCard(Map<String, String?> item) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item['image'] ?? '',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 160,
                    height: 160,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
                  ),
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
            style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
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
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image'] ?? '',
              width: 180,
              height: 140,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 180,
                height: 140,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['title'] ?? 'No title',
            style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
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