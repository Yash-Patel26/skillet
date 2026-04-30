import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/recipe.dart';
import '../../features/recipe_detail/providers/recipe_detail_providers.dart';

class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final bool wide;
  final int? indexLabel;
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.wide = false,
    this.indexLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(isFavoriteProvider(recipe.id)).valueOrNull ?? false;
    final eyebrowText = _eyebrowText();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: wide ? 16 / 10 : 4 / 5,
                child: Container(
                  color: AppTheme.paper,
                  child: Hero(
                    tag: 'recipe-${recipe.id}',
                    child: _Thumb(url: recipe.thumbnail),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.ink.withValues(alpha: 0.10),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: _QuickSave(
                  active: isFav,
                  onTap: () => ref
                      .read(favoriteToggleProvider)
                      .toggle(recipe),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              if (indexLabel != null) ...[
                Text(
                  indexLabel!.toString().padLeft(2, '0'),
                  style: AppTheme.serif(
                    size: 13,
                    weight: FontWeight.w600,
                    italic: true,
                    color: AppTheme.terracotta,
                  ),
                ),
                const SizedBox(width: 6),
                Container(width: 10, height: 1, color: AppTheme.hairline),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  eyebrowText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.eyebrow(color: AppTheme.ash),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            recipe.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.serif(
              size: 17,
              weight: FontWeight.w600,
              height: 1.2,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: AppTheme.hairline),
        ],
      ),
    );
  }

  String _eyebrowText() {
    final parts = <String>[];
    if ((recipe.area ?? '').isNotEmpty) parts.add(recipe.area!);
    if ((recipe.category ?? '').isNotEmpty) parts.add(recipe.category!);
    return parts.isEmpty ? 'RECIPE' : parts.join(' · ').toUpperCase();
  }
}

class _QuickSave extends StatefulWidget {
  final bool active;
  final VoidCallback onTap;
  const _QuickSave({required this.active, required this.onTap});

  @override
  State<_QuickSave> createState() => _QuickSaveState();
}

class _QuickSaveState extends State<_QuickSave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void didUpdateWidget(covariant _QuickSave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active) _ctl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _ctl,
        builder: (_, __) {
          final t = _ctl.value;
          final scale = widget.active
              ? 1 + (t < 0.5 ? t * 0.4 : (1 - t) * 0.4)
              : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.cream,
                border: Border.all(color: AppTheme.ink, width: 1),
              ),
              child: Icon(
                widget.active ? Icons.bookmark : Icons.bookmark_outline,
                size: 18,
                color: AppTheme.ink,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String? url;
  const _Thumb({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _placeholder();
    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 400),
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: AppTheme.paper,
        highlightColor: AppTheme.cream,
        child: Container(color: AppTheme.paper),
      ),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        color: AppTheme.paper,
        child: const Icon(Icons.restaurant_menu,
            size: 36, color: AppTheme.sage),
      );
}
