import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_1/widgets/recipe_detail_screen.dart';

// ✅ Relative import — no 'food_1/' prefix
import '../data/model/recipe_model.dart';
import '../provider/favorites_provider.dart';


class RecipeCard extends ConsumerWidget {
  final RecipeModel recipe;
  final bool compact;

  const RecipeCard({super.key, required this.recipe, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(recipe.id));
    return compact
        ? _CompactCard(recipe: recipe, isFav: isFav, ref: ref)
        : _FullCard(recipe: recipe, isFav: isFav, ref: ref);
  }
}

class _FullCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;
  final WidgetRef ref;
  const _FullCard(
      {required this.recipe, required this.isFav, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context, recipe),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'recipe-image-${recipe.id}',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: recipe.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  ),
                ),
                _HeartButton(recipe: recipe, isFav: isFav, ref: ref),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(recipe.area, style: const TextStyle(fontSize: 13)),
                      const Spacer(),
                      _CategoryBadge(label: recipe.category),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;
  final WidgetRef ref;
  const _CompactCard(
      {required this.recipe, required this.isFav, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context, recipe),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12, bottom: 4, top: 4),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'recipe-image-${recipe.id}',
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: recipe.image,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(height: 110, color: Colors.grey.shade200),
                        errorWidget: (_, __, ___) => Container(
                          height: 110,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  _HeartButton(
                      recipe: recipe, isFav: isFav, ref: ref, size: 18),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    _CategoryBadge(label: recipe.category, small: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final RecipeModel recipe;
  final bool isFav;
  final WidgetRef ref;
  final double size;
  const _HeartButton(
      {required this.recipe,
      required this.isFav,
      required this.ref,
      this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () =>
            ref.read(favoritesProvider.notifier).toggleFavorite(recipe),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFav),
              color: isFav ? Colors.red : Colors.grey,
              size: size,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  final bool small;
  const _CategoryBadge({required this.label, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 6 : 10, vertical: small ? 2 : 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

void _openDetail(BuildContext context, RecipeModel recipe) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => RecipeDetailScreen(recipe: recipe),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
