import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/thumbnails/video_thumbnail.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/screens/media_preview/video_preview.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class TrashGridWidget extends StatefulWidget {

  final Key key;
  final File media;
  final ValueChanged<bool> isSelected;

  TrashGridWidget({
    this.key,
    @required this.media,
    this.isSelected
  }) : super(key: key);

  @override
  _TrashGridWidgetState createState() => _TrashGridWidgetState();
}


class _TrashGridWidgetState extends State<TrashGridWidget> {

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {

    Gallery _gallery = Provider.of<Gallery>(context, listen: false);

    // When an item is selected: change the color of the borders
    var color;
//    if(_selected != null && _selected.contains(index)) {
//      color = Colors.indigoAccent;
//    } else {
//      color = Colors.grey[850];
//    }

    // Tries to retrieve the media thumbnails from phone gallery
    var image = _gallery.isImage(widget.media.path) ? Image.memory(
          widget.media.readAsBytesSync(),
          width: 300,
        ) : Provider.value(
            value: widget.media,
            child: VideoThumbnail()
          );

    return InkWell(
      // On tap: load media preview
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return _gallery.isImage(widget.media.path) ? ImagePreview(
                  image: widget.media.readAsBytesSync()
              ) : Provider.value(
                    value: widget.media, child: VideoPreview()
                );
            },
          ),
        );
      },
      // On long press select for recovery
      onLongPress: () {
        print("selected");
        this.setState(() {
          isSelected = !isSelected;
          // widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: isSelected ? EdgeInsets.all(15) : EdgeInsets.all(0),
            child: image,
          ),
          isSelected
              ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.purpleAccent,
              ),
            ),
          )
              : Container(),
        ]
      ),
    );
  }
}