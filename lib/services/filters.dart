import 'package:mediagallerycleaner/model/model.dart';

class Filter {

  final db = Deleted();

  // Filters out the deleted media:
  // gets a list of assets and returns it without the deleted ones
  // it has to make call to the database
  deleted() async {
    List<Deleted> deletedList = await db.select().toList();
    var paths = deletedList.map((media) => media.path);

    // return !paths.contains(media.path);
    return paths;
  }

}