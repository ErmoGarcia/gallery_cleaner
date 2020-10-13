import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/trash/grid.dart';
import 'package:mediagallerycleaner/screens/trash/trash.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/services/trash_gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

// Shows the media that has been marked for deletion
class _RecoveryState extends State<Recovery> {

  bool _loading = false;

  _recoverSelected(TrashGallery trash, Gallery gallery) async {
    trash.recoverSelected(gallery);

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    Gallery _gallery = Provider.of<Gallery>(context, listen: false);
    TrashGallery _trash = Provider.of<TrashGallery>(context, listen: false);

    // Loading animation
    if(_loading) {
      return Loading();
    }

    // Displays the media grid
    return Scaffold(
      backgroundColor: Colors.grey[850],

      // Bar containing the title and "empty" button
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _trash.selectedList.clear();
                Navigator.of(context).pop();
              },
            );
          },
        ),
        centerTitle: true,
        title: ChangeNotifierProvider.value(
          value: _trash,
          child: Builder(
            builder: (BuildContext context) {
              context.watch<TrashGallery>();
              return Text(
                '${_trash.selectedList.length} selected',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              );
            },
          ),
        ),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[

          // On tap: empties the trash and deletes the media from the phone
          InkWell(
              onTap: () async {
                if(_trash.selectedList.isNotEmpty) {
                  _recoverSelected(_trash, _gallery);
                  Navigator.pop(context);
                }
              },
              child: Row(
                children: <Widget>[
                  // Empty button
                  Icon(
                    Icons.file_upload,
                    color: Colors.white,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
                    child: Text(
                      'Recover',
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
      body: _trash.mediaList.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _trash.mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemBuilder: (context, index) {

            // Media item
            return TrashGridWidget(
              media: _trash.mediaList[index],
              key: Key(index.toString()),
              isSelected: _trash.selectedList.contains(_trash.mediaList[index]),
              selectMode: true,
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
      ),
    );
  }
}
