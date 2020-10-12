import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool _loading = true;
  File _media;

  _loadVideo(media) async {
    print(media);
    _controller = VideoPlayerController.file(media);

    _controller.setLooping(true);
    _controller.setVolume(1.0);
    _controller.initialize().then((_) =>
        setState(() {
          _media = media;
          _loading= false;
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
      body: Stack(
        children: <Widget>[
          Dismissible(
            movementDuration: Duration(milliseconds: 0),
            dismissThresholds: {DismissDirection.vertical: 0.2},
            key: ValueKey(_media),
            direction: DismissDirection.vertical,
            onDismissed: (direction) {
              Navigator.pop(context);
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if(_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_controller),
                      Center(
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          color: Colors.white,
                          size: 100.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}