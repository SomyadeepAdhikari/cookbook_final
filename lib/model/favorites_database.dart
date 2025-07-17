import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'favorite_hive.dart';

class FavoritesDatabase extends ChangeNotifier {
  static const String _boxName = 'favorites';
  Box<FavoriteRecipe>? _favoritesBox;

  // Getter for the box
  Box<FavoriteRecipe> get _box {
    if (_favoritesBox?.isOpen != true) {
      throw Exception('FavoritesDatabase not initialized. Call initialize() first.');
    }
    return _favoritesBox!;
  }

  /// Initialize the Hive database
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register the adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteRecipeAdapter());
    }
  }

  /// Open the favorites box
  Future<void> openBox() async {
    if (_favoritesBox?.isOpen != true) {
      _favoritesBox = await Hive.openBox<FavoriteRecipe>(_boxName);
    }
  }

  /// Close the database
  Future<void> close() async {
    await _favoritesBox?.close();
    _favoritesBox = null;
  }

  /// Get all current favorites
  List<FavoriteRecipe> get currentFavorites {
    try {
      return _box.values.toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt)); // Most recent first
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  /// Add a recipe to favorites
  Future<void> addFavorite(String name, int recipeId, String image) async {
    try {
      final favorite = FavoriteRecipe(
        id: recipeId,
        name: name,
        image: image,
      );
      
      await _box.put(recipeId, favorite);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  /// Remove a recipe from favorites by ID
  Future<void> deleteId(int recipeId) async {
    try {
      await _box.delete(recipeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting favorite: $e');
    }
  }

  /// Check if a recipe is in favorites
  bool checkIfFav(int recipeId) {
    try {
      return _box.containsKey(recipeId);
    } catch (e) {
      debugPrint('Error checking if favorite: $e');
      return false;
    }
  }

  /// Get a specific favorite by ID
  FavoriteRecipe? getFavorite(int recipeId) {
    try {
      return _box.get(recipeId);
    } catch (e) {
      debugPrint('Error getting favorite: $e');
      return null;
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _box.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  /// Get the count of favorites
  int get favoritesCount {
    try {
      return _box.length;
    } catch (e) {
      debugPrint('Error getting favorites count: $e');
      return 0;
    }
  }

  /// Fetch favorites (for compatibility with existing code)
  Future<void> fetchFavorites() async {
    // This method is kept for compatibility
    // Hive automatically keeps data in sync, so we just notify listeners
    notifyListeners();
  }

  /// Legacy method for compatibility
  Future<bool> checkId(int id) async {
    return checkIfFav(id);
  }

  /// Legacy method for compatibility  
  Future<void> deleteFavorite(int id) async {
    await deleteId(id);
  }
}
