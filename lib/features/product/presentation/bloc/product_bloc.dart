import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/toggle_favorite.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final ToggleFavorite toggleFavorite;

  ProductBloc({
    required this.getProducts,
    required this.toggleFavorite,
  }) : super(const ProductInitial()) {
    on<FetchCatalogStarted>(_onFetchCatalogStarted);
    on<SearchQueryFilterChanged>(
      _onSearchQueryFilterChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
    on<CategoryFilterChanged>(_onCategoryFilterChanged);
    on<SortOrderFilterChanged>(_onSortOrderFilterChanged);
    on<ToggleFavoritePressed>(_onToggleFavoritePressed);
  }

  void _onFetchCatalogStarted(FetchCatalogStarted event, Emitter<ProductState> emit) async {
    final query = state.searchQuery;
    final category = state.selectedCategory;
    final sort = state.sortOrder;

    emit(ProductLoading(
      searchQuery: query,
      selectedCategory: category,
      sortOrder: sort,
    ));

    try {
      final products = await getProducts();
      final filtered = _processFilters(products, query, category, sort);

      emit(ProductLoaded(
        allProducts: products,
        filteredProducts: filtered,
        searchQuery: query,
        selectedCategory: category,
        sortOrder: sort,
      ));
    } catch (e) {
      emit(ProductError(
        message: e.toString().replaceAll('Exception: ', ''),
        searchQuery: query,
        selectedCategory: category,
        sortOrder: sort,
      ));
    }
  }

  void _onSearchQueryFilterChanged(SearchQueryFilterChanged event, Emitter<ProductState> emit) {
    final currentState = state;
    final query = event.query;
    
    if (currentState is ProductLoaded) {
      final filtered = _processFilters(
        currentState.allProducts,
        query,
        currentState.selectedCategory,
        currentState.sortOrder,
      );
      emit(ProductLoaded(
        allProducts: currentState.allProducts,
        filteredProducts: filtered,
        searchQuery: query,
        selectedCategory: currentState.selectedCategory,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      _emitUpdatedLoadingOrInitial(emit, query: query);
    }
  }

  void _onCategoryFilterChanged(CategoryFilterChanged event, Emitter<ProductState> emit) {
    final currentState = state;
    final category = event.category;

    if (currentState is ProductLoaded) {
      final filtered = _processFilters(
        currentState.allProducts,
        currentState.searchQuery,
        category,
        currentState.sortOrder,
      );
      emit(ProductLoaded(
        allProducts: currentState.allProducts,
        filteredProducts: filtered,
        searchQuery: currentState.searchQuery,
        selectedCategory: category,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      _emitUpdatedLoadingOrInitial(emit, category: category);
    }
  }

  void _onSortOrderFilterChanged(SortOrderFilterChanged event, Emitter<ProductState> emit) {
    final currentState = state;
    final sort = event.sortOrder;

    if (currentState is ProductLoaded) {
      final filtered = _processFilters(
        currentState.allProducts,
        currentState.searchQuery,
        currentState.selectedCategory,
        sort,
      );
      emit(ProductLoaded(
        allProducts: currentState.allProducts,
        filteredProducts: filtered,
        searchQuery: currentState.searchQuery,
        selectedCategory: currentState.selectedCategory,
        sortOrder: sort,
      ));
    } else {
      _emitUpdatedLoadingOrInitial(emit, sort: sort);
    }
  }

  void _onToggleFavoritePressed(ToggleFavoritePressed event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      try {
        await toggleFavorite(event.productId);
        
        final updatedProducts = currentState.allProducts.map((product) {
          if (product.id == event.productId) {
            return product.copyWith(isFavorite: !product.isFavorite);
          }
          return product;
        }).toList();

        final filtered = _processFilters(
          updatedProducts,
          currentState.searchQuery,
          currentState.selectedCategory,
          currentState.sortOrder,
        );

        emit(ProductLoaded(
          allProducts: updatedProducts,
          filteredProducts: filtered,
          searchQuery: currentState.searchQuery,
          selectedCategory: currentState.selectedCategory,
          sortOrder: currentState.sortOrder,
        ));
      } catch (_) {
        // Suppress failure or map to message if needed, keeping state consistent
      }
    }
  }

  void _emitUpdatedLoadingOrInitial(Emitter<ProductState> emit, {String? query, String? category, String? sort}) {
    final q = query ?? state.searchQuery;
    final c = category ?? state.selectedCategory;
    final s = sort ?? state.sortOrder;

    if (state is ProductLoading) {
      emit(ProductLoading(searchQuery: q, selectedCategory: c, sortOrder: s));
    } else if (state is ProductInitial) {
      emit(ProductInitial(searchQuery: q, selectedCategory: c, sortOrder: s));
    } else if (state is ProductError) {
      emit(ProductError(
        message: (state as ProductError).message,
        searchQuery: q,
        selectedCategory: c,
        sortOrder: s,
      ));
    }
  }

  List<ProductEntity> _processFilters(
    List<ProductEntity> products,
    String query,
    String category,
    String sortOrder,
  ) {
    List<ProductEntity> filtered = List.from(products);

    // 1. Category matching
    if (category != 'All') {
      filtered = filtered.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // 2. Query search matching
    if (query.isNotEmpty) {
      filtered = filtered.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
    }

    // 3. Price sorting
    if (sortOrder == 'price_asc') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOrder == 'price_desc') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }
}
