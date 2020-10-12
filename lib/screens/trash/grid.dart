import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/shared/loading.dart';

class TrashGridWidget extends StatelessWidget {

  final File media;

  TrashGridWidget({
    Key key,
    @required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // When an item is selected: change the color of the borders
    var color;
//    if(_selected != null && _selected.contains(index)) {
//      color = Colors.indigoAccent;
//    } else {
//      color = Colors.grey[850];
//    }

    // Tries to retrieve the media thumbnails from phone gallery
    var bytes = media.readAsBytesSync();

    var image = Image.memory(
      bytes,
      width: 300,
    );

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: color,
      ),

      // Shows the media thumbnails when it gets them
      child: GestureDetector(
        // On long press: media asset is selected
        onLongPress: () {
          // For recovering media

//                      setState(() {
//                        _selected.add(index);
//                      });
        },

        // On tap: load media preview
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ImagePreview(image: bytes);
              },
            ),
          );
        },
        child: image
      ),
    );
  }
}