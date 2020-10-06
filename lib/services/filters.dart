import 'package:mediagallerycleaner/model/model.dart';

class Filter {

  final deleted = Deleted();

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