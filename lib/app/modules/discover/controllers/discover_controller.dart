import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscoverController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  final RxInt playingIndex = (-1).obs;
  final RxBool isPlaying = false.obs;

  late AudioPlayer player;

  final RxList<Map<String, dynamic>> soundsList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> musicList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> storiesList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    player = AudioPlayer();

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stopMusic();
      }
    });

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

  @override
  void onClose() {
    player.dispose();
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void playMusic(int index) async {
    if (playingIndex.value == index) {
      if (isPlaying.value) {
        await player.pause();
        isPlaying.value = false;
      } else {
        await player.play();
        isPlaying.value = true;
      }
    } else {
      playingIndex.value = index;
      isPlaying.value = true;
      await player.stop();
      await player.setUrl(musicList[index]['audio_url'] ?? '');
      await player.play();
    }
  }

  void stopMusic() async {
    await player.stop();
    isPlaying.value = false;
    playingIndex.value = -1;
  }
}