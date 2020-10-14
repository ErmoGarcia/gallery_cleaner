import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/screens/home/animations/cloud_animation.dart';
import 'package:mediagallerycleaner/screens/home/animations/delete_animation.dart';
import 'package:mediagallerycleaner/screens/home/thumbnails/video_thumbnail.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/media_preview/video_preview.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class CleanerWidget extends StatefulWidget{

  final Key key;
  final File media;
  final VoidCallback sendToTrash;

  CleanerWidget({
    this.key,
    @required this.media,
    this.sendToTrash
  }) : super(key: key);

  @override
  _CleanerWidgetState createState() => _CleanerWidgetState();
}

/// This is the private State class that goes with CleanerWidget.
class _CleanerWidgetState extends State<CleanerWidget> {

  File media;

  @override
  void initState() {
    super.initState();
    setState(() {
      media = widget.media;
    });
  }

  @override
  Widget build(BuildContext context) {

    var media = Provider.of<File>(context);

    var image = Gallery().isImage(media.path) ? Image.memory(
        media.readAsBytesSync(),
        width: 300,
      ) : Provider.value(
          value: media,
          child: VideoThumbnail()
      );

    // Media thumbnail
    return Dismissible(
      resizeDuration: null,
      background: DeleteAnimation(),
      secondaryBackground: CloudAnimation(),

      // On tap: load preview
      child: GestureDetector(
        child: image,
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Gallery().isImage(media.path) ? ImagePreview(
                    image: media.readAsBytesSync()
                ) : Provider.value(
                    value: media, child: VideoPreview()
                );
              },
            ),
          );
        },
      ),
      key: ValueKey(media),
      direction: DismissDirection.vertical,

      // On swipe vertical:
      onDismissed: (direction) async {

        // If swiped up: send to cloud
//             if(direction == DismissDirection.up) {
//               Deleted image = Deleted();
//               image.img_id = _mediaList[index].id;
//               image.date = _mediaList[index].createDateTime;
//               image.cloud = true;
//
//               await image.save();
//             }

        // If swiped down: delete
        if(direction == DismissDirection.down) {

          Deleted image = Deleted();

          image.path = media.path;
          image.date = media.lastModifiedSync();
          image.cloud = false;

          await image.save();
        }

        // Remove from swiper
        // _gallery.remove(media);
      },
    );
  }
}
