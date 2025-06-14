import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends GetView<DiscoverController> {
  final bool fromTracker;

  DiscoverView({Key? key, required this.fromTracker}) : super(key: key);

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

            // ✅ Nút back nếu mở từ Tracker
            if (fromTracker)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Back to Tracker',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

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
                    _sectionTitle('Sleep Sounds', key: soundsKey),
                    _horizontalList(controller.soundsList, _buildSoundCard),
                    const SizedBox(height: 30),

                    _sectionTitle('Music', key: musicKey),
                    _horizontalList(controller.musicList, _buildMusicCard),
                    const SizedBox(height: 30),

                    _sectionTitle('Stories', key: storiesKey),
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
                          title: Text(item['title'] ?? 'No title',
                              style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['subtitle'] ?? '',
                              style: defaultTextStyle.copyWith(color: Colors.white70)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Obx(() {
              if (controller.playingIndex.value == -1) return const SizedBox.shrink();
              final music = controller.musicList[controller.playingIndex.value];
              return _playerBar(music);
            }),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {Key? key}) => Container(
    key: key,
    padding: const EdgeInsets.all(16),
    child: Text(
      title,
      style: defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  Widget _horizontalList(List<Map<String, String?>> data, Widget Function(Map<String, String?>) builder) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: data.length,
        itemBuilder: (context, index) => builder(data[index]),
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
                    child: Text(item['tag']!,
                        style: defaultTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
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
            style: defaultTextStyle.copyWith(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
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
            style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item['duration'] ?? '',
            style: defaultTextStyle.copyWith(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _playerBar(Map<String, String?> music) {
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
                Text(music['title'] ?? 'No title', style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("⏱ ${music['duration'] ?? 'N/A'}",
                    style: defaultTextStyle.copyWith(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow, color: Colors.white),
            onPressed: () => controller.playMusic(controller.playingIndex.value),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: controller.stopMusic,
          ),
        ],
      ),
    );
  }
}