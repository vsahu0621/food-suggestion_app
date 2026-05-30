import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_1/provider/temp_provider.dart';
import 'package:food_1/provider/favorites_provider.dart';
import 'package:food_1/provider/recipe_provider.dart';
import 'package:food_1/widgets/Section_header.dart';
import 'package:food_1/widgets/custom_searchbar.dart';
import 'package:food_1/widgets/recipe_card.dart';
import 'package:food_1/widgets/recipe_shimmer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealCtx = ref.watch(mealContextProvider);
    final recipeData = ref.watch(recipeProvider);
    final timeSuggestions = ref.watch(timeSuggestionsProvider);
    final locationSuggestions = ref.watch(locationSuggestionsProvider);
    final locationArea = ref.watch(locationAreaProvider);
    final connectivity = ref.watch(connectivityProvider);

    final isOffline = connectivity.maybeWhen(
      data: (v) => !v,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 52,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mealCtx.greeting,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                height: 1.2,
              ),
            ),
            const Text(
              'Smart Recipes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
        // ── Favorites icon in top-right corner ──────────────────────
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final favorites = ref.watch(favoritesProvider);
              return IconButton(
                tooltip: 'Favorites',
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.favorite_border,
                        color: Colors.white, size: 26),
                    if (favorites.isNotEmpty)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${favorites.length > 9 ? '9+' : favorites.length}',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _FavoritesScreen(),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Offline banner ─────────────────────────────────────────
          if (isOffline)
            Container(
              width: double.infinity,
              color: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'re offline — showing cached & saved recipes',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _DiscoverTab(
              recipeData: recipeData,
              timeSuggestions: timeSuggestions,
              locationSuggestions: locationSuggestions,
              locationArea: locationArea,
              mealCtx: mealCtx,
              ref: ref,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Discover Tab ──────────────────────────────────────────────────────────────

class _DiscoverTab extends StatelessWidget {
  final AsyncValue<List> recipeData;
  final AsyncValue<List> timeSuggestions;
  final AsyncValue<List> locationSuggestions;
  final AsyncValue<String?> locationArea;
  final MealContext mealCtx;
  final WidgetRef ref;

  const _DiscoverTab({
    required this.recipeData,
    required this.timeSuggestions,
    required this.locationSuggestions,
    required this.locationArea,
    required this.mealCtx,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Single search bar ───────────────────────────────────────
        const SliverToBoxAdapter(child: CustomSearchBar()),

        // ── Time strip ─────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeader(
            icon: mealCtx.emoji,
            title: '${mealCtx.label} Suggestions',
            subtitle: 'Based on your local time',
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: timeSuggestions.when(
              data: (recipes) => recipes.isEmpty
                  ? const Center(child: Text('No suggestions found'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: recipes.length > 10 ? 10 : recipes.length,
                      itemBuilder: (ctx, i) =>
                          RecipeCard(recipe: recipes[i], compact: true),
                    ),
              loading: () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 4,
                itemBuilder: (_, __) => const RecipeShimmerCard(compact: true),
              ),
              error: (_, __) =>
                  const Center(child: Text('Could not load suggestions')),
            ),
          ),
        ),

        // ── Location strip ─────────────────────────────────────────
        SliverToBoxAdapter(
          child: locationArea.when(
            data: (area) => area != null
                ? SectionHeader(
                    icon: '📍',
                    title: '$area Cuisine',
                    subtitle: 'Popular in your region',
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
        SliverToBoxAdapter(
          child: locationSuggestions.when(
            data: (recipes) => recipes.isEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: recipes.length > 10 ? 10 : recipes.length,
                      itemBuilder: (ctx, i) =>
                          RecipeCard(recipe: recipes[i], compact: true),
                    ),
                  ),
            loading: () => SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 4,
                itemBuilder: (_, __) => const RecipeShimmerCard(compact: true),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),

        // ── Search results — plain header, no icon ─────────────────
        const SliverToBoxAdapter(
          child: SectionHeader(title: 'Search Results'),
        ),

        recipeData.when(
          data: (recipes) => recipes.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'No recipes found',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => RecipeCard(recipe: recipes[i]),
                    childCount: recipes.length,
                  ),
                ),
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => const RecipeShimmerCard(),
              childCount: 5,
            ),
          ),
          error: (error, _) => SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Network error',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => ref.refresh(recipeProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ── Favorites Screen (pushed via Navigator) ───────────────────────────────────

class _FavoritesScreen extends ConsumerWidget {
  const _FavoritesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No saved recipes yet',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the ♥ on any recipe to save it for offline viewing',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: favorites.length,
              itemBuilder: (ctx, i) => RecipeCard(recipe: favorites[i]),
            ),
    );
  }
}
