import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/language_picker.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});
  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _ctl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final slides = <_SlideData>[
      _SlideData.languageStep(
        kicker: 'BEGIN',
        title: l.languageStepTitle,
        body: l.languageStepSubtitle,
      ),
      _SlideData.figure(
        number: '01',
        kicker: 'CHAPTER ONE',
        title: l.onboardOneTitle,
        body: l.onboardOneBody,
        glyph: '☼',
      ),
      _SlideData.figure(
        number: '02',
        kicker: 'CHAPTER TWO',
        title: l.onboardTwoTitle,
        body: l.onboardTwoBody,
        glyph: '◐',
      ),
      _SlideData.figure(
        number: '03',
        kicker: 'CHAPTER THREE',
        title: l.onboardThreeTitle,
        body: l.onboardThreeBody,
        glyph: '✦',
      ),
    ];

    final isLast = _index == slides.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(width: 22, height: 1, color: AppTheme.ink),
                  const SizedBox(width: 10),
                  Text('SKILLET — A FIELD GUIDE',
                      style: AppTheme.eyebrow()),
                  const Spacer(),
                  Text(
                    '${(_index + 1).toString().padLeft(2, '0')} / ${slides.length.toString().padLeft(2, '0')}',
                    style: AppTheme.eyebrow(color: AppTheme.ash),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctl,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: slides.length,
                itemBuilder: (_, i) => _Slide(data: slides[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(
                  slides.length,
                  (i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                        height: 1,
                        color: i == _index
                            ? AppTheme.ink
                            : AppTheme.hairline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (isLast) {
                      context.go('/preferences?initial=true');
                    } else {
                      _ctl.nextPage(
                        duration: const Duration(milliseconds: 380),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                  child: Text(
                    isLast
                        ? l.onboardCta.toUpperCase()
                        : (_index == 0
                            ? l.continueAction.toUpperCase()
                            : l.next.toUpperCase()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final String kicker;
  final String title;
  final String body;
  final String? number;
  final String? glyph;
  final bool isLanguage;
  const _SlideData._({
    required this.kicker,
    required this.title,
    required this.body,
    this.number,
    this.glyph,
    this.isLanguage = false,
  });
  factory _SlideData.figure({
    required String number,
    required String kicker,
    required String title,
    required String body,
    required String glyph,
  }) =>
      _SlideData._(
        kicker: kicker,
        title: title,
        body: body,
        number: number,
        glyph: glyph,
      );
  factory _SlideData.languageStep({
    required String kicker,
    required String title,
    required String body,
  }) =>
      _SlideData._(
        kicker: kicker,
        title: title,
        body: body,
        isLanguage: true,
      );
}

class _Slide extends StatelessWidget {
  final _SlideData data;
  const _Slide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!data.isLanguage)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.number ?? '',
                  style: AppTheme.serif(
                    size: 96,
                    weight: FontWeight.w700,
                    italic: true,
                    height: 0.8,
                    color: AppTheme.terracotta,
                    letterSpacing: -3,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  data.glyph ?? '',
                  style: AppTheme.serif(
                    size: 48,
                    weight: FontWeight.w400,
                    color: AppTheme.ink,
                    height: 1,
                  ),
                ),
              ],
            ),
          if (data.isLanguage)
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.ink, width: 1.2),
              ),
              child: const Icon(Icons.language,
                  size: 28, color: AppTheme.ink),
            ),
          const SizedBox(height: 28),
          Text(data.kicker, style: AppTheme.eyebrow()),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: AppTheme.serif(
              size: 38,
              weight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.body,
            style: AppTheme.serif(
              size: 16,
              italic: true,
              weight: FontWeight.w400,
              height: 1.55,
              color: AppTheme.ash,
            ),
          ),
          if (data.isLanguage) ...[
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: const LanguagePicker(allowSystem: true),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
