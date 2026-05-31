import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getProducts();
      final favorites = await localDataSource.getFavoriteProductIds();
      return remoteProducts.map((product) {
        return product.copyWith(
          isFavorite: favorites.contains(product.id),
        );
      }).toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch products from the server. Details: ${e.toString()}');
    }
  }

  @override
  Future<List<int>> getFavorites() async {
    try {
      return await localDataSource.getFavoriteProductIds();
    } catch (e) {
      throw CacheFailure('Failed to access local database. Details: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    try {
      await localDataSource.toggleFavoriteProductId(productId);
    } catch (e) {
      throw CacheFailure('Failed to update favorite status. Details: ${e.toString()}');
    }
  }


}
