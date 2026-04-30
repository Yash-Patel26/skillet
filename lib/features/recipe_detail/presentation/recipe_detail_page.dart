import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/recipe.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/animated_favorite_button.dart';
import '../providers/recipe_detail_providers.dart';

class RecipeDetailPage extends ConsumerWidget {
  final String id;
  const RecipeDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(recipeByIdProvider(id));
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.ink),
        ),
        error: (e, _) => Center(
          child: Text('$e', style: AppTheme.serif(size: 14, italic: true)),
        ),
        data: (r) => r == null
            ? Center(child: Text(l.detailNotFound))
            : _Body(r: r),
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  final Recipe r;
  const _Body({required this.r});

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    final r = widget.r;
    final l = AppLocalizations.of(context);
    final isFav = ref.watch(isFavoriteProvider(r.id));
    final steps = r.instructionSteps();

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Hero(r: r)),
            SliverToBoxAdapter(
              child: _TitleBlock(r: r),
            ),
            SliverToBoxAdapter(
              child: _StatsRow(
                ingredients: r.ingredients.length,
                steps: steps.length,
                area: r.area,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
                child: _SectionLabel(text: l.detailIngredients),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverList.builder(
                itemCount: r.ingredients.length,
                itemBuilder: (_, i) {
                  final ing = r.ingredients[i];
                  final on = _checked.contains(i);
                  return InkWell(
                    onTap: () => setState(
                      () => on ? _checked.remove(i) : _checked.add(i),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 36,
                            child: Text(
                              (i + 1).toString().padLeft(2, '0'),
                              style: AppTheme.serif(
                                size: 14,
                                weight: FontWeight.w500,
                                italic: true,
                                color: on
                                    ? AppTheme.sage
                                    : AppTheme.terracotta,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ing.measure.isEmpty
                                  ? ing.name
                                  : '${ing.measure} ${ing.name}',
                              style: AppTheme.serif(
                                size: 17,
                                weight: FontWeight.w500,
                                height: 1.35,
                                color: on ? AppTheme.sage : AppTheme.ink,
                              ).copyWith(
                                decoration: on
                                    ? TextDecoration.lineThrough
                                    : null,
                                decorationColor: AppTheme.sage,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: on ? AppTheme.ink : Colors.transparent,
                              border: Border.all(
                                color: on
                                    ? AppTheme.ink
                                    : AppTheme.hairline,
                                width: 1.2,
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: on
                                  ? const Icon(
                                      Icons.check,
                                      key: ValueKey('on'),
                                      size: 12,
                                      color: AppTheme.cream,
                                    )
                                  : const SizedBox(key: ValueKey('off')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(height: 1, color: AppTheme.hairline),
              ),
            ),

            // Instructions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                child: _SectionLabel(text: l.detailInstructions),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverList.builder(
                itemCount: steps.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            (i + 1).toString().padLeft(2, '0'),
                            style: AppTheme.serif(
                              size: 28,
                              weight: FontWeight.w700,
                              italic: true,
                              height: 1,
                              color: AppTheme.terracotta,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _StepText(text: steps[i], isFirst: i == 0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _CircleBtn(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      border: Border.all(color: AppTheme.ink, width: 1),
                    ),
                    child: AnimatedFavoriteButton(
                      isFavorite: isFav.valueOrNull == true,
                      onTap: () =>
                          ref.read(favoriteToggleProvider).toggle(r),
                      color: AppTheme.ink,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cream,
                border: Border.all(color: AppTheme.ink, width: 1),
              ),
              child: Material(
                color: AppTheme.ink,
                child: InkWell(
                  onTap: () => context.push('/cook/${r.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: Row(
                      children: [
                        Text(
                          l.detailStartCooking.toUpperCase(),
                          style: AppTheme.eyebrow(color: AppTheme.cream),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward,
                            color: AppTheme.cream, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final Recipe r;
  const _Hero({required this.r});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppTheme.paper),
          if (r.thumbnail != null)
            Hero(
              tag: 'recipe-${r.id}',
              child: CachedNetworkImage(
                imageUrl: r.thumbnail!,
                fit: BoxFit.cover,
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.cream.withValues(alpha: 0),
                    AppTheme.cream,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final Recipe r;
  const _TitleBlock({required this.r});

  @override
  Widget build(BuildContext context) {
    final eyebrow = [
      if ((r.area ?? '').isNotEmpty) r.area!,
      if ((r.category ?? '').isNotEmpty) r.category!,
    ].join(' · ').toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 22, height: 1, color: AppTheme.ink),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  eyebrow.isEmpty ? 'RECIPE' : eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.eyebrow(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            r.name,
            style: AppTheme.serif(
              size: 40,
              weight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int ingredients;
  final int steps;
  final String? area;
  const _StatsRow({
    required this.ingredients,
    required this.steps,
    this.area,
  });

  @override
  Widget build(BuildContext context) {
    Widget cell(String value, String label) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTheme.serif(
                  size: 28,
                  weight: FontWeight.w600,
                  italic: true,
                  height: 1,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(label, style: AppTheme.eyebrow(color: AppTheme.ash)),
            ],
          ),
        );

    Widget divider() => Container(
          width: 1,
          height: 56,
          color: AppTheme.hairline,
          margin: const EdgeInsets.symmetric(horizontal: 18),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.ink, width: 1),
            bottom: BorderSide(color: AppTheme.hairline, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            cell(ingredients.toString(), 'INGREDIENTS'),
            divider(),
            cell(steps.toString(), 'STEPS'),
            if ((area ?? '').isNotEmpty) ...[
              divider(),
              cell(area!, 'CUISINE'),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 22, height: 1, color: AppTheme.ink),
        const SizedBox(width: 10),
        Text(text.toUpperCase(), style: AppTheme.eyebrow()),
      ],
    );
  }
}

class _StepText extends StatelessWidget {
  final String text;
  final bool isFirst;
  const _StepText({required this.text, this.isFirst = false});
  @override
  Widget build(BuildContext context) {
    if (!isFirst || text.isEmpty) {
      return Text(
        text,
        style: AppTheme.serif(
          size: 17,
          weight: FontWeight.w400,
          height: 1.55,
        ),
      );
    }
    final first = text[0];
    final rest = text.substring(1);
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                first,
                style: AppTheme.serif(
                  size: 56,
                  weight: FontWeight.w700,
                  italic: true,
                  height: 0.85,
                  color: AppTheme.terracotta,
                ),
              ),
            ),
          ),
          TextSpan(
            text: rest,
            style: AppTheme.serif(
              size: 17,
              weight: FontWeight.w400,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.cream,
          border: Border.all(color: AppTheme.ink, width: 1),
        ),
        child: Icon(icon, size: 20, color: AppTheme.ink),
      ),
    );
  }
}
