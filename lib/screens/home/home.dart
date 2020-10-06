import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/home/cleaner.dart';
import 'package:mediagallerycleaner/screens/trash/trash.dart';

// Loads when the app is opened
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: <Widget>[

          // The media swiper
          CleanerWidget(),

          // Settings button
          Align(
            alignment: Alignment.topRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.settings, color: Colors.grey[850]),
                  backgroundColor: Colors.grey[400],
                  onPressed: () {},
                ),
              ),
            ),
          ),

          // Done button
          Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.check, color: Colors.grey[850]),
                  backgroundColor: Colors.greenAccent,
                  onPressed: () {},
                ),
              ),
            ),
          ),

          // Trash button
          Align(
            alignment: Alignment.bottomRight,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.delete_forever, color: Colors.grey[850]),
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Trash()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
