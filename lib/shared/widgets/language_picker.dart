import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class LanguageOption {
  final String code;
  final String label;
  const LanguageOption(this.code, this.label);
}

const supportedLanguages = <LanguageOption>[
  LanguageOption('en', 'English'),
  LanguageOption('hi', 'हिन्दी'),
  LanguageOption('es', 'Español'),
  LanguageOption('fr', 'Français'),
  LanguageOption('ar', 'العربية'),
];

class LanguagePicker extends ConsumerWidget {
  final bool allowSystem;
  const LanguagePicker({super.key, this.allowSystem = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);

    Widget tile(String? code, String label, String numLabel) {
      final selected = (current?.languageCode == code) ||
          (allowSystem && current == null && code == null);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          final notifier = ref.read(localeProvider.notifier);
          final prefs = ref.read(prefsStoreProvider);
          if (code == null) {
            notifier.state = null;
            await prefs.setLocaleCode('');
          } else {
            notifier.state = Locale(code);
            await prefs.setLocaleCode(code);
          }
          if (!context.mounted) return;
          final nav = Navigator.of(context);
          if (nav.canPop()) nav.pop();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.hairline),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  numLabel,
                  style: AppTheme.serif(
                    size: 14,
                    italic: true,
                    weight: FontWeight.w500,
                    color: selected
                        ? AppTheme.terracotta
                        : AppTheme.ash,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.serif(
                    size: 22,
                    weight: selected ? FontWeight.w700 : FontWeight.w500,
                    height: 1.1,
                    color: AppTheme.ink,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 16,
                height: 1,
                color: selected ? AppTheme.ink : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    final children = <Widget>[];
    var n = 0;
    if (allowSystem) {
      n += 1;
      children.add(tile(null, _systemLabel(context), n.toString().padLeft(2, '0')));
    }
    for (final lang in supportedLanguages) {
      n += 1;
      children
          .add(tile(lang.code, lang.label, n.toString().padLeft(2, '0')));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
  }

  String _systemLabel(BuildContext context) {
    try {
      return AppLocalizations.of(context).themeSystem;
    } catch (_) {
      return 'System';
    }
  }
}
