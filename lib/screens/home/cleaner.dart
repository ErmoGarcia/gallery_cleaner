import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/animations/cloud_animation.dart';
import 'package:mediagallerycleaner/screens/home/animations/delete_animation.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:mediagallerycleaner/services/process_media.dart';
import 'package:provider/provider.dart';

class CleanerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final _controller = PageController(viewportFraction: 0.8);
    final _processor = MediaProcessor();

    var gallery = context.watch<GalleryAccess>();

    return PageView.builder(
        controller: _controller,
        itemCount: gallery.list.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),

                // Loads the media thumbnails when it gets them
                child: FutureBuilder(
                    future: gallery.list[index].thumbDataWithSize(300, 300),
                    builder: (context, snapshot) {

                      // Tries to retrieve the media thumbnails from phone gallery
                      if(snapshot.connectionState == ConnectionState.done) {
                        var image = _processor.getMediaFromAsset(
                            gallery.list[index], snapshot.data
                        );
                        var imagePreview = _processor.getMediaFromAsset(
                            gallery.list[index], snapshot.data, BoxFit.contain
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
                          key: ValueKey(gallery.list[index]),
                          direction: DismissDirection.vertical,

                          // On swipe vertical:
                          onDismissed: (direction) async {

                            // If swiped up: send to cloud
//                         if(direction == DismissDirection.up) {
//                           Deleted image = Deleted();
//                           image.img_id = _mediaList[index].id;
//                           image.date = _mediaList[index].createDateTime;
//                           image.cloud = true;
//
//                           await image.save();
//                         }

                            // If swiped down: delete
                            if(direction == DismissDirection.down) {
                              String path = gallery.list[index].relativePath + gallery.list[index].title;
                              print('Path: ${path}');
                              Deleted image = Deleted();
                              image.img_id = gallery.list[index].id;
                              image.path = path;
                              image.date = gallery.list[index].createDateTime;
                              image.cloud = false;

                              await image.save();
                            }

                            // Remove from swiper
//                            setState(() => _mediaList.removeAt(index));
                            gallery.removeAtIndex(index);
                          },
                        );
                      } else {
                        return Loading();
                      }
                    }
                )
            ),
          );
        },
        scrollDirection: Axis.horizontal,
    );
  }
}
