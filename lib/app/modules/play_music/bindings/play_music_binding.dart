import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/play_music_controller.dart';

class PlayMusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayMusicController>(
      () => PlayMusicController(),
    );
  }
}