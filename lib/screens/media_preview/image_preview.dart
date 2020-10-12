import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {

  final Uint8List image;

  ImagePreview({ Key key, @required this.image }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preview that is shown when an image is tapped on
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dismissible(
        movementDuration: Duration(milliseconds: 0),
        dismissThresholds: {DismissDirection.vertical: 0.2},
        key: ValueKey(image),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Image.memory(
          image,
          fit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
        )
      ),
    );
  }
}
