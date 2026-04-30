import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skillet/l10n/app_localizations.dart';

/// Probe widget — renders the favoritesTitle and next strings so the test
/// can assert on visible text after a locale change.
class _Probe extends StatelessWidget {
  const _Probe();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Text(l.favoritesTitle, key: const Key('favoritesTitle')),
        Text(l.next, key: const Key('next')),
      ],
    );
  }
}

class _LocaleApp extends ConsumerWidget {
  const _LocaleApp();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(_localeForTest);
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: _Probe()),
    );
  }
}

final _localeForTest = StateProvider<Locale?>((_) => const Locale('en'));

void main() {
  testWidgets('Locale switches change visible UI text',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _LocaleApp(),
      ),
    );
    await tester.pumpAndSettle();

    // English baseline
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    // → Hindi
    container.read(_localeForTest.notifier).state = const Locale('hi');
    await tester.pumpAndSettle();
    expect(find.text('सेव किए गए'), findsOneWidget);
    expect(find.text('आगे'), findsOneWidget);
    expect(find.text('Saved'), findsNothing);

    // → Spanish
    container.read(_localeForTest.notifier).state = const Locale('es');
    await tester.pumpAndSettle();
    expect(find.text('Guardados'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);

    // → French
    container.read(_localeForTest.notifier).state = const Locale('fr');
    await tester.pumpAndSettle();
    expect(find.text('Favoris'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);

    // → Arabic (RTL)
    container.read(_localeForTest.notifier).state = const Locale('ar');
    await tester.pumpAndSettle();
    expect(find.text('المحفوظات'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
  });
}
