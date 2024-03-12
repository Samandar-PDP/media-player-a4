import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePage extends StatefulWidget {
  const YoutubePage({super.key});

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  late YoutubePlayerController _controller;
  final TextEditingController _editingController = TextEditingController();
  bool _canPop = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: "FDgGzZoLbAg",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.reset();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, or) {
        return PopScope(
          canPop: _canPop,
          onPopInvoked: (v) async {
            if(v) {
              return;
            }
            if(or == Orientation.landscape) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp
              ]);
            } else {
              _canPop = true;
              setState(() {

              });
          }
          },
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(or == Orientation.landscape ? 0 : 16.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: or == Orientation.portrait ? 220 : MediaQuery.of(context).size.height - 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.greenAccent,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.greenAccent,
                          handleColor: Colors.greenAccent,
                        ),
                        onReady: () {
                          // _controller.addListener();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _editingController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () {
                    _controller.load(_editingController.text);
                    setState(() {});
                  }, child: const Text("Play"))
                ],
              ),
            )
          ),
        );
      }
    );
  }
}
