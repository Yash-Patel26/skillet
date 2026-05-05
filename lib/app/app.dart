import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';

class SkilletApp extends ConsumerStatefulWidget {
  const SkilletApp({super.key});

  @override
  ConsumerState<SkilletApp> createState() => _SkilletAppState();
}

class _SkilletAppState extends ConsumerState<SkilletApp> {
  Future<void> _initializePushNotifications() async {
    await ref.read(pushNotificationsServiceProvider).init(
          onOpenRecipe: (id) => ref.read(routerProvider).go('/recipe/$id'),
        );
  }

  @override
  void initState() {
    super.initState();
    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    final isWidgetTest = bindingName.contains('TestWidgetsFlutterBinding');
    if (isWidgetTest) return;
    _initializePushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
