import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<int>> getFavorites();
  Future<void> toggleFavorite(int productId);
}
