import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MyYoutubePlayer extends StatefulWidget {
  MyYoutubePlayer({
    required this.id,
  });

  final String id;

  @override
  State<MyYoutubePlayer> createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<MyYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.toggleFullScreenMode();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,      
    );
  }
}