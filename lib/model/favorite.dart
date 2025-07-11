import 'package:isar/isar.dart';

part 'favorite.g.dart';

@Collection()
class Favorite {
  Id id = Isar.autoIncrement;
  late final String name;
  late final int realid;
  late final String image;
}
