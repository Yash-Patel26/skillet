import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../data/models/user_prefs.dart';
import '../../../l10n/app_localizations.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  final bool isInitial;
  const PreferencesPage({super.key, this.isInitial = false});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  static const _allergyOptions = [
    'Peanut', 'Tree nut', 'Dairy', 'Egg', 'Gluten', 'Soy', 'Shellfish', 'Fish',
  ];
  static const _cuisineOptions = [
    'Indian', 'Italian', 'Chinese', 'Mexican', 'American', 'Thai', 'Japanese',
    'French', 'Greek', 'Turkish', 'Moroccan', 'British',
  ];

  late DietPref _diet;
  late SkillLevel _skill;
  late Set<String> _allergies;
  late Set<String> _cuisines;
  final _pantryCtl = TextEditingController();
  late List<String> _pantry;

  @override
  void initState() {
    super.initState();
    final p = ref.read(userPrefsProvider);
    _diet = p.diet;
    _skill = p.skill;
    _allergies = p.allergies.toSet();
    _cuisines = p.cuisines.toSet();
    _pantry = [...p.pantry];
  }

  @override
  void dispose() {
    _pantryCtl.dispose();
    super.dispose();
  }

  void _addPantryItem() {
    final v = _pantryCtl.text.trim();
    if (v.isEmpty) return;
    setState(() {
      if (!_pantry.contains(v.toLowerCase())) _pantry.add(v.toLowerCase());
      _pantryCtl.clear();
    });
  }

  Future<void> _save() async {
    final next = UserPrefs(
      diet: _diet,
      allergies: _allergies.toList(),
      cuisines: _cuisines.toList(),
      skill: _skill,
      pantry: _pantry,
    );
    await ref.read(userPrefsProvider.notifier).update(next);
    if (widget.isInitial) {
      await ref.read(prefsStoreProvider).setOnboardingDone(true);
      final notifications = ref.read(notificationsServiceProvider);
      final granted = await notifications.requestPermission();
      if (granted) {
        unawaited(notifications
            .scheduleDailyMealReminders(ref.read(recipeRepositoryProvider)));
      }
    }
    if (!mounted) return;
    if (widget.isInitial) {
      context.go('/home');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  if (!widget.isInitial)
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppTheme.ink, width: 1),
                        ),
                        child: const Icon(Icons.arrow_back,
                            size: 18, color: AppTheme.ink),
                      ),
                    )
                  else
                    Container(width: 22, height: 1, color: AppTheme.ink),
                  const SizedBox(width: 14),
                  Text('PROFILE', style: AppTheme.eyebrow()),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  Text(
                    widget.isInitial ? l.prefsTitleInitial : l.prefsTitle,
                    style: AppTheme.serif(
                      size: 36,
                      weight: FontWeight.w700,
                      height: 1.05,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell Skillet how to cook for you.',
                    style: AppTheme.serif(
                      size: 15,
                      italic: true,
                      color: AppTheme.ash,
                      height: 1.5,
                    ),
                  ),
                  _section('01', l.prefsDiet),
                  _chipRow(
                    items: DietPref.values
                        .map((d) => (
                              label: d.label(context),
                              selected: _diet == d,
                              onTap: () => setState(() => _diet = d),
                            ))
                        .toList(),
                  ),
                  _section('02', l.prefsSkill),
                  _chipRow(
                    items: SkillLevel.values
                        .map((s) => (
                              label: s.label(context),
                              selected: _skill == s,
                              onTap: () => setState(() => _skill = s),
                            ))
                        .toList(),
                  ),
                  _section('03', l.prefsAllergies),
                  _chipRow(
                    items: _allergyOptions
                        .map((a) => (
                              label: a,
                              selected: _allergies.contains(a),
                              onTap: () => setState(() {
                                if (_allergies.contains(a)) {
                                  _allergies.remove(a);
                                } else {
                                  _allergies.add(a);
                                }
                              }),
                            ))
                        .toList(),
                  ),
                  _section('04', l.prefsCuisines),
                  _chipRow(
                    items: _cuisineOptions
                        .map((c) => (
                              label: c,
                              selected: _cuisines.contains(c),
                              onTap: () => setState(() {
                                if (_cuisines.contains(c)) {
                                  _cuisines.remove(c);
                                } else {
                                  _cuisines.add(c);
                                }
                              }),
                            ))
                        .toList(),
                  ),
                  _section('05', l.prefsPantryTitle),
                  Text(
                    l.prefsPantrySubtitle,
                    style: AppTheme.serif(
                      size: 14,
                      italic: true,
                      color: AppTheme.ash,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppTheme.ink, width: 1.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pantryCtl,
                            style: AppTheme.serif(
                              size: 18,
                              weight: FontWeight.w500,
                            ),
                            cursorColor: AppTheme.ink,
                            decoration: InputDecoration(
                              hintText: l.prefsPantryHint,
                              hintStyle: AppTheme.serif(
                                size: 18,
                                italic: true,
                                color: AppTheme.sage,
                              ),
                              filled: false,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onSubmitted: (_) => _addPantryItem(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _addPantryItem,
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.add,
                                color: AppTheme.ink, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _pantry
                        .map(
                          (i) => InputChip(
                            label: Text(i),
                            labelStyle: AppTheme.serif(
                              size: 13,
                              weight: FontWeight.w500,
                            ),
                            backgroundColor: AppTheme.paper,
                            shape: const StadiumBorder(
                                side: BorderSide(color: AppTheme.hairline)),
                            onDeleted: () =>
                                setState(() => _pantry.remove(i)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text((widget.isInitial
                          ? l.prefsStartCooking
                          : l.save)
                      .toUpperCase()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String num, String label) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 14),
        child: Row(
          children: [
            Text(
              num,
              style: AppTheme.serif(
                size: 18,
                weight: FontWeight.w600,
                italic: true,
                color: AppTheme.terracotta,
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 12, height: 1, color: AppTheme.hairline),
            const SizedBox(width: 10),
            Text(label.toUpperCase(), style: AppTheme.eyebrow()),
          ],
        ),
      );

  Widget _chipRow(
      {required List<({String label, bool selected, VoidCallback onTap})>
          items}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (it) => GestureDetector(
              onTap: it.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: it.selected ? AppTheme.ink : Colors.transparent,
                  border: Border.all(
                    color: it.selected ? AppTheme.ink : AppTheme.hairline,
                    width: 1,
                  ),
                ),
                child: Text(
                  it.label,
                  style: AppTheme.serif(
                    size: 14,
                    weight: it.selected ? FontWeight.w600 : FontWeight.w500,
                    color: it.selected ? AppTheme.cream : AppTheme.ink,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
