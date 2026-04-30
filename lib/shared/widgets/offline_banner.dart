import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/connectivity_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offline = ref.watch(isOfflineProvider);
    final l = AppLocalizations.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: !offline
          ? const SizedBox.shrink(key: ValueKey('online'))
          : Container(
              key: const ValueKey('offline'),
              width: double.infinity,
              color: AppTheme.ink,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(width: 14, height: 1, color: AppTheme.cream),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.offlineBanner.toUpperCase(),
                      style: AppTheme.eyebrow(color: AppTheme.cream, size: 11),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
