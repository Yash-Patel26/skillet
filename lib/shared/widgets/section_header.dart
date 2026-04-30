import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? eyebrow;
  final VoidCallback? onSeeAll;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 22, height: 1, color: AppTheme.ink),
              const SizedBox(width: 10),
              Text(
                (eyebrow ?? title).toUpperCase(),
                style: AppTheme.eyebrow(color: AppTheme.ink),
              ),
              const Spacer(),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).seeAll.toUpperCase(),
                        style: AppTheme.eyebrow(color: AppTheme.ash),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward,
                          size: 14, color: AppTheme.ash),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTheme.serif(
              size: 26,
              weight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.4,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTheme.serif(
                size: 14,
                italic: true,
                weight: FontWeight.w400,
                color: AppTheme.ash,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
