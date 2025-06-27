import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

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

  final RxList<Song> currentPlaylist = <Song>[].obs;
  final RxInt currentSongIndex = 0.obs;

  final AudioPlayer audioPlayer = AudioPlayer();

  // ✅ Thêm để hỗ trợ Slider và thời lượng
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

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

  void skipNext() {
    if (currentPlaylist.isNotEmpty && currentSongIndex.value < currentPlaylist.length - 1) {
      final nextIndex = currentSongIndex.value + 1;
      currentSongIndex.value = nextIndex;
      playSong(currentPlaylist[nextIndex]);
    }
  }

  void skipPrevious() {
    if (currentPlaylist.isNotEmpty && currentSongIndex.value > 0) {
      final prevIndex = currentSongIndex.value - 1;
      currentSongIndex.value = prevIndex;
      playSong(currentPlaylist[prevIndex]);
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}