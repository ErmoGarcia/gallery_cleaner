import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/thumbnails/video_thumbnail.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/screens/media_preview/video_preview.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/services/trash_gallery.dart';
import 'package:provider/provider.dart';

class TrashGridWidget extends StatefulWidget {

  final Key key;
  final File media;
  final bool isSelected;
  final bool selectMode;

  TrashGridWidget({
    this.key,
    @required this.media,
    this.isSelected,
    this.selectMode,
  }) : super(key: key);

  @override
  _TrashGridWidgetState createState() => _TrashGridWidgetState();
}


class _TrashGridWidgetState extends State<TrashGridWidget> {

  bool isSelected;

  @override
  void initState() {
    super.initState();
    setState(() {
      isSelected = widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {

    TrashGallery trash = Provider.of<TrashGallery>(context);

    // Tries to retrieve the media thumbnails from phone gallery
    var image = Gallery().isImage(widget.media.path) ? Image.memory(
          widget.media.readAsBytesSync(),
          width: 300,
        ) : Provider.value(
            value: widget.media,
            child: VideoThumbnail()
          );

    return InkWell(
      // On tap: load media preview
      onTap: (){
        if(widget.selectMode) {
          trash.switchSelect(widget.media, isSelected);

          if(trash.selectedList.isEmpty) {
            Navigator.pop(context);
          }

          setState(() {
            isSelected = !isSelected;
          });
        }

        else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Gallery().isImage(widget.media.path) ? ImagePreview(
                    media: widget.media
                ) : Provider.value(
                    value: widget.media, child: VideoPreview()
                );
              },
            ),
          );
        }
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: isSelected ? EdgeInsets.all(15) : EdgeInsets.all(0),
            child: Hero(tag: widget.media.path, child: image),
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
              : (widget.selectMode ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey[50],
              ),
            ),
          ) : Container())
        ]
      ),
    );
  }
}