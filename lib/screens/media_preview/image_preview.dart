import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {

  final Uint8List image;
  final String tag;

  ImagePreview({ Key key, @required this.image, this.tag }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preview that is shown when an image is tapped on
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dismissible(
        movementDuration: Duration(milliseconds: 200),
        resizeDuration: Duration(milliseconds: 100),
        key: ValueKey(tag),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Hero(
          tag: tag,
          child: Image.memory(
            image,
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
          ),
        )
      ),
    );
  }
}
