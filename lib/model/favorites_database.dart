import 'package:cookbook_final/model/favorite.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class FavoritesDatabase extends ChangeNotifier {
  static late Isar isar;

  //Initialise database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await (Isar.open([FavoriteSchema], directory: dir.path));
  }

  // A list of favorites
  final List<Favorite> currentFavorites = [];

  // add favorite
  Future<void> addFavorite(String text, int newid, String newimage) async {
    final newFavourite = Favorite()..realid = newid;
    newFavourite.image = newimage;
    newFavourite.name = text;
    // create a new favorite object

    // save to db
    await isar.writeTxn(() => isar.favorites.put(newFavourite));
    fetchFavorites();
  }

  // check if the item is already in favorites
  Future<bool> checkId(int id) async {
    final fav = Favorite()..realid = id;
    final isexisting = await isar.favorites.get(fav.id);
    if (isexisting != null) {
      return true;
    } else {
      return false;
    }
  }

  // delete fav with realid
  Future<void> deleteId(int id) async {
    //final fav = Favorite()..realid = id;
    int newnewId = -1;
    Favorite a;
    for (a in currentFavorites) {
      if (a.realid == id) {
        newnewId = a.id;
        break;
      }
    }
    deleteFavorite(newnewId);
  }

  // Read favorites from db
  Future<void> fetchFavorites() async {
    List<Favorite> fetchedFavorite = await isar.favorites.where().findAll();
    currentFavorites.clear();
    currentFavorites.addAll(fetchedFavorite);
    notifyListeners();
  }

  // remove favorite
  Future<void> deleteFavorite(int id) async {
    await isar.writeTxn(() => isar.favorites.delete(id));
    await fetchFavorites();
  }

  bool checkIfFav(int recipeId) {
    Favorite currentItem;
    for (currentItem in currentFavorites) {
      if (currentItem.realid == recipeId) {
        fetchFavorites();
        return true;
      }
    }
    fetchFavorites();
    return false;
  }
}
