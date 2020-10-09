import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:storage_path/storage_path.dart';

class Gallery extends ChangeNotifier {

//  List<dynamic> list = [];
  List<File> images = [];
  List<File> videos = [];

  Future<void> loadMedia() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    String root = storageInfo[0].rootDir + '/';

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

      if(path.endsWith('.png') || path.endsWith('.jpg')) {
        this.images.add(file);
      }

      else if(path.endsWith('.mp4')) {
        this.videos.add(file);
      }

    });

    this.images.sort((f1, f2) =>
        f2.lastModifiedSync().compareTo(f1.lastModifiedSync())
    );
  }

  void remove(media) {
    try {
      this.images.remove(media);
    } catch(e) {
      print(e);
    }

    notifyListeners();
  }
}