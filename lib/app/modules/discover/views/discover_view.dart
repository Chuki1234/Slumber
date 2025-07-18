// ✅ DiscoverView kết hợp - sử dụng StatefulWidget, giữ các cập nhật mới nhất
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layout/controllers/layout_controller.dart';
import '../../play_music/views/play_music_view.dart';
import '../controllers/discover_controller.dart';

class DiscoverView extends StatefulWidget {
  final bool fromTracker;
  const DiscoverView({Key? key, this.fromTracker = false}) : super(key: key);

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  final controller = Get.put(DiscoverController());
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
  void initState() {
    super.initState();
    controller.tabController = TabController(length: 3, vsync: this);
    controller.tabController.addListener(() {
      if (controller.tabController.indexIsChanging) {
        _scrollToSection(controller.tabController.index);
      }
    });
    controller.fetchSoundsList();
    controller.fetchMusicList();
    controller.fetchStoriesList();
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    controller.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: widget.fromTracker
          ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Sound and Music",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
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
                TabBar(
                  controller: controller.tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  labelStyle: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  indicator: const RoundedRectangleTabIndicator(
                    color: Colors.cyanAccent,
                    weight: 3,
                    width: 24,
                    radius: 6,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
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
                        _buildSectionTitle('Sleep Sounds', soundsKey),
                        SizedBox(
                          height: 220,
                          child: Obx(() {
                            if (controller.soundsList.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.soundsList.length,
                              itemBuilder: (context, index) => _buildCard(controller.soundsList[index], index, controller.soundsList),
                            );
                          }),
                        ),
                        const SizedBox(height: 5),
                        _buildSectionTitle('Music', musicKey),
                        SizedBox(
                          height: 200,
                          child: Obx(() {
                            if (controller.musicList.isEmpty) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.musicList.length,
                              itemBuilder: (context, index) => _buildCard(controller.musicList[index], index, controller.musicList),
                            );
                          }),
                        ),
                        const SizedBox(height: 5),
                        _buildSectionTitle('Stories', storiesKey),
                        Obx(() {
                          if (controller.storiesList.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.storiesList.length,
                            separatorBuilder: (_, __) => const Divider(color: Colors.white24),
                            itemBuilder: (context, index) {
                              final item = controller.storiesList[index];
                              return GestureDetector(
                                onTap: () {
                                  final layoutController = Get.find<LayoutController>();
                                  final playlist = controller.storiesList.map((e) => Song(
                                    title: e['title'] ?? 'No title',
                                    artist: e['description'] ?? '',
                                    imageUrl: e['image_url'] ?? '',
                                    audioUrl: e['audio_url'] ?? '',
                                  )).toList();
                                  layoutController.playSong(playlist[index], playlist: playlist, index: index);
                                  Get.to(() => const PlayMusicView());
                                },
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['image_url'] ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.blueGrey.shade700,
                                        child: const Icon(Icons.image, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  title: Text(item['title'] ?? 'No title', style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Text(item['description'] ?? '', style: defaultTextStyle.copyWith(color: Colors.white70)),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Key key) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      child: Text(title, style: defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCard(Map<String, dynamic> item, int index, List<Map<String, dynamic>> list) {
    final layoutController = Get.find<LayoutController>();
    final playlist = list.map((e) => Song(
      title: e['title'] ?? 'No title',
      artist: e['description'] ?? '',
      imageUrl: e['image_url'] ?? '',
      audioUrl: e['audio_url'] ?? '',
    )).toList();

    return GestureDetector(
      onTap: () {
        layoutController.playSong(playlist[index], playlist: playlist, index: index);
        Get.to(() => const PlayMusicView());
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item['image_url'] ?? '',
                width: 180,
                height: 140,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 180,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(item['title'] ?? 'No title',
                style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            Text(item['description'] ?? '',
                style: defaultTextStyle.copyWith(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class RoundedRectangleTabIndicator extends Decoration {
  final Color color;
  final double weight;
  final double width;
  final double radius;

  const RoundedRectangleTabIndicator({required this.color, required this.weight, required this.width, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _RoundedRectanglePainter(this, onChanged);
}

class _RoundedRectanglePainter extends BoxPainter {
  final RoundedRectangleTabIndicator decoration;

  _RoundedRectanglePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()..color = decoration.color..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + configuration.size!.height - decoration.weight,
      configuration.size!.width,
      decoration.weight,
    );
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius));
    canvas.drawRRect(rRect, paint);
  }
}
