import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(FetchCatalogStarted()),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final List<String> _categories = [
    'All',
    'Electronics',
    'Jewelery',
    "Men's Clothing",
    "Women's Clothing",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPLORE CATALOG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppTheme.error),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search_outlined, color: AppTheme.textSecondary),
                          suffixIcon: state.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                                  onPressed: () {
                                    context.read<ProductBloc>().add(const SearchQueryFilterChanged(''));
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onChanged: (value) {
                          context.read<ProductBloc>().add(SearchQueryFilterChanged(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort Selector Container
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: state.sortOrder,
                          icon: const Icon(Icons.sort_outlined, color: AppTheme.primary),
                          dropdownColor: AppTheme.surface,
                          items: const [
                            DropdownMenuItem(
                              value: 'price_asc',
                              child: Text('Price: Low-High', style: TextStyle(fontSize: 14)),
                            ),
                            DropdownMenuItem(
                              value: 'price_desc',
                              child: Text('Price: High-Low', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              context.read<ProductBloc>().add(SortOrderFilterChanged(value));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Horizontal Category Filter List
          SizedBox(
            height: 56,
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = state.selectedCategory.toLowerCase() == category.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: AppTheme.primary,
                        backgroundColor: AppTheme.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                            width: 1,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ProductBloc>().add(CategoryFilterChanged(category));
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Main product grid view content area
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading && state is! ProductLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  );
                }

                if (state is ProductError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: AppTheme.error),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductBloc>().add(FetchCatalogStarted());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ProductLoaded) {
                  final products = state.filteredProducts;

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_outlined, size: 60, color: AppTheme.textSecondary),
                          const SizedBox(height: 16),
                          const Text(
                            'No products found matching filters.',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              context.read<ProductBloc>()
                                ..add(const SearchQueryFilterChanged(''))
                                ..add(const CategoryFilterChanged('All'));
                            },
                            child: const Text('Reset Filters', style: TextStyle(color: AppTheme.primary)),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(product: product),
                              ),
                            ).then((value) {
                              // Re-fetch or synchronize favorites state when returning
                              if (context.mounted) {
                                context.read<ProductBloc>().add(FetchCatalogStarted());
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Product Image & Favorite Button
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.image_not_supported_outlined, size: 50),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Material(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        shape: const CircleBorder(),
                                        child: IconButton(
                                          icon: Icon(
                                            product.isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: product.isFavorite ? Colors.red : Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            context.read<ProductBloc>().add(ToggleFavoritePressed(product.id));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Product Metadata
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.category.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              product.ratingRate.toString(),
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
