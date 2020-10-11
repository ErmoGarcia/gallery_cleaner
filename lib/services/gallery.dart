import 'dart:io';
import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class Gallery extends ChangeNotifier {

  List<File> media = [];

  Future<void> loadMedia() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String root = storageInfo[0].rootDir + '/';

    List<String> deletedList = await Filter().deleted();

    await Directory(root).list(
        recursive: true,
        followLinks: false
    ).forEach((file) {

      String path = file.path;

      if(
        path.contains('/cache/')
        || path.contains('/data/')
        || path.contains(new RegExp(r'.*\/\..*\/.'))
      ) {
        return;
      }

      if (deletedList.contains(file.path)) return;

      if(isImage(path)) {
        sortInsert(file);
      }

      // else if(isVideo(path)) {
      //   sortInsert(file);
      // }

    });

  }

  // Performs a binary search on the media list
  // and inserts the file ordered by date (more recent first)
  void sortInsert(File f1) {
    int min = 0;
    int max = this.media.length;
    int mid = min + ((max - min) >> 1);

    while (min < max) {
      mid = min + ((max - min) >> 1);
      File f2 = this.media[mid];

      int comp = f1.lastModifiedSync().compareTo(f2.lastModifiedSync());
      if (comp == 0) {
        this.media.insert(mid, f1);
        return;
      } else if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }

    this.media.insert(mid, f1);
    return;
  }

  bool isImage(path) {
    return path.endsWith('.png') || path.endsWith('.jpg');
  }

  bool isVideo(path) {
    return path.endsWith('.mp4');
  }

  void remove(media) {
    try {
      this.media.remove(media);
    } catch(e) {
      print(e);
    }

    notifyListeners();
  }
}