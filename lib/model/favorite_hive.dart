import 'package:hive/hive.dart';

part 'favorite_hive.g.dart';

@HiveType(typeId: 0)
class FavoriteRecipe extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String image;

  @HiveField(3)
  late DateTime addedAt;

  FavoriteRecipe({
    required this.id,
    required this.name,
    required this.image,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  // Empty constructor for Hive
  FavoriteRecipe.empty();
}
