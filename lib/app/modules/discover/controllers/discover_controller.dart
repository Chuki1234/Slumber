import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../layout/controllers/layout_controller.dart';


class DiscoverController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  final RxList<Map<String, dynamic>> soundsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> musicList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> storiesList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);

    fetchSoundsList();
    fetchMusicList();
    fetchStoriesList();
  }

  Future<void> fetchSoundsList() async {
    final data = await Supabase.instance.client
        .from('music_library')
        .select()
        .eq('type', 'sound')
        .then((value) => value as List<dynamic>);
    soundsList.assignAll(data.cast<Map<String, dynamic>>());
  }

  Future<void> fetchMusicList() async {
    final data = await Supabase.instance.client
        .from('music_library')
        .select()
        .eq('type', 'music')
        .then((value) => value as List<dynamic>);
    musicList.assignAll(data.cast<Map<String, dynamic>>());
  }

  Future<void> fetchStoriesList() async {
    final data = await Supabase.instance.client
        .from('music_library')
        .select()
        .eq('type', 'story')
        .then((value) => value as List<dynamic>);
    storiesList.assignAll(data.cast<Map<String, dynamic>>());
  }

  void playMusic(int index) {
    final layoutController = Get.find<LayoutController>();
    final song = musicList[index];

    layoutController.playSong(
      Song(
        title: song['title'] ?? '',
        artist: song['description'] ?? '',
        imageUrl: song['image_url'] ?? '',
        audioUrl: song['audio_url'] ?? '',
      ),
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}