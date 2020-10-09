import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/animations/cloud_animation.dart';
import 'package:mediagallerycleaner/screens/home/animations/delete_animation.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:mediagallerycleaner/services/process_media.dart';
import 'package:provider/provider.dart';

class CleanerWidget extends StatelessWidget{

  final File media;

  CleanerWidget({
    Key key,
    @required this.media,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _controller = PageController(viewportFraction: 0.8);
    final _processor = MediaProcessor();

    var _gallery = context.watch<Gallery>();

    return FutureBuilder(
      future: this.media.readAsBytes(),
      builder: (context, snapshot) {

        // Tries to retrieve the media thumbnails from phone gallery
        if(snapshot.connectionState == ConnectionState.done) {
//          var image = _processor.getMediaFromAsset(
//              gallery.list[index], snapshot.data
//          );
//          var imagePreview = _processor.getMediaFromAsset(
//              gallery.list[index], snapshot.data, BoxFit.contain
//          );
          var image = Image.memory(
              snapshot.data,
              width: 300,
          );

          var imagePreview = Image.memory(
            snapshot.data,
            fit: BoxFit.contain,
            height: double.infinity,
            width: double.infinity,
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
                      return ImagePreview(image: imagePreview);
                    },
                  ),
                );
              },
            ),
            key: ValueKey(this.media),
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

                image.path = this.media.path;
                image.date = this.media.lastModifiedSync();
                image.cloud = false;

                await image.save();
              }

              // Remove from swiper
              _gallery.remove(this.media);
            },
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
