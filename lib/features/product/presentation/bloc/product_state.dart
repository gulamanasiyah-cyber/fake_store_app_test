import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  final String searchQuery;
  final String selectedCategory;
  final String sortOrder;

  const ProductState({
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [searchQuery, selectedCategory, sortOrder];
}

class ProductInitial extends ProductState {
  const ProductInitial({
    super.searchQuery = '',
    super.selectedCategory = 'All',
    super.sortOrder = 'price_asc',
  });
}

class ProductLoading extends ProductState {
  const ProductLoading({
    required super.searchQuery,
    required super.selectedCategory,
    required super.sortOrder,
  });
}

class ProductLoaded extends ProductState {
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;

  const ProductLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required super.searchQuery,
    required super.selectedCategory,
    required super.sortOrder,
  });

  @override
  List<Object?> get props => [
        allProducts,
        filteredProducts,
        searchQuery,
        selectedCategory,
        sortOrder,
      ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({
    required this.message,
    required super.searchQuery,
    required super.selectedCategory,
    required super.sortOrder,
  });

  @override
  List<Object?> get props => [
        message,
        searchQuery,
        selectedCategory,
        sortOrder,
      ];
}
