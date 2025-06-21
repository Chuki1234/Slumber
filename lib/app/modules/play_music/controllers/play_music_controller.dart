import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class PlayMusicController extends GetxController {
  late Map<String, dynamic> music;
  late AudioPlayer player;

  final RxBool isPlaying = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    music = Get.arguments ?? {};
    player = AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    await player.setUrl(music['audio_url'] ?? '');

    // Nghe position và duration stream
    player.positionStream.listen((pos) => position.value = pos);
    player.durationStream.listen((dur) {
      if (dur != null) duration.value = dur;
    });
    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  void playPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void seekTo(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}