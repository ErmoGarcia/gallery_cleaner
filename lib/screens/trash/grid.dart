import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/thumbnails/video_thumbnail.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/screens/media_preview/video_preview.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:provider/provider.dart';

class TrashGridWidget extends StatefulWidget {

  final Key key;
  final File media;
  final bool isSelected;
  final bool isImage;

  TrashGridWidget({
    this.key,
    @required this.media,
    this.isSelected,
    this.isImage
  }) : super(key: key);

  @override
  _TrashGridWidgetState createState() => _TrashGridWidgetState();
}


class _TrashGridWidgetState extends State<TrashGridWidget> {

  @override
  Widget build(BuildContext context) {

    // Tries to retrieve the media thumbnails from phone gallery
    var image = widget.isImage ? Image.memory(
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
              return widget.isImage ? ImagePreview(
                  image: widget.media.readAsBytesSync()
              ) : Provider.value(
                    value: widget.media, child: VideoPreview()
                );
            },
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: widget.isSelected ? EdgeInsets.all(15) : EdgeInsets.all(0),
            child: image,
          ),
          widget.isSelected
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