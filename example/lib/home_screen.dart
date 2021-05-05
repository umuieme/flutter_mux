import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mux/flutter_mux.dart';
import 'package:flutter_mux_example/video_player_screen.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? videoPath =
      "/data/user/0/com.umuieme.flutter_mux_example/cache/file_picker/20210421_101444.mp4";
  String? audioPath =
      "/data/user/0/com.umuieme.flutter_mux_example/cache/file_picker/bored_in_house.m4a";

  @override
  initState() {
    super.initState();
  }

  pickVideo() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [".mp4"]);
    if (result != null) {
      videoPath = result.files.single.path;
      setState(() {});
    }
  }

  pickAudio() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [".aac", ".m4a"]);
    if (result != null) {
      audioPath = result.files.single.path;
      setState(() {});
    }
  }

  mixAudioVideo() async {
    Directory temp = await getTemporaryDirectory();
    String outputPath =
        "${temp.path}/${DateTime.now().millisecondsSinceEpoch}.mp4";
    print("mixaudio video === $outputPath");
    var result =
        await FlutterMux.mixAudioAndVideo(outputPath, audioPath!, videoPath!);
    if (result) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => VideoPlayerScreen(outputPath)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not mix audio and video")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Video Mixing'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(videoPath ?? "N/A"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: this.pickVideo,
                child: Text("Pick a video"),
              ),
              SizedBox(height: 20),
              Text(audioPath ?? "N/A"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: this.pickAudio,
                child: Text("Pick an Audio"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: videoPath != null && audioPath != null
                    ? this.mixAudioVideo
                    : null,
                child: Text("Mix Audio Video"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
