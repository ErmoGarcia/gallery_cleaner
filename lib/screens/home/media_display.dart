import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Permission handle for iOS and Android
import 'package:permission_handler/permission_handler.dart';

import 'package:mediagallerycleaner/screens/home/cleaner.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class MediaDisplayWidget extends StatefulWidget {
  @override
  _MediaDisplayWidgetState createState() => _MediaDisplayWidgetState();
}

// Shows the media carousel from newest to oldest
class _MediaDisplayWidgetState extends State<MediaDisplayWidget> {

  final _controller = PageController(viewportFraction: 0.8);

  void nextPage() async {
    await _controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void prevPage() async {
    await _controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  // final _gallery = Gallery();
  Gallery _gallery;

  List<File> _mediaList;
  bool _loading = true;

  // Gets the media from the gallery (except deleted)
  _loadImages(Gallery gallery) async {

    if (await Permission.storage.request().isGranted) {
      await gallery.loadMedia();

      // Saves the media list and stops the loading animation
      setState(() {
        _gallery = gallery;
        _mediaList = gallery.media;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final Gallery gallery = Provider.of<Gallery>(context, listen: false);
    _loadImages(gallery);
  }

  @override
  Widget build(BuildContext context) {

    // Loading animation
    if(_loading) {
      return Loading();
    }

    // Displays a message if there is no media
    if(_mediaList.isEmpty) {
      return Center(
        child: Text(
          'There are no more images',
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24.0
          ),
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _gallery,
      child: PageView.builder(
        controller: _controller,
        itemCount: _mediaList.length,
        itemBuilder: (context, index) {
          context.watch<Gallery>();

          return GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < 0) {
                nextPage();
              }
              if (details.delta.dx > 0) {
                prevPage();
              }
            },
            child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),

                  // Loads the media thumbnails when it gets them
                  child: Provider.value(
                    value: _mediaList[index],
                    child: CleanerWidget(),
                  )
                ),
            ),
          );
        },
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}