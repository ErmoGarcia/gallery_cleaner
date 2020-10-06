import 'package:mediagallerycleaner/model/model.dart';

class Filter {

  final deleted = Deleted();

  // Filters out the deleted media:
  // gets a list of assets and returns it without the deleted ones
  // it has to make call to the database
  filterDeleted(assetList) async {
    var deletedList = await deleted.select().toList();
    var idList = deletedList.map((img) => img.img_id);
    print('idList:');
    print(idList);
    return assetList.where((asset) {
      return !idList.contains(asset.id);
    }).toList();
  }

}