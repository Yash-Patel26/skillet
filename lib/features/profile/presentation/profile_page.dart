import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/language_picker.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(userPrefsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentLanguage = currentLocale == null
        ? l.themeSystem
        : supportedLanguages
            .firstWhere(
              (e) => e.code == currentLocale.languageCode,
              orElse: () => supportedLanguages.first,
            )
            .label;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
        children: [
          // Masthead
          Row(
            children: [
              Container(width: 22, height: 1, color: AppTheme.ink),
              const SizedBox(width: 10),
              Text('THE COOK', style: AppTheme.eyebrow()),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l.profileGreeting,
            style: AppTheme.serif(
              size: 40,
              weight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.profileMetaLine(
              prefs.diet.label(context),
              prefs.skill.label(context),
            ),
            style: AppTheme.serif(
              size: 16,
              italic: true,
              weight: FontWeight.w400,
              color: AppTheme.ash,
            ),
          ),
          const SizedBox(height: 32),
          Container(height: 1, color: AppTheme.ink),

          _Tile(
            label: 'PREFERENCES',
            title: l.profilePreferences,
            value: l.profilePreferencesSub,
            onTap: () => context.push('/preferences'),
          ),
          _Tile(
            label: 'PANTRY',
            title: l.profilePantry,
            value: prefs.pantry.isEmpty
                ? l.profilePantryEmpty
                : l.profilePantryCount(prefs.pantry.length),
            onTap: () => context.push('/preferences'),
          ),
          _Tile(
            label: 'LANGUAGE',
            title: l.profileLanguage,
            value: currentLanguage,
            onTap: () => _openLanguageSheet(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('APPEARANCE', style: AppTheme.eyebrow()),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ThemeChip(
                        label: l.themeSystem,
                        active: themeMode == ThemeMode.system,
                        onTap: () => _setTheme(ref, ThemeMode.system),
                      ),
                    ),
                    Expanded(
                      child: _ThemeChip(
                        label: l.themeLight,
                        active: themeMode == ThemeMode.light,
                        onTap: () => _setTheme(ref, ThemeMode.light),
                      ),
                    ),
                    Expanded(
                      child: _ThemeChip(
                        label: l.themeDark,
                        active: themeMode == ThemeMode.dark,
                        onTap: () => _setTheme(ref, ThemeMode.dark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppTheme.hairline),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  '${l.appName.toUpperCase()}  ·  VOL. I',
                  style: AppTheme.eyebrow(color: AppTheme.sage),
                ),
                const SizedBox(height: 4),
                Text(
                  'A field guide to cooking with the moment',
                  style: AppTheme.serif(
                    size: 13,
                    italic: true,
                    color: AppTheme.sage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setTheme(WidgetRef ref, ThemeMode mode) async {
    ref.read(themeModeProvider.notifier).state = mode;
    await ref.read(prefsStoreProvider).setThemeMode(mode.name);
  }

  void _openLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cream,
      shape: const RoundedRectangleBorder(),
      builder: (ctx) {
        final l = AppLocalizations.of(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(width: 22, height: 1, color: AppTheme.ink),
                    const SizedBox(width: 10),
                    Text('LANGUAGE', style: AppTheme.eyebrow()),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l.profileLanguage,
                  style: AppTheme.serif(
                    size: 28,
                    weight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 18),
                const LanguagePicker(allowSystem: true),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  final String label;
  final String title;
  final String value;
  final VoidCallback onTap;
  const _Tile({
    required this.label,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 22),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: AppTheme.eyebrow()),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: AppTheme.serif(
                          size: 22,
                          weight: FontWeight.w600,
                          height: 1.15,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: AppTheme.serif(
                          size: 13,
                          italic: true,
                          color: AppTheme.ash,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    size: 18, color: AppTheme.ink),
              ],
            ),
          ),
        ),
        Container(height: 1, color: AppTheme.hairline),
      ],
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ThemeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppTheme.ink : Colors.transparent,
          border: Border.all(
            color: active ? AppTheme.ink : AppTheme.hairline,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTheme.eyebrow(
            color: active ? AppTheme.cream : AppTheme.ink,
            size: 11,
          ),
        ),
      ),
    );
  }
}
