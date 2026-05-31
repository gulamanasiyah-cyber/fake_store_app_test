import 'package:shared_preferences/shared_preferences.dart';

abstract class ProductLocalDataSource {
  Future<List<int>> getFavoriteProductIds();
  Future<void> toggleFavoriteProductId(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'favorite_product_ids';

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<int>> getFavoriteProductIds() async {
    final favorites = sharedPreferences.getStringList(_favoritesKey);
    if (favorites == null) return [];
    return favorites.map((id) => int.parse(id)).toList();
  }

  @override
  Future<void> toggleFavoriteProductId(int id) async {
    final currentFavorites = await getFavoriteProductIds();
    if (currentFavorites.contains(id)) {
      currentFavorites.remove(id);
    } else {
      currentFavorites.add(id);
    }
    final stringList = currentFavorites.map((id) => id.toString()).toList();
    await sharedPreferences.setStringList(_favoritesKey, stringList);
  }
}
