import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/cleaner.dart';
import 'package:mediagallerycleaner/screens/home/buttons.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _gallery = GalleryAccess();

  var _mediaList;
  bool _loading = true;

  // Gets the media from the gallery (except deleted)
  _loadImages() async {
    await _gallery.getGalleryPath();
    await _gallery.deleteCacheDir();
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
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
              value: _gallery,
          ),

          ChangeNotifierProvider.value(
            value: _gallery,
          ),
        ],

        child: Stack(
          children: <Widget>[

            CleanerWidget(),

            TrahsButton(),

            SettingsButton(),

            AcceptButton(),

          ],
        ),
      ),
    );
  }
}
