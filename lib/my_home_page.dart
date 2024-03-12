import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/animation_builder/loop_animation_builder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  Duration maxDuration = const Duration(seconds: 0);
  late ValueListenable<Duration> progress;
  int _index = 0;
  final _musicList = ['dvrs', 'interworld', 'braz'];
  final _names = [
    'Close eyes',
    'Metamorphosis',
    'Brazil Phonk',
  ];

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // adjust duration as needed
    );
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  getDuration() {
    _audioPlayer.getDuration().then((value) {
      maxDuration = value ?? const Duration(seconds: 0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getDuration();
    return Scaffold(
      //   backgroundColor: Colors.purpleAccent,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.purpleAccent,
          Colors.indigoAccent,
        ])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Lottie.asset('assets/anim/anim_1.json',
                          height: 250,
                          width: 250,
                          animate: _audioPlayer.state == PlayerState.playing),
                      RotationTransition(
                        turns: _controller,
                        child: const Icon(
                          CupertinoIcons.music_note_2,
                          color: Colors.white,
                          size: 50,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                Text(
                  _names[_index],
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 70),
                StreamBuilder(
                    stream: _audioPlayer.onPositionChanged,
                    builder: (context, snapshot) {
                      return ProgressBar(
                        thumbColor: Colors.white,
                        thumbGlowColor: Colors.white,
                        timeLabelTextStyle:
                            const TextStyle(color: Colors.white),
                        progress: snapshot.data ?? const Duration(seconds: 0),
                        total: maxDuration,
                        onSeek: (duration) {
                          _audioPlayer.seek(duration);
                          setState(() {});
                        },
                      );
                    }),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_index > 0) {
                          setState(() {
                            _index--;
                          });
                          _audioPlayer.play(
                              AssetSource('audio/${_musicList[_index]}.mp4'));
                        }
                      },
                      icon: const Icon(CupertinoIcons.backward_end_alt),
                      color: Colors.white,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                      child: IconButton(
                          onPressed: _playOrStop,
                          icon: Icon(
                              _audioPlayer.state == PlayerState.playing
                                  ? CupertinoIcons.pause
                                  : CupertinoIcons.play,
                              color: Colors.white)),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_index < _musicList.length - 1) {
                          setState(() {
                            _index++;
                          });
                          //_audioPlayer.release();
                          _audioPlayer.play(
                              AssetSource('audio/${_musicList[_index]}.mp3'));
                        } else {
                          setState(() {
                            _index = 0;
                          });
                        }
                      },
                      icon: const Icon(CupertinoIcons.forward_end_alt),
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _playOrStop() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
      _controller.stop();
    } else {
      _controller.repeat();
      await _audioPlayer.play(AssetSource('audio/${_musicList[_index]}.mp3'));
    }
    setState(() {});
  }

  void _playNetwork() async {
    _audioPlayer.play(UrlSource(
        'https://file-examples.com/storage/fe7b7e0dc465e22bc9e6da8/2017/11/file_example_MP3_1MG.mp4'));
    setState(() {});
  }
}
