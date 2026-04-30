import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/offline_banner.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  static const _paths = ['/home', '/search', '/favorites', '/profile'];

  int _indexFor(String location) {
    for (var i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tabs = [
      (path: '/home', label: l.navHome, icon: Icons.menu_book_outlined),
      (path: '/search', label: l.navSearch, icon: Icons.search),
      (path: '/favorites', label: l.navSaved, icon: Icons.bookmark_outline),
      (path: '/profile', label: l.navMe, icon: Icons.person_outline),
    ];
    final location = GoRouterState.of(context).uri.toString();
    final idx = _indexFor(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OfflineBanner(),
          Container(height: 1, color: AppTheme.hairline),
          SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    Expanded(
                      child: _NavItem(
                        label: tabs[i].label,
                        icon: tabs[i].icon,
                        active: i == idx,
                        onTap: () => context.go(tabs[i].path),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.ink : AppTheme.sage;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: active ? 22 : 0,
            height: 1,
            color: AppTheme.ink,
          ),
          const SizedBox(height: 6),
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: AppTheme.eyebrow(color: color, size: 9.5),
          ),
        ],
      ),
    );
  }
}
