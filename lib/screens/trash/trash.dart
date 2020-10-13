import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/trash/grid.dart';
import 'package:mediagallerycleaner/screens/trash/recovery/recovery.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/services/trash_gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

// Shows the media that has been marked for deletion
class _TrashState extends State<Trash> {

  final TrashGallery trash = TrashGallery();

  bool _loading = true;

  // Gets the media marked as deleted from the DB
  _loadMedia() async {
    await trash.loadMedia();

    // Saves the media list and stops the loading animation
    setState(() {
      _loading = false;
    });
  }

  // Deletes the media from the phone gallery
  _emptyTrash() async {
    await trash.emptyTrash();

    setState(() {
      _loading = false;
    });
  }

  // _recoverSelected(gallery) async {
  //
  //   for (File file in _selected) {
  //     gallery.add(file);
  //     final result = await _deleted.select().path.equals(file.path).delete();
  //     print(result.toString());
  //   }
  //
  //   setState(() {
  //     _loading = false;
  //     print(_selected);
  //     _mediaList.removeWhere((file) => _selected.contains(file));
  //     _selected.clear();
  //     print(_selected);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  @override
  Widget build(BuildContext context) {

    Gallery _gallery = Provider.of<Gallery>(context, listen: false);

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
        title: Text(
          'Trash',
          style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20.0),
        ),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[

          // On tap: empties the trash and deletes the media from the phone
          InkWell(
              onTap: () async {
                if(trash.mediaList.isNotEmpty) {
                  _emptyTrash();
                  setState(() {
                    _loading = true;
                  });
                }
              },
            child: Row(
              children: <Widget>[
                // Empty button
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
                  child: Text(
                    'Empty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18.0
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),


      // Grid containing the media
      body: ChangeNotifierProvider.value(
        value: trash,
        child: Builder(
          builder: (BuildContext context) {
            context.watch<TrashGallery>();

            return trash.mediaList.isNotEmpty ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: trash.mediaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  print('IS BUILDING ITEM');
                  // Media item
                  return InkWell(
                    // On long press select for recovery
                    onLongPress: () {

                      trash.selectedList.add(trash.mediaList[index]);

                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, _, __) => MultiProvider(
                                  providers: [
                                    ListenableProvider.value(value: _gallery),
                                    ListenableProvider.value(value: trash)
                                  ],
                                  child: Recovery()
                              ),
                            transitionDuration: Duration(seconds: 0),
                          )
                      );
                    },

                    child: TrashGridWidget(
                      media: trash.mediaList[index],
                      key: Key(index.toString()),
                      isSelected: false,
                      selectMode: false,
                    ),
                  );
                },
              ),
            ) : Center(
              child: Text(
                'Trash is empty',
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 24.0
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
