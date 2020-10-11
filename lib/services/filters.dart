import 'package:mediagallerycleaner/model/model.dart';

class Filter {

  final db = Deleted();

  // Filters out the deleted media:
  // gets a list of assets and returns it without the deleted ones
  // it has to make call to the database
  Future<List<String>> deleted() async {
    List<Deleted> deletedList = await db.select().toList();
    List<String> paths = deletedList.map((media) => media.path).toList();

    // return !paths.contains(media.path);
    return paths;
  }

}