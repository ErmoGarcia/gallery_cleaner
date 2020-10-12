import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget{

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

/// This is the private State class that goes with VideoPreview.
class _VideoPreviewState extends State<VideoPreview> {

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _loading = true;

  _loadVideo(media) async {
    print(media);
    _controller = VideoPlayerController.file(media);

    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _controller.initialize().then((_) =>
        setState(() {
          _loading= false;
          _controller.play();
        }));
  }

  @override
  void initState() {
    super.initState();

    final File media = Provider.of<File>(context, listen: false);
    _loadVideo(media);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(_loading) {
      return Loading();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      )
    );
  }
}