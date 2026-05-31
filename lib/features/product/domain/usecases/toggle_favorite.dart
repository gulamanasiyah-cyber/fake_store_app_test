import '../repositories/product_repository.dart';

class ToggleFavorite {
  final ProductRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(int productId) async {
    return await repository.toggleFavorite(productId);
  }
}
