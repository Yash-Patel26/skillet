import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../recipe_detail/providers/recipe_detail_providers.dart';

class CookModePage extends ConsumerStatefulWidget {
  final String id;
  const CookModePage({super.key, required this.id});

  @override
  ConsumerState<CookModePage> createState() => _CookModePageState();
}

class _CookModePageState extends ConsumerState<CookModePage> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(recipeByIdProvider(widget.id));
    return Scaffold(
      backgroundColor: AppTheme.ink,
      body: async.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.cream),
        ),
        error: (e, _) => Center(
          child: Text('$e',
              style: AppTheme.serif(size: 14, color: AppTheme.cream)),
        ),
        data: (r) {
          if (r == null) {
            return Center(
              child: Text(l.detailNotFound,
                  style: AppTheme.serif(size: 18, color: AppTheme.cream)),
            );
          }
          final steps = r.instructionSteps();
          if (steps.isEmpty) {
            return Center(
              child: Text(l.cookNoSteps,
                  style: AppTheme.serif(
                      size: 18, italic: true, color: AppTheme.cream)),
            );
          }
          final clamped = _step.clamp(0, steps.length - 1);
          final progress = (clamped + 1) / steps.length;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.cream.withValues(alpha: 0.30),
                              width: 1,
                            ),
                          ),
                          child: const Icon(Icons.close,
                              color: AppTheme.cream, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          r.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.serif(
                            size: 14,
                            italic: true,
                            color: AppTheme.cream.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Stack(
                    children: [
                      Container(
                        height: 1,
                        color: AppTheme.cream.withValues(alpha: 0.20),
                      ),
                      LayoutBuilder(
                        builder: (_, c) => AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                          height: 1,
                          width: c.maxWidth * progress,
                          color: AppTheme.terracotta,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        (clamped + 1).toString().padLeft(2, '0'),
                        style: AppTheme.serif(
                          size: 64,
                          weight: FontWeight.w700,
                          italic: true,
                          height: 1,
                          color: AppTheme.terracotta,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                            width: 16,
                            height: 1,
                            color: AppTheme.cream.withValues(alpha: 0.40)),
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'OF ${steps.length.toString().padLeft(2, '0')}',
                          style: AppTheme.eyebrow(
                            color: AppTheme.cream.withValues(alpha: 0.60),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        steps[clamped],
                        style: AppTheme.serif(
                          size: 26,
                          weight: FontWeight.w500,
                          height: 1.4,
                          letterSpacing: -0.2,
                          color: AppTheme.cream,
                        ),
                      ),
                    ),
                  ),

                  // Controls
                  Row(
                    children: [
                      Expanded(
                        child: _ChromeBtn(
                          label: l.previous,
                          onTap: clamped == 0
                              ? null
                              : () => setState(() => _step = clamped - 1),
                          subtle: true,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _ChromeBtn(
                          label: clamped == steps.length - 1 ? l.done : l.next,
                          onTap: clamped == steps.length - 1
                              ? () => context.pop()
                              : () => setState(() => _step = clamped + 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChromeBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool subtle;
  const _ChromeBtn({
    required this.label,
    this.onTap,
    this.subtle = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: subtle
              ? Colors.transparent
              : (disabled
                  ? AppTheme.cream.withValues(alpha: 0.12)
                  : AppTheme.cream),
          border: Border.all(
            color: subtle
                ? AppTheme.cream.withValues(alpha: 0.30)
                : AppTheme.cream,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTheme.eyebrow(
            color: subtle ? AppTheme.cream : AppTheme.ink,
            size: 12,
          ),
        ),
      ),
    );
  }
}
