import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class GalleryAccess extends ChangeNotifier {

  final filter = Filter();

  AssetPathEntity assetPath;
  List<AssetEntity> list = [];

  // Gets media from gallery (except deleted)
  Future<void> getGalleryPath() async {

    // Permission needs to be granted
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success: gets all of the assets
      var assetPathsList = await PhotoManager.getAssetPathList(onlyAll: true);
      this.assetPath = assetPathsList[0];

    } else {
      // fail: returns nothing
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
      this.list = [];
    }
  }

  Future<void> getMediaFromGallery() async {
    List<AssetEntity> assetList = await this.assetPath.getAssetListRange(
        start: 0, end: this.assetPath.assetCount
    );

    // returns all except for the deleted ones
    final list = await filter.filterDeleted(assetList);

    this.list.clear();
    this.list.addAll(list);
  }

  // PROBLEM: not really getting deleted from galleryflutter build initstate
  // Deletes the assets from the phone gallery
  Future<void> deleteMediaFromGallery(assetList) async {
    var storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir;
    print('Root: ${root}');

    await assetList.forEach((asset) async {
      try {
        var file = await File(root + '/' + asset.path);
        var test = await file.exists();
        print('Test: ${test}');
        await file.delete();

      } catch (e) {
        print(e);
      }

      await deleteCacheDir();
    });
  }


  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }

    await assetPath.refreshPathProperties();
    await getMediaFromGallery();
    notifyListeners();
  }

  void removeAtIndex(index) {
    try {
      this.list.removeAt(index);
    } catch(e) {
      print(e);
    }

    notifyListeners();
  }
}