import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen(this.videoPath);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  initialize() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));
    await _controller.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,

        autoInitialize: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _controller.value.isInitialized
          ? Chewie(
            controller: _chewieController,
          )
          : CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }
}
