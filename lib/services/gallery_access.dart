import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

class GalleryAccess {

  final filter = Filter();

  // Gets media from gallery (except deleted)
  getMediaFromGallery() async {

    // Permission needs to be granted
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success: gets all of the assets
      List<AssetPathEntity> assetPathsList = await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> assetList = await assetPathsList[0].getAssetListRange(start: 0, end: assetPathsList[0].assetCount);

      // returns all except for the deleted ones
      return await filter.filterDeleted(assetList);
    } else {
      // fail: returns nothing
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
      return [];
    }
  }

  // PROBLEM: not really getting deleted from gallery
  // Deletes the assets from the phone gallery
  deleteMediaFromGallery(assetList) async {
    var storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].rootDir;
    print('Root: ${root}');

    await assetList.forEach((path) async {
      try {
        var file = await File(root + '/' + path);
        var test = await file.exists();
        print('Test: ${test}');
        await file.delete();
        _deleteCacheDir();

      } catch (e) {
        print('Error ${e}');
      }
    });

//    await assetList.forEach((asset) async {
//      File file = await asset.file;
//      await file.delete();
//      imageCache.clear();
//    });
  }


  _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}