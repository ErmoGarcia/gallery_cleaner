import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/cleaner.dart';
import 'package:mediagallerycleaner/screens/home/buttons.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _gallery = Gallery();

  bool _loading = true;

  // Gets the media from the gallery (except deleted)
  _loadImages() async {

    await _gallery.loadMedia();
    print(_gallery.images);

    // Saves the media list and stops the loading animation
    setState(() {
      _loading = false;
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
    if(_gallery.images.isEmpty) {
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
