import 'package:get/get.dart';

import '../controllers/play_music_controller.dart';

class PlayMusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayMusicController>(
      () => PlayMusicController(),
    );
  }
}
