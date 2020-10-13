import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/screens/trash/grid.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

// Shows the media that has been marked for deletion
class _TrashState extends State<Trash> {

  final Deleted _deleted = Deleted();

  List<File> _selected = [];
  List<File> _mediaList = [];
  bool _loading = true;

  // Gets the media marked as deleted from the DB
  _loadMedia() async {
    List<Deleted> deletedList = await _deleted.select().toList();
    List<File> list = deletedList.map((deleted) => File(deleted.path)).toList();

    // Saves the media list and stops the loading animation
    setState(() {
      _mediaList.addAll(list);
      _loading = false;
    });
  }

  // Deletes the media from the phone gallery
  _emptyTrash() async {
    for(File media in _mediaList) {
      try {
        await media.delete();

        final cacheDir = await getTemporaryDirectory();

        if (cacheDir.existsSync()) {
          cacheDir.deleteSync(recursive: true);
        }
      } catch (e) {
        print(e);
      }
    }

    final result = await _deleted.select().delete();
    print(result.toString());

    setState(() {
      _loading = false;
      _mediaList.clear();
    });
  }

  _recoverSelected(gallery) async {

    for (File file in _selected) {
      gallery.add(file);
      final result = await _deleted.select().path.equals(file.path).delete();
      print(result.toString());
    }

    setState(() {
      _loading = false;
      print(_selected);
      _mediaList.removeWhere((file) => _selected.contains(file));
      _selected.clear();
      print(_selected);
    });
  }

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
        title: Text(_selected.isEmpty
            ? 'Trash'
            : '${_selected.length} selected',
        style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20.0), ),
        backgroundColor: Colors.purpleAccent,
        actions: <Widget>[

          // On tap: empties the trash and deletes the media from the phone
          InkWell(
              onTap: () async {
                if(_mediaList.isNotEmpty && _selected.isEmpty) {
                  _emptyTrash();
                  setState(() {
                    _loading = true;
                  });
                } else if(_selected.isNotEmpty) {
                  _recoverSelected(_gallery);
                  setState(() {
                    _loading = true;
                  });
                }
              },
            child: Row(
              children: <Widget>[
                // Empty button
                Icon(
                  _selected.isEmpty ? Icons.delete : Icons.file_upload,
                  color: Colors.white,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(5.0, 0, 20.0, 0),
                  child: Text(
                    _selected.isEmpty ? 'Empty' : 'Recover',
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
      body: _mediaList.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: _mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2),
          itemBuilder: (context, index) {

            // Media item
            return InkWell(
              onTap: () {
                setState(() {
                  _selected.contains(_mediaList[index])
                      ? _selected.remove(_mediaList[index])
                      : _selected.add(_mediaList[index]);
                });
              },

              // On long press select for recovery
              onLongPress: () {
                if(_selected.isEmpty) {
                  setState(() {
                    _selected.add(_mediaList[index]);
                  });
                }
              },
              child: AbsorbPointer(
                absorbing: _selected.isNotEmpty,
                child: TrashGridWidget(
                  media: _mediaList[index],
                  key: Key(index.toString()),
                  isSelected: _selected.contains(_mediaList[index]),
                  isImage: _gallery.isImage(_mediaList[index].path),
                ),
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
      ),
    );
  }
}
