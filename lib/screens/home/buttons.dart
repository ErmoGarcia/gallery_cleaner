import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/screens/trash/trash.dart';
import 'package:provider/provider.dart';
import 'package:mediagallerycleaner/services/gallery_access.dart';

class SettingsButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // Settings button
    return Align(
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
    );
  }
}

class AcceptButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // Done button
    return Align(
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
    );
  }
}

class TrahsButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var gallery = context.watch<GalleryAccess>();
    
    // Trash button
    return Align(
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
                MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: gallery,
                        child: Trash()
                    )
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}