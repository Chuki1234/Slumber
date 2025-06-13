import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DiscoverController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final ScrollController scrollController = ScrollController();

  final RxInt playingIndex = (-1).obs;
  final RxBool isPlaying = false.obs;

  late AudioPlayer player;

  final soundsList = <Map<String, String?>>[
    {
      'title': 'Ocean Waves',
      'subtitle': 'Relaxing Water Sounds',
      'tag': 'New',
      'image': null,
    },
    {
      'title': 'Rainfall',
      'subtitle': 'Calm Rain Sounds',
      'tag': 'Popular',
      'image': null,
    },
    {
      'title': 'Forest Birds',
      'subtitle': 'Nature Sounds',
      'tag': null,
      'image': null,
    },
  ];

  final musicList = <Map<String, String?>>[
    {
      'title': 'Peaceful Piano',
      'duration': '15 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': null,
    },
    {
      'title': 'Calming Guitar',
      'duration': '20 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'image': null,
    },
  ];

  final storiesList = <Map<String, String?>>[
    {
      'title': 'The Sleepy Forest',
      'subtitle': 'A soothing bedtime story.',
    },
    {
      'title': 'Moonlight Magic',
      'subtitle': 'A relaxing tale under the stars.',
    },
    {
      'title': 'Dreamland Adventures',
      'subtitle': 'Journey to a peaceful sleep.',
    },
  ];

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
      await player.setUrl(musicList[index]['url'] ?? '');
      await player.play();
    }
  }

  void stopMusic() async {
    await player.stop();
    isPlaying.value = false;
    playingIndex.value = -1;
  }
}