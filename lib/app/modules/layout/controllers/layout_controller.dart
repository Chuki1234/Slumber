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

  final RxList<Song> playlist = <Song>[].obs;
  final RxInt currentSongIndex = 0.obs;
  final Rx<Song?> currentSong = Rx<Song?>(null);

  final RxBool isPlaying = false.obs;
  final RxBool isLoadingNext = false.obs;

  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

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

      playlist.assignAll(songs);
    } catch (e) {
      Get.snackbar('Error', 'Lỗi tải playlist: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> playSong(Song song) async {
    final index = playlist.indexWhere((s) => s.audioUrl == song.audioUrl);
    if (index != -1) currentSongIndex.value = index;

    currentSong.value = song;
    try {
      await audioPlayer.setUrl(song.audioUrl);
      await audioPlayer.play();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Không thể phát nhạc: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    if (playlist.isEmpty || isLoadingNext.value) return;

    isLoadingNext.value = true;

    final nextIndex = (currentSongIndex.value + 1) % playlist.length;
    currentSongIndex.value = nextIndex;

    try {
      await playSong(playlist[nextIndex]);
    } catch (e) {
      Get.snackbar('Error', 'Không thể phát bài tiếp theo: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingNext.value = false;
    }
  }

  Future<void> skipPrevious() async {
    if (playlist.isEmpty || isLoadingNext.value) return;

    isLoadingNext.value = true;

    final prevIndex = (currentSongIndex.value - 1 + playlist.length) % playlist.length;
    currentSongIndex.value = prevIndex;

    try {
      await playSong(playlist[prevIndex]);
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