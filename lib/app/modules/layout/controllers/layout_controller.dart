// ✅ LayoutController kết hợp đầy đủ các tính năng từ cả hai phiên bản
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Song {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  Song({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });
}

class LayoutController extends GetxController {
  LayoutController({required this.pages});

  final List<Widget> pages;
  final RxInt currentIndex = 0.obs;

  final Rx<Song?> currentSong = Rx<Song?>(null);
  final RxBool isPlaying = false.obs;
  final RxBool isLoadingNext = false.obs;

  final RxList<Song> currentPlaylist = <Song>[].obs;
  final RxInt currentSongIndex = 0.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  // ✅ Hỗ trợ thời lượng và vị trí để dùng cho slider
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    _setupPlayer();
    loadPlaylist();
  }

  void _setupPlayer() {
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        skipNext();
      }
    });

    audioPlayer.positionStream.listen((pos) => position.value = pos);
    audioPlayer.durationStream.listen((dur) {
      if (dur != null) duration.value = dur;
    });
  }

  Future<void> loadPlaylist() async {
    try {
      final res = await Supabase.instance.client
          .from('music_library')
          .select()
          .eq('type', 'music');

      final data = res as List;
      final songs = data.map((e) => Song(
        title: e['title'],
        artist: e['description'] ?? 'Unknown',
        imageUrl: e['image_url'],
        audioUrl: e['audio_url'],
      )).toList();

      currentPlaylist.assignAll(songs);
    } catch (e) {
      Get.snackbar('Error', 'Lỗi tải playlist: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> playSong(Song song, {List<Song>? playlist, int? index}) async {
    if (playlist != null) {
      currentPlaylist.assignAll(playlist);
      currentSongIndex.value = index ?? 0;
    } else if (index != null) {
      currentSongIndex.value = index;
    } else if (currentPlaylist.isNotEmpty) {
      currentSongIndex.value = currentPlaylist.indexWhere((s) => s.audioUrl == song.audioUrl);
    } else {
      currentPlaylist.assignAll([song]);
      currentSongIndex.value = 0;
    }

    currentSong.value = song;
    try {
      await audioPlayer.setUrl(song.audioUrl);
      await audioPlayer.play();
    } catch (e) {
      Get.snackbar('Error', 'Không thể phát nhạc: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  void stop() {
    audioPlayer.stop();
    isPlaying.value = false;
    currentSong.value = null;
  }

  void seekTo(double seconds) {
    audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  Future<void> skipNext() async {
    if (currentPlaylist.isEmpty || isLoadingNext.value) return;

    isLoadingNext.value = true;

    final nextIndex = (currentSongIndex.value + 1) % currentPlaylist.length;
    currentSongIndex.value = nextIndex;

    try {
      await playSong(currentPlaylist[nextIndex]);
    } catch (e) {
      Get.snackbar('Error', 'Không thể phát bài tiếp theo: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingNext.value = false;
    }
  }

  Future<void> skipPrevious() async {
    if (currentPlaylist.isEmpty || isLoadingNext.value) return;

    isLoadingNext.value = true;

    final prevIndex = (currentSongIndex.value - 1 + currentPlaylist.length) % currentPlaylist.length;
    currentSongIndex.value = prevIndex;

    try {
      await playSong(currentPlaylist[prevIndex]);
    } catch (e) {
      Get.snackbar('Error', 'Không thể phát bài trước đó: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingNext.value = false;
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}
