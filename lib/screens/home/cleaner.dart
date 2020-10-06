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

  var _mediaList;
  bool _loading = true;

  _loadImages() async {
//    var list = List<Uint8List>.from(await MediaProcessor().getMediaList());
    var list = await GalleryAccess().getMediaFromGallery();
    setState(() {
      _loading = false;
      _mediaList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {

    if(_loading) {
      return Loading();
    }

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
      controller: _controller,
      itemCount: _mediaList.length,
      itemBuilder: (context, index) {
        return Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder(
                future: _mediaList[index].thumbDataWithSize(300, 300),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    var image = _processor.getMediaFromAsset(
                        _mediaList[index], snapshot.data
                    );
                    var imagePreview = _processor.getMediaFromAsset(
                        _mediaList[index], snapshot.data, BoxFit.contain
                    );

                    return Dismissible(
                      resizeDuration: null,
                      background: DeleteAnimation(),
                      secondaryBackground: CloudAnimation(),
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
                      onDismissed: (direction) async {

//                         if(direction == DismissDirection.up) {
//                           Deleted image = Deleted();
//                           image.img_id = _mediaList[index].id;
//                           image.date = _mediaList[index].createDateTime;
//                           image.cloud = true;
//
//                           await image.save();
//                         }

                        if(direction == DismissDirection.down) {
                          Deleted image = Deleted();
                          image.img_id = _mediaList[index].id;
                          image.date = _mediaList[index].createDateTime;
                          image.cloud = false;

                          await image.save();
                        }

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
