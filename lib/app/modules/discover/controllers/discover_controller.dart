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
      'image': 'assets/images/SleepSounds/Ocean_waves.jpg',
    },
    {
      'title': 'Rainfall',
      'subtitle': 'Calm Rain Sounds',
      'image': 'assets/images/SleepSounds/Rainfall.jpeg',
    },
    {
      'title': 'Forest Birds',
      'subtitle': 'Nature Sounds',
      'image': 'assets/images/SleepSounds/Forest_birds.jpeg',
    },
    {
      'title': 'Wind Blowing',
      'subtitle': 'Gentle Breeze',
      'image': 'assets/images/SleepSounds/Wind_blowing.webp',
    },
    {
      'title': 'Night Crickets',
      'subtitle': 'Peaceful Night',
      'image': 'assets/images/SleepSounds/Night_crickets.jpg',
    },
    {
      'title': 'Fireplace',
      'subtitle': 'Crackling Fire',
      'image': 'assets/images/SleepSounds/Fireplace.webp',
    },
    {
      'title': 'River Stream',
      'subtitle': 'Flowing Water',
      'image': 'assets/images/SleepSounds/River_stream.jpeg',
    },
    {
      'title': 'Thunderstorm',
      'subtitle': 'Distant Thunder',
      'image': 'assets/images/SleepSounds/Thunderstorm.jpeg',
    },
    {
      'title': 'Wind Chimes',
      'subtitle': 'Calm Vibration',
      'image': 'assets/images/SleepSounds/Wind_chimes.webp',
    },
    {
      'title': 'Underwater World',
      'subtitle': 'Deep Ocean Humming',
      'image': 'assets/images/SleepSounds/Underwater_world.webp',
    },
  ];

  final musicList = <Map<String, String?>>[
    {
      'title': 'Peaceful Piano',
      'duration': '15 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'image': 'assets/images/Music/Peaceful_piano.jpg',
    },
    {
      'title': 'Calming Guitar',
      'duration': '20 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      'image': 'assets/images/Music/Calming_guitar.webp',
    },
    {
      'title': 'Deep Sleep',
      'duration': '25 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      'image': 'assets/images/Music/Deep_sleep.jpeg',
    },
    {
      'title': 'Harp Healing',
      'duration': '18 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      'image': 'assets/images/Music/Harp_healing.jpg',
    },
    {
      'title': 'Chill Beats',
      'duration': '22 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      'image': 'assets/images/Music/Chill_beats.webp',
    },
    {
      'title': 'Ambient Rain',
      'duration': '12 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      'image': 'assets/images/Music/Ambient_rain.jpg',
    },
    {
      'title': 'Soft Piano',
      'duration': '16 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      'image': 'assets/images/Music/Soft_piano.jpg',
    },
    {
      'title': 'Dreamy Synths',
      'duration': '14 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
      'image': 'assets/images/Music/Dreamy_synths.jpg',
    },
    {
      'title': 'Gentle Guitar',
      'duration': '19 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
      'image': 'assets/images/Music/Gentle_guitar.webp',
    },
    {
      'title': 'Soothing Flute',
      'duration': '21 min',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
      'image': 'assets/images/Music/Soothing_flute.jpg',
    },
  ];

  final storiesList = <Map<String, String?>>[
    {
      'title': 'The Sleepy Forest',
      'subtitle': 'A soothing bedtime story.',
      'image': 'assets/images/Stories/The_sleepy_forest.jpeg',
    },
    {
      'title': 'Moonlight Magic',
      'subtitle': 'A relaxing tale under the stars.',
      'image': 'assets/images/Stories/Moonlight_magic.jpg',
    },
    {
      'title': 'Dreamland Adventures',
      'subtitle': 'Journey to a peaceful sleep.',
      'image': 'assets/images/Stories/Dreamland_adventures.jpeg',
    },
    {
      'title': 'Starlit Meadow',
      'subtitle': 'Explore the meadow of dreams.',
      'image': 'assets/images/Stories/Starlit_meadow.jpeg',
    },
    {
      'title': 'Luna the Owl',
      'subtitle': 'A wise owl’s sleepy journey.',
      'image': 'assets/images/Stories/Luna_the_owl.jpg',
    },
    {
      'title': 'The Whispering Tree',
      'subtitle': 'A magical story in a forest.',
      'image': 'assets/images/Stories/The_whispering_tree.jpg',
    },
    {
      'title': 'The Cloud Rider',
      'subtitle': 'Fly through the clouds to sleep.',
      'image': 'assets/images/Stories/The_cloud_rider.jpg',
    },
    {
      'title': 'Dandelion Dreams',
      'subtitle': 'Wishes in the wind.',
      'image': 'assets/images/Stories/Dandelion_dreams.webp',
    },
    {
      'title': 'Snowy Tales',
      'subtitle': 'A winter night’s story.',
      'image': 'assets/images/Stories/Snowy_tales.jpg',
    },
    {
      'title': 'Aurora Nights',
      'subtitle': 'Follow the lights to dreamland.',
      'image': 'assets/images/Stories/Aurora_nights.webp',
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