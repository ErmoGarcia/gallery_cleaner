import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mediagallerycleaner/model/model.dart';
import 'package:mediagallerycleaner/services/gallery.dart';
import 'package:path_provider/path_provider.dart';

class TrashGallery extends ChangeNotifier {

  final Deleted db = Deleted();

  List<File> mediaList = [];
  List<File> selectedList = [];

  void switchSelect(File media, bool isSelected) {
    if(isSelected) {
      this.selectedList.remove(media);
      if(this.selectedList.isEmpty) {notifyListeners();}
    } else {
      this.selectedList.add(media);
    }
    // notifyListeners();
  }

  Future<void> loadMedia() async {
    List<Deleted> deletedList = await db.select().toList();
    List<File> list = deletedList.map((deleted) => File(deleted.path)).toList();

    this.mediaList.addAll(list);
  }

  Future<void> emptyTrash() async {
    for(File media in this.mediaList) {
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

    final result = await db.select().delete();
    print(result.toString());

    this.mediaList.clear();
    notifyListeners();
  }

  Future<void> recoverSelected(Gallery gallery) async {
    for (File file in this.selectedList) {
      gallery.add(file);
      final result = await db.select().path.equals(file.path).delete();
      print(result.toString());
    }

    this.mediaList.removeWhere((file) => this.selectedList.contains(file));
    this.selectedList.clear();
    notifyListeners();
  }

}