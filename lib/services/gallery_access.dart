import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

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
//    List<String> idList = assetList.map<String>((
//        AssetEntity element) => element.id.toString()).toList();
//    await PhotoManager.editor.deleteWithIds(idList);
//    List<AssetPathEntity> assetPathList = await PhotoManager.getAssetPathList(onlyAll: true);
//    await assetPathList[0].refreshPathProperties();
    await assetList.forEach((asset) async {
      File file = await asset.file;
      await file.delete();
      imageCache.clear();
    });
  }
}