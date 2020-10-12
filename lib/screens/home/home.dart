import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/buttons.dart';
import 'package:mediagallerycleaner/screens/home/media_display.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  final Gallery gallery = Gallery();

  @override
  Widget build(BuildContext context) {

    // Displays the media swiper
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: <Widget>[

          ListenableProvider.value(
            value: gallery,
            child: MediaDisplayWidget()
          ),

          ListenableProvider.value(
            value: gallery,
            child: TrahsButton()
          ),

          SettingsButton(),

          AcceptButton(),

        ],
      ),
    );
  }
}
