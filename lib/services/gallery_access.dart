import 'package:flutter/material.dart';
import 'package:mediagallerycleaner/services/filters.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class GalleryAccess {

  final filter = Filter();

  getMediaFromGallery() async {

    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
      List<AssetPathEntity> assetPathsList = await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> assetList = await assetPathsList[0].getAssetListRange(start: 0, end: assetPathsList[0].assetCount);
//      List<Uint8List> mediaList = await Future.wait(assetList.map((val) => val.thumbDataWithSize(300, 300)));
      return await filter.filterDeleted(assetList);
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
      return [];
    }
  }

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