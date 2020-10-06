import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/media_preview/image_preview.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:mediagallerycleaner/services/process_media.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:photo_manager/photo_manager.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {

  final _deleted = Deleted();
  final _processor = MediaProcessor();

  var _mediaList;
  bool _loading = true;

//  var _selected = [];

  _getDeletedMedia() async {
    List<Deleted> deletedList = await _deleted.select().toList();
    List<AssetEntity> list = await Future.wait(
        deletedList.map((element) async {
          return await AssetEntity.fromId(element.img_id);
        }).toList()
    );

    setState(() {
      _mediaList = list;
      _loading = false;
    });
  }

  _emptyTrash() async {
    GalleryAccess().deleteMediaFromGallery(_mediaList);
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
    if(_loading) {
      return Loading();
    }

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

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Deleted Media'),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[
          Icon(Icons.delete, color: Colors.white,),
          GestureDetector(
            onTap: () async {
              if(_mediaList != null) {
                _emptyTrash();
                setState(() {
                  _loading = true;
                  _mediaList = null;
                });
              }
            },
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


      body: GridView.builder(
        itemCount: _mediaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          var color;
//          if(_selected != null && _selected.contains(index)) {
//            color = Colors.indigoAccent;
//          } else {
//            color = Colors.grey[850];
//          }

          return Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: color,
            ),
            child: FutureBuilder(
              future: _mediaList[index].thumbDataWithSize(200, 200),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var image = _processor.getMediaFromAsset(
                      _mediaList[index], snapshot.data, BoxFit.cover
                  );
                  var imagePreview = _processor.getMediaFromAsset(
                      _mediaList[index], snapshot.data, BoxFit.contain
                  );

                  return GestureDetector(
                    onLongPress: () {
                      // For recovering media

//                      setState(() {
//                        _selected.add(index);
//                      });
                    },
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
