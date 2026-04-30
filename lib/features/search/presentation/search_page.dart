import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/recipe_card.dart';
import '../providers/search_providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _ctl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctl.dispose();
    super.dispose();
  }

  void _onText(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).update(
            (q) => q.copyWith(
              text: v,
              clearCategory: true,
              clearArea: true,
              clearIngredient: true,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final q = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final cats = ref.watch(categoriesListProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 22, height: 1, color: AppTheme.ink),
                    const SizedBox(width: 10),
                    Text('FIND', style: AppTheme.eyebrow()),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l.searchHint,
                  style: AppTheme.serif(
                    size: 36,
                    weight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 18),
                _SearchField(
                  ctl: _ctl,
                  hint: l.searchHint,
                  onChanged: _onText,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 38,
            child: cats.maybeWhen(
              data: (list) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (_, i) {
                  final c = list[i];
                  final selected = q.category == c;
                  return GestureDetector(
                    onTap: () {
                      _ctl.clear();
                      ref.read(searchQueryProvider.notifier).state =
                          SearchQuery(category: selected ? null : c);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          c.toUpperCase(),
                          style: AppTheme.eyebrow(
                            color: selected ? AppTheme.ink : AppTheme.ash,
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 1,
                          width: selected ? 28 : 0,
                          color: AppTheme.ink,
                        ),
                      ],
                    ),
                  );
                },
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: q.isEmpty
                ? _IdleState(message: l.searchEmpty)
                : results.when(
                    data: (list) => list.isEmpty
                        ? _IdleState(message: l.searchNoResults)
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 28,
                              childAspectRatio: 0.58,
                            ),
                            itemCount: list.length,
                            itemBuilder: (_, i) => RecipeCard(
                              recipe: list[i],
                              indexLabel: i + 1,
                              onTap: () =>
                                  context.push('/recipe/${list[i].id}'),
                            ),
                          ),
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: AppTheme.ink)),
                    error: (e, _) => _IdleState(message: '$e'),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController ctl;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchField({
    required this.ctl,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.ink, width: 1.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: AppTheme.ink),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: ctl,
              onChanged: onChanged,
              cursorColor: AppTheme.ink,
              style: AppTheme.serif(
                size: 22,
                weight: FontWeight.w500,
                color: AppTheme.ink,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTheme.serif(
                  size: 22,
                  italic: true,
                  weight: FontWeight.w400,
                  color: AppTheme.sage,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
              ),
            ),
          ),
          if (ctl.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                ctl.clear();
                onChanged('');
              },
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: AppTheme.ink),
              ),
            ),
        ],
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  final String message;
  const _IdleState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTheme.serif(
            size: 17,
            italic: true,
            weight: FontWeight.w400,
            color: AppTheme.sage,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
