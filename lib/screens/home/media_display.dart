import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/home/animations/cloud_animation.dart';
import 'package:mediagallerycleaner/screens/home/animations/delete_animation.dart';
import 'package:mediagallerycleaner/screens/home/thumbnails/video_thumbnail.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/screens/media_preview/video_preview.dart';

// Permission handle for iOS and Android
import 'package:permission_handler/permission_handler.dart';

import 'package:mediagallerycleaner/screens/home/cleaner.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class MediaDisplayWidget extends StatefulWidget {
  @override
  _MediaDisplayWidgetState createState() => _MediaDisplayWidgetState();
}

// Shows the media carousel from newest to oldest
class _MediaDisplayWidgetState extends State<MediaDisplayWidget> {

  final ctrl = PageController(viewportFraction: 0.8);

  Gallery _gallery;
  List<File> _mediaList = [];
  bool _loading = true;
  int currentPage = 0;

  // Gets the media from the gallery (except deleted)
  _loadImages(Gallery gallery) async {

    if (await Permission.storage.request().isGranted) {
      await gallery.loadMedia();

      // Saves the media list and stops the loading animation
      setState(() {
        _gallery = gallery;
        _mediaList = gallery.media;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final Gallery gallery = Provider.of<Gallery>(context, listen: false);
    gallery.addListener(() {
      setState(() {
        _mediaList = gallery.media;
      });
    });

    _loadImages(gallery);

    ctrl.addListener(() {
      int next = ctrl.page.round();

      if(currentPage != next) {
        ctrl.animateToPage(
            next,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut
        );

        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // Loading animation
    if(_loading) {
      return Loading();
    }

    // Displays a message if there is no media
    if(_mediaList.isEmpty) {
      return Center(
        child: Text(
          'There are no more images',
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24.0
          ),
        ),
      );
    }

    return PageView.builder(
      controller: ctrl,
      itemCount: _mediaList.length,
      itemBuilder: (context, index) {

        bool active = index == currentPage;
        return _buildMediaPage(_mediaList[index], active, index);
      },
      scrollDirection: Axis.horizontal,
    );
  }



  _buildMediaPage(File media, bool active, int index) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double margin = active ? 10 : 20;


    // var image = Gallery().isImage(media.path)
    //     ? Image.file(media)
    //     : Provider.value(
    //       value: media,
    //       child: VideoThumbnail()
    //     );

    var image = Image.file(
      media,
      width: 300,
    );

    // Media thumbnail
    return Dismissible(
        resizeDuration: null,
        background: DeleteAnimation(),
        secondaryBackground: CloudAnimation(),

        child: Column(
          children: <Widget>[
            Expanded(child: Container(),),
            AnimatedContainer(
              margin: EdgeInsets.symmetric(horizontal: 30),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(
                    color: Colors.black87,
                    blurRadius: blur,
                    offset: Offset(offset, offset)
                )],
              ),
              child: GestureDetector(
                child: Hero(
                  tag: 'media_$index',
                    child: image
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Gallery().isImage(media.path) ? ImagePreview(
                            image: media.readAsBytesSync(),
                            index: index
                        ) : Provider.value(
                            value: media, child: VideoPreview()
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(child: Container(),)
          ],
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

            Deleted dbInstance = Deleted();

            dbInstance.path = media.path;
            dbInstance.date = media.lastModifiedSync();
            dbInstance.cloud = false;

            await dbInstance.save();
          }

          // Remove from swiper
          _gallery.remove(media);
        },
    );
  }
}