import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../data/models/recipe.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/recipe_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/home_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final dayPart = ref.watch(dayPartProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final regionAsync = ref.watch(regionProvider);
    final featured = ref.watch(featuredProvider);
    final dayFeed = ref.watch(dayPartFeedProvider);
    final weatherFeed = ref.watch(weatherFeedProvider);
    final regionFeed = ref.watch(regionFeedProvider);
    final pantryFeed = ref.watch(pantryFeedProvider);
    final cuisineFeed = ref.watch(cuisineFeedProvider);

    return RefreshIndicator(
      backgroundColor: AppTheme.cream,
      color: AppTheme.ink,
      onRefresh: () async {
        ref.invalidate(weatherProvider);
        ref.invalidate(regionProvider);
        ref.invalidate(featuredProvider);
        ref.invalidate(dayPartFeedProvider);
        ref.invalidate(weatherFeedProvider);
        ref.invalidate(regionFeedProvider);
        ref.invalidate(pantryFeedProvider);
        ref.invalidate(cuisineFeedProvider);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Masthead(
              greeting: dayPart.greeting(context),
              dayPartLabel: dayPart.label(context),
              weatherAsync: weatherAsync,
              onSettings: () => context.push('/preferences'),
            ),
          ),
          SliverToBoxAdapter(
            child: featured.when(
              data: (r) => r == null
                  ? const SizedBox.shrink()
                  : _Featured(r: r, kicker: l.homeFeaturedTag),
              loading: () => const _FeaturedSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: _Rail(
              eyebrow: dayPart.label(context),
              title: l.homeDayPartIdeasTitle(dayPart.label(context)),
              subtitle: l.homeDayPartIdeasSubtitle,
              feed: dayFeed,
            ),
          ),
          SliverToBoxAdapter(
            child: regionAsync.maybeWhen(
              data: (r) => r == null || r.mealDbArea == null
                  ? const SizedBox.shrink()
                  : _Rail(
                      eyebrow: 'Near you',
                      title: l.homeRegionTitle(r.country ?? r.mealDbArea!),
                      subtitle: l.homeRegionSubtitle(r.mealDbArea!),
                      feed: regionFeed,
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: weatherAsync.maybeWhen(
              data: (w) => w == null
                  ? const SizedBox.shrink()
                  : _Rail(
                      eyebrow: 'Weather',
                      title: l.homeWeatherTitle,
                      subtitle: weatherHintLocalized(
                        context,
                        tempC: w.tempC,
                        precipMm: w.precipMm,
                      ),
                      feed: weatherFeed,
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: pantryFeed.maybeWhen(
              data: (list) => list.isEmpty
                  ? const SizedBox.shrink()
                  : _Rail(
                      eyebrow: 'Pantry',
                      title: l.homePantryTitle,
                      subtitle: l.homePantrySubtitle,
                      feed: pantryFeed,
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: _Rail(
              eyebrow: 'Cuisines',
              title: l.homeCuisinesTitle,
              feed: cuisineFeed,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  final String greeting;
  final String dayPartLabel;
  final AsyncValue weatherAsync;
  final VoidCallback onSettings;
  const _Masthead({
    required this.greeting,
    required this.dayPartLabel,
    required this.weatherAsync,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('EEEE · d MMMM').format(DateTime.now()).toUpperCase();
    final weatherLine = weatherAsync.maybeWhen(
      data: (w) => w == null
          ? null
          : '${w.tempC.toStringAsFixed(0)}°  ${w.description.toUpperCase()}',
      orElse: () => null,
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 22, height: 1, color: AppTheme.ink),
                const SizedBox(width: 10),
                Text(dateLabel, style: AppTheme.eyebrow()),
                const Spacer(),
                if (weatherLine != null) ...[
                  Text(weatherLine, style: AppTheme.eyebrow()),
                  const SizedBox(width: 12),
                  Container(width: 12, height: 1, color: AppTheme.hairline),
                  const SizedBox(width: 12),
                ],
                GestureDetector(
                  onTap: onSettings,
                  child: const Icon(Icons.tune,
                      size: 18, color: AppTheme.ink),
                ),
              ],
            ),
            const SizedBox(height: 28),
            RichText(
              text: TextSpan(
                style: AppTheme.serif(
                  size: 64,
                  weight: FontWeight.w800,
                  height: 0.95,
                  letterSpacing: -2.4,
                  color: AppTheme.ink,
                ),
                children: const [
                  TextSpan(text: 'Skil'),
                  TextSpan(
                    text: 'l',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.terracotta,
                    ),
                  ),
                  TextSpan(text: 'et.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  greeting,
                  style: AppTheme.serif(
                    size: 18,
                    italic: true,
                    weight: FontWeight.w400,
                    color: AppTheme.ash,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 18, height: 1, color: AppTheme.hairline),
                const SizedBox(width: 10),
                Text(dayPartLabel.toUpperCase(),
                    style: AppTheme.eyebrow(color: AppTheme.ash)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Featured extends StatelessWidget {
  final Recipe r;
  final String kicker;
  const _Featured({required this.r, required this.kicker});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: GestureDetector(
        onTap: () => context.push('/recipe/${r.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppTheme.paper),
                  if (r.thumbnail != null)
                    CachedNetworkImage(
                      imageUrl: r.thumbnail!,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 500),
                    ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.ink.withValues(alpha: 0.20),
                          Colors.transparent,
                          AppTheme.ink.withValues(alpha: 0.55),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Row(
                      children: [
                        Container(width: 22, height: 1, color: AppTheme.cream),
                        const SizedBox(width: 10),
                        Text(
                          kicker.toUpperCase(),
                          style: AppTheme.eyebrow(color: AppTheme.cream),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((r.area ?? '').isNotEmpty)
                          Text(
                            r.area!.toUpperCase(),
                            style: AppTheme.eyebrow(
                                color: AppTheme.cream.withValues(alpha: 0.85)),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          r.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.serif(
                            size: 38,
                            weight: FontWeight.w700,
                            height: 1.05,
                            letterSpacing: -0.8,
                            color: AppTheme.cream,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: AppTheme.ink),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('READ THE RECIPE',
                    style: AppTheme.eyebrow(color: AppTheme.ink)),
                const Spacer(),
                const Icon(Icons.arrow_forward,
                    size: 16, color: AppTheme.ink),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSkeleton extends StatelessWidget {
  const _FeaturedSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(color: AppTheme.paper),
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final AsyncValue<List<Recipe>> feed;
  const _Rail({
    required this.title,
    this.eyebrow,
    this.subtitle,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, subtitle: subtitle, eyebrow: eyebrow),
        feed.when(
          data: (list) {
            if (list.isEmpty) return const SizedBox.shrink();
            return SizedBox(
              height: 360,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemBuilder: (_, i) => SizedBox(
                  width: 220,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 380 + i * 60),
                    curve: Curves.easeOutCubic,
                    builder: (_, t, child) => Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(0, (1 - t) * 18),
                        child: child,
                      ),
                    ),
                    child: RecipeCard(
                      recipe: list[i],
                      indexLabel: i + 1,
                      onTap: () => context.push('/recipe/${list[i].id}'),
                    ),
                  ),
                ),
              ),
            );
          },
          loading: () => const _RailSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();
  @override
  Widget build(BuildContext context) {
    Widget bar(double w, double h) =>
        Container(width: w, height: h, color: AppTheme.paper);
    return SizedBox(
      height: 360,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, __) => SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(color: AppTheme.paper),
              ),
              const SizedBox(height: 14),
              bar(80, 10),
              const SizedBox(height: 8),
              bar(double.infinity, 18),
              const SizedBox(height: 6),
              bar(140, 18),
            ],
          ),
        ),
      ),
    );
  }
}
