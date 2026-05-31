import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchCatalogStarted extends ProductEvent {}

class SearchQueryFilterChanged extends ProductEvent {
  final String query;

  const SearchQueryFilterChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CategoryFilterChanged extends ProductEvent {
  final String category;

  const CategoryFilterChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class SortOrderFilterChanged extends ProductEvent {
  final String sortOrder;

  const SortOrderFilterChanged(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}

class ToggleFavoritePressed extends ProductEvent {
  final int productId;

  const ToggleFavoritePressed(this.productId);

  @override
  List<Object?> get props => [productId];
}
