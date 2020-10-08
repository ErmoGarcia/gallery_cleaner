import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:mediagallerycleaner/services/process_media.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

// Shows the media that has been marked for deletion
class _TrashState extends State<Trash> {

  final _deleted = Deleted();
  final _processor = MediaProcessor();

  var _mediaList;
  bool _loading = true;

//  var _selected = [];

  // Gets the media marked as deleted from the DB
  _getDeletedMedia() async {
    List<Deleted> deletedList = await _deleted.select().toList();
    List<AssetEntity> list = await Future.wait(
        deletedList.map((element) async {
          return await AssetEntity.fromId(element.img_id);
        }).toList()
    );

    // Saves the media list and stops the loading animation
    setState(() {
      _mediaList = list;
      _loading = false;
    });
  }

  // Deletes the media from the phone gallery
  _emptyTrash(gallery) async {
    List<Deleted> deletedList = await _deleted.select().toList();
    await gallery.deleteMediaFromGallery(deletedList);
    await _deleted.select().delete();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _getDeletedMedia();
  }

  @override
  Widget build(BuildContext context) {

    var gallery = context.watch<GalleryAccess>();

    // Loading animation
    if(_loading) {
      return Loading();
    }

    // Displays a message if there is no media
    if(_mediaList == null) {
      return Scaffold(
        backgroundColor: Colors.grey[850],
        body: Center(
          child: Text(
            'There are no images to delete',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 24.0
            ),
          ),
        ),
      );
    }

    // Displays the media grid
    return Scaffold(
      backgroundColor: Colors.grey[850],

      // Bar containing the title and "empty" button
      appBar: AppBar(
        centerTitle: true,
        title: Text('Deleted Media'),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[

          // Empty button
          Icon(Icons.delete, color: Colors.white,),

          // On tap: empties the trash and deletes the media from the phone
          GestureDetector(
            onTap: () async {
              if(_mediaList != null) {
                _emptyTrash(gallery);
                setState(() {
                  _loading = true;
                  _mediaList = null;
                });
              }
            },

            // Displays message after trash has been emptied
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
              child: Text(
                'Empty',
                style: TextStyle(
                  color: Colors.white,
//                fontSize: 20.0
                ),
              ),
            ),
          )
        ],
      ),


      // Grid containing the media
      body: GridView.builder(
        itemCount: _mediaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {

          // When an item is selected: change the color of the borders
          var color;
//          if(_selected != null && _selected.contains(index)) {
//            color = Colors.indigoAccent;
//          } else {
//            color = Colors.grey[850];
//          }

          // Media item
          return Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: color,
            ),

            // Shows the media thumbnails when it gets them
            child: FutureBuilder(
              future: _mediaList[index].thumbDataWithSize(200, 200),
              builder: (context, snapshot) {

                // Tries to retrieve the media thumbnails from phone gallery
                if (snapshot.connectionState == ConnectionState.done) {
                  var image = _processor.getMediaFromAsset(
                      _mediaList[index], snapshot.data, BoxFit.cover
                  );
                  var imagePreview = _processor.getMediaFromAsset(
                      _mediaList[index], snapshot.data, BoxFit.contain
                  );

                  return GestureDetector(
                    // On long press: media asset is selected
                    onLongPress: () {
                      // For recovering media

//                      setState(() {
//                        _selected.add(index);
//                      });
                    },

                    // On tap: load media preview
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
                    child: image
                  );
                } else {
                  return Loading();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
