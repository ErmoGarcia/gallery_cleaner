import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/buttons.dart';
import 'package:mediagallerycleaner/screens/home/media_display.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:mediagallerycleaner/shared/loading.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Displays the media swiper
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: <Widget>[

          MediaDisplayWidget(),

          TrahsButton(),

          SettingsButton(),

          AcceptButton(),

        ],
      ),
    );
  }
}
