import 'dart:typed_data';

import 'package:mediagallerycleaner/services/gallery_access.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';

class MediaProcessor {

  Widget _generateImageWidget(image, fit) {
    return Image.memory(
      image,
      fit: fit,
      height: fit == null ? null : double.infinity,
      width: fit == null ? null : double.infinity,
    );
  }

  Widget _generateVideoWidget(image, fit) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Image.memory(
          image,
          fit: fit,
          height: fit == null ? null : double.infinity,
          width: fit == null ? null : double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: Icon(Icons.videocam, color: Colors.white,),
        )
      ],
    );
  }

  getMediaFromAsset(asset, image, [fit]) {
    if(asset.type == AssetType.image){
      return _generateImageWidget(image, fit);
    }
    else if(asset.type == AssetType.video) {
      return _generateVideoWidget(image, fit);
    }
    return null;
  }
}