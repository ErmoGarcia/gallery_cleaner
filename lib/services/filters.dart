import 'package:mediagallerycleaner/model/model.dart';

class Filter {

  final db = Deleted();

  // Filters out the deleted media:
  // gets a list of assets and returns it without the deleted ones
  // it has to make call to the database
  filterDeleted(assetList) async {
    var deletedList = await db.select().toList();
    var idList = deletedList.map((img) => img.img_id);

    return assetList.where((asset) {
      return !idList.contains(asset.id);
    }).toList();
  }

  deleted(mediaList) async {
    var deletedList = await db.select().toList();
    var paths = deletedList.map((media) => media.path);
    print(paths);

    return mediaList.where((media) {
      return !paths.contains(media.path);
    }).toList();
  }

}