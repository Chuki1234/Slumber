import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class DiscoverController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final ScrollController scrollController = ScrollController();

  final RxInt playingIndex = (-1).obs;
  final RxBool isPlaying = false.obs;

  late AudioPlayer player;

  final soundsList = <Map<String, String?>>[
    {
      'title': 'Ocean Waves',
      'subtitle': 'Relaxing Water Sounds',
      'image': null,
    },
    {'title': 'Rainfall', 'subtitle': 'Calm Rain Sounds', 'image': null},
    {'title': 'Forest Birds', 'subtitle': 'Nature Sounds', 'image': null},
    {'title': 'Wind Blowing', 'subtitle': 'Gentle Breeze', 'image': null},
    {'title': 'Night Crickets', 'subtitle': 'Peaceful Night', 'image': null},
    {'title': 'Fireplace', 'subtitle': 'Crackling Fire', 'image': null},
    {'title': 'River Stream', 'subtitle': 'Flowing Water', 'image': null},
    {'title': 'Thunderstorm', 'subtitle': 'Distant Thunder', 'image': null},
    {'title': 'Wind Chimes', 'subtitle': 'Calm Vibration', 'image': null},
    {
      'title': 'Underwater World',
      'subtitle': 'Deep Ocean Humming',
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
    {
      'title': 'Deep Sleep',
      'duration': '25 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'image': null,
    },
    {
      'title': 'Soothing Strings',
      'duration': '10 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      'image': null,
    },
    {
      'title': 'Harp Healing',
      'duration': '18 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      'image': null,
    },
    {
      'title': 'Chill Beats',
      'duration': '22 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      'image': null,
    },
    {
      'title': 'Ambient Rain',
      'duration': '12 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      'image': null,
    },
    {
      'title': 'Soft Piano',
      'duration': '16 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      'image': null,
    },
    {
      'title': 'Dreamy Synths',
      'duration': '14 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      'image': null,
    },
    {
      'title': 'Gentle Guitar',
      'duration': '19 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      'image': null,
    },
  ];

  final storiesList = <Map<String, String?>>[
    {'title': 'The Sleepy Forest', 'subtitle': 'A soothing bedtime story.'},
    {
      'title': 'Moonlight Magic',
      'subtitle': 'A relaxing tale under the stars.',
    },
    {
      'title': 'Dreamland Adventures',
      'subtitle': 'Journey to a peaceful sleep.',
    },
    {'title': 'Starlit Meadow', 'subtitle': 'Explore the meadow of dreams.'},
    {'title': 'Luna the Owl', 'subtitle': 'A wise owl’s sleepy journey.'},
    {
      'title': 'The Whispering Tree',
      'subtitle': 'A magical story in a forest.',
    },
    {
      'title': 'The Cloud Rider',
      'subtitle': 'Fly through the clouds to sleep.',
    },
    {'title': 'Dandelion Dreams', 'subtitle': 'Wishes in the wind.'},
    {'title': 'Snowy Tales', 'subtitle': 'A winter night’s story.'},
    {'title': 'Aurora Nights', 'subtitle': 'Follow the lights to dreamland.'},
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
