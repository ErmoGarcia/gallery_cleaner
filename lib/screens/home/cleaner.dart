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

  @override
  _CleanerWidgetState createState() => _CleanerWidgetState();
}

/// This is the private State class that goes with CleanerWidget.
class _CleanerWidgetState extends State<CleanerWidget> {
  @override
  Widget build(BuildContext context) {

    var _gallery = context.watch<Gallery>();
    
    var media = Provider.of<File>(context);

    var image = _gallery.isImage(media.path) ? Image.memory(
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
                return _gallery.isImage(media.path) ? ImagePreview(
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
        _gallery.remove(media);
      },
    );
  }
}
