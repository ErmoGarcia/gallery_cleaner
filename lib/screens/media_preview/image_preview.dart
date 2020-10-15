import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {

  final File media;

  ImagePreview({ Key key, @required this.media }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preview that is shown when an image is tapped on
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dismissible(
        movementDuration: Duration(milliseconds: 0),
        resizeDuration: Duration(milliseconds: 100),
        dismissThresholds: {
          DismissDirection.up: 0.2, DismissDirection.down: 0.2
        },
        key: ValueKey(media.path),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Hero(
          tag: media.path,
          child: Image.file(
            media,
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
          ),
        )
      ),
    );
  }
}
