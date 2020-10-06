import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {

  final image;

  ImagePreview({ Key key, @required this.image }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preview that is shown when an image is tapped on
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: image
      ),
    );
  }
}
