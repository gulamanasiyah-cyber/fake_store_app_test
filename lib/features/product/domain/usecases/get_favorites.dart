import '../repositories/product_repository.dart';

class GetFavorites {
  final ProductRepository repository;

  GetFavorites(this.repository);

  Future<List<int>> call() async {
    return await repository.getFavorites();
  }
}
