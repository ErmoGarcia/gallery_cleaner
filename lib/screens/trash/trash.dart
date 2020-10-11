import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/trash/grid.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:path_provider/path_provider.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

// Shows the media that has been marked for deletion
class _TrashState extends State<Trash> {

  final _deleted = Deleted();

  var _mediaList;
  bool _loading = true;

//  var _selected = [];

  // Gets the media marked as deleted from the DB
  _loadMedia() async {
    List<Deleted> deletedList = await _deleted.select().toList();
//    List<AssetEntity> list = await Future.wait(
//        deletedList.map((element) async {
//          return await AssetEntity.fromId(element.img_id);
//        }).toList()
//    );
    var list = deletedList.map((deleted) => File(deleted.path)).toList();

    // Saves the media list and stops the loading animation
    setState(() {
      _mediaList = list;
      _loading = false;
    });
  }

  // Deletes the media from the phone gallery
  _emptyTrash() async {
//    List<Deleted> deletedList = await _deleted.select().toList();
//    await gallery.deleteMediaFromGallery(deletedList);
    await _mediaList.forEach((media) async {
      try {
        await media.delete();

        final cacheDir = await getTemporaryDirectory();

        if (cacheDir.existsSync()) {
          cacheDir.deleteSync(recursive: true);
        }
      } catch (e) {
        print(e);
      }
    });

    await _deleted.select().delete();
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  @override
  Widget build(BuildContext context) {

    // Loading animation
    if(_loading) {
      return Loading();
    }


    // Displays the media grid
    return Scaffold(
      backgroundColor: Colors.grey[850],

      // Bar containing the title and "empty" button
      appBar: AppBar(
        centerTitle: true,
        title: Text('Trash'),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[

          // Empty button
          Icon(Icons.delete, color: Colors.white,),

          // On tap: empties the trash and deletes the media from the phone
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

            // Empty button text
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
      body: _mediaList != null ? GridView.builder(
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
          return TrashGridWidget(media: _mediaList[index]);
        },
      ) : Center(
        child: Text(
          'Trash is empty',
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24.0
          ),
        ),
      ),
    );
  }
}
