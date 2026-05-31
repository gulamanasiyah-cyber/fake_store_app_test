import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_bloc.dart';
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
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatefulWidget {
  const _ProductListView();

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Premium SliverAppBar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            snap: true,
            pinned: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF0F0F14), const Color(0xFF1A1035)]
                        : [const Color(0xFFEEF2FF), const Color(0xFFF5F3FF)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Discover',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                              ),
                              Text(
                                'Find your perfect product',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        // Theme Toggle
                        GestureDetector(
                          onTap: () => context.read<ThemeBloc>().add(ThemeToggled()),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF22223A) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isDark ? const Color(0xFF2E2E4A) : const Color(0xFFE4E4F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                  size: 16,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isDark ? 'Dark' : 'Light',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Logout
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF22223A) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isDark ? const Color(0xFF2E2E4A) : const Color(0xFFE4E4F0)),
                            ),
                            child: const Icon(Icons.logout_rounded, size: 18, color: Color(0xFFF43F5E)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search bar + filters – sticky
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              isDark: isDark,
              searchController: _searchController,
            ),
          ),

          // Body
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryIndigo),
                    ),
                  ),
                );
              }

              if (state is ProductError) {
                return SliverFillRemaining(
                  child: _ErrorState(message: state.message),
                );
              }

              if (state is ProductLoaded) {
                final products = state.filteredProducts;
                if (products.isEmpty) {
                  return SliverFillRemaining(child: _EmptyState());
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return _ProductCard(
                          product: product,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(product: product),
                              ),
                            );
                            if (context.mounted) {
                              context.read<ProductBloc>().add(FetchCatalogStarted());
                            }
                          },
                          onFavorite: () => context.read<ProductBloc>().add(ToggleFavoritePressed(product.id)),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

// ─── Sticky Search + Filters Header ───────────────────────────────────────────

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final bool isDark;
  final TextEditingController searchController;

  const _StickySearchDelegate({required this.isDark, required this.searchController});

  static const _categories = ['All', 'Electronics', 'Jewelery', "Men's Clothing", "Women's Clothing"];

  @override
  double get minExtent => 120;
  @override
  double get maxExtent => 120;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          color: isDark ? const Color(0xFF0F0F14) : const Color(0xFFF5F5FA),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search products, brands...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: state.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            searchController.clear();
                            context.read<ProductBloc>().add(const SearchQueryFilterChanged(''));
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onChanged: (v) => context.read<ProductBloc>().add(SearchQueryFilterChanged(v)),
              ),
              const SizedBox(height: 10),
              // Category chips
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = _categories[i];
                    final selected = state.selectedCategory.toLowerCase() == cat.toLowerCase();
                    return GestureDetector(
                      onTap: () => context.read<ProductBloc>().add(CategoryFilterChanged(cat)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(colors: [AppTheme.primaryIndigo, Color(0xFF6D28D9)])
                              : null,
                          color: selected ? null : (isDark ? const Color(0xFF22223A) : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? Colors.transparent : (isDark ? const Color(0xFF2E2E4A) : const Color(0xFFE4E4F0)),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : (isDark ? const Color(0xFF8B8BAE) : const Color(0xFF6B6B8A)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(_StickySearchDelegate oldDelegate) => isDark != oldDelegate.isDark;
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _ProductCard({required this.product, required this.onTap, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeBloc>().state.isDark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF22223A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF2E2E4A) : const Color(0xFFE4E4F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: product.isFavorite ? const Color(0xFFF43F5E) : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryIndigo.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _shortCategory(product.category),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: isDark ? const Color(0xFFF1F1F8) : const Color(0xFF0F0F2D),
                      ),
                    ),
                    const Spacer(),
                    // Rating row
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 13),
                        const SizedBox(width: 3),
                        Text(
                          product.ratingRate.toString(),
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF59E0B)),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.ratingCount})',
                          style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF8B8BAE) : const Color(0xFF6B6B8A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Price + Cart row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryIndigo,
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryIndigo, Color(0xFF6D28D9)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'electronics': return 'TECH';
      case 'jewelery': return 'JEWEL';
      case "men's clothing": return 'MEN';
      case "women's clothing": return 'WOMEN';
      default: return cat.toUpperCase().substring(0, cat.length.clamp(0, 5));
    }
  }
}

// ─── Empty & Error States ─────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded, size: 48, color: AppTheme.primaryIndigo),
          ),
          const SizedBox(height: 20),
          Text('No products found', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Try adjusting your filters', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              context.read<ProductBloc>()
                ..add(const SearchQueryFilterChanged(''))
                ..add(const CategoryFilterChanged('All'));
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFFF43F5E)),
            ),
            const SizedBox(height: 20),
            Text('Oops! Something went wrong', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<ProductBloc>().add(FetchCatalogStarted()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
