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

  final AudioPlayer audioPlayer = AudioPlayer();

  // ✅ Thêm để hỗ trợ Slider và thời lượng
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    // Theo dõi trạng thái phát
    audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
      }
    });

    // Theo dõi thời gian phát
    audioPlayer.positionStream.listen((pos) => position.value = pos);
    audioPlayer.durationStream.listen((dur) {
      if (dur != null) duration.value = dur;
    });
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> playSong(Song song) async {
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

  void skipNext() {
    // TODO: xử lý khi có playlist
  }

  void skipPrevious() {
    // TODO: xử lý khi có playlist
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}