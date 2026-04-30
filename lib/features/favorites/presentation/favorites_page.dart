import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/recipe_card.dart';
import '../../recipe_detail/providers/recipe_detail_providers.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(allFavoritesProvider);

    return SafeArea(
      bottom: false,
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator(
          color: AppTheme.ink,
        )),
        error: (e, _) => Center(child: Text('$e')),
        data: (list) {
          if (list.isEmpty) {
            return _Empty(
              title: l.favoritesEmpty,
              hint: l.favoritesEmptyHint,
            );
          }
          return RefreshIndicator(
            backgroundColor: AppTheme.cream,
            color: AppTheme.ink,
            onRefresh: () async => ref.invalidate(allFavoritesProvider),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(title: l.favoritesTitle, count: list.length),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 28,
                      childAspectRatio: 0.58,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => RecipeCard(
                        recipe: list[i],
                        indexLabel: i + 1,
                        onTap: () => context.push('/recipe/${list[i].id}'),
                      ),
                      childCount: list.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final int count;
  const _Header({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 22, height: 1, color: AppTheme.ink),
              const SizedBox(width: 10),
              Text('THE COLLECTION', style: AppTheme.eyebrow()),
              const Spacer(),
              Text(
                count.toString().padLeft(2, '0'),
                style: AppTheme.serif(
                  size: 16,
                  weight: FontWeight.w600,
                  italic: true,
                  color: AppTheme.terracotta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTheme.serif(
              size: 36,
              weight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String title;
  final String hint;
  const _Empty({required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.ink, width: 1),
              ),
              child: const Icon(Icons.bookmark_outline,
                  color: AppTheme.ink, size: 28),
            ),
            const SizedBox(height: 24),
            Text('THE COLLECTION',
                style: AppTheme.eyebrow(), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.serif(
                size: 26,
                weight: FontWeight.w700,
                height: 1.15,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: AppTheme.serif(
                size: 14,
                italic: true,
                color: AppTheme.ash,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
