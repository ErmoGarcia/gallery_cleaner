import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/animations/cloud_animation.dart';
import 'package:mediagallerycleaner/screens/home/animations/delete_animation.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:mediagallerycleaner/services/process_media.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:photo_manager/photo_manager.dart';

class CleanerWidget extends StatefulWidget {
  @override
  _CleanerWidgetState createState() => _CleanerWidgetState();
}

class _CleanerWidgetState extends State<CleanerWidget> {

  final _controller = PageController(viewportFraction: 0.8);
  final _processor = MediaProcessor();
  final _gallery = GalleryAccess();

  var _mediaList;
  bool _loading = true;

  // Gets the media from the gallery (except deleted)
  _loadImages() async {
    await _gallery.getGalleryPath();
    await _gallery.getMediaFromGallery();

    // Saves the media list and stops the loading animation
    setState(() {
      _loading = false;
      _mediaList = _gallery.list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
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

    // Displays the media swiper
    return PageView.builder(
      controller: _controller,
      itemCount: _mediaList.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),

              // Loads the media thumbnails when it gets them
              child: FutureBuilder(
                future: _mediaList[index].thumbDataWithSize(300, 300),
                builder: (context, snapshot) {

                  // Tries to retrieve the media thumbnails from phone gallery
                  if(snapshot.connectionState == ConnectionState.done) {
                    var image = _processor.getMediaFromAsset(
                        _mediaList[index], snapshot.data
                    );
                    var imagePreview = _processor.getMediaFromAsset(
                        _mediaList[index], snapshot.data, BoxFit.contain
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
                      key: ValueKey(_mediaList[index]),
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
                          String path = _mediaList[index].relativePath + _mediaList[index].title;
                          print('Path: ${path}');
                          Deleted image = Deleted();
                          image.img_id = _mediaList[index].id;
                          image.path = path;
                          image.date = _mediaList[index].createDateTime;
                          image.cloud = false;

                          await image.save();
                        }

                        // Remove from swiper
                        setState(() => _mediaList.removeAt(index));
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
