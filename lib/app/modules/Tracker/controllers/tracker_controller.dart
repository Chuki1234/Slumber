import 'package:get/get.dart';

class TrackerController extends GetxController {
  //TODO: Implement TrackerController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  final selectedSongName = 'No song selected'.obs;

  void setSelectedSong(String name) {
    selectedSongName.value = name;
  }
  void increment() => count.value++;
}
