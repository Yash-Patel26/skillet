import 'package:flutter/widgets.dart';

import '../../data/models/user_prefs.dart';
import '../../l10n/app_localizations.dart';
import 'context_helper.dart';

extension DietPrefLabel on DietPref {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (this) {
      case DietPref.any:
        return l.dietAny;
      case DietPref.vegetarian:
        return l.dietVegetarian;
      case DietPref.vegan:
        return l.dietVegan;
      case DietPref.nonVeg:
        return l.dietNonVeg;
    }
  }
}

extension SkillLevelLabel on SkillLevel {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (this) {
      case SkillLevel.beginner:
        return l.skillBeginner;
      case SkillLevel.intermediate:
        return l.skillIntermediate;
      case SkillLevel.pro:
        return l.skillPro;
    }
  }
}

extension DayPartLabel on DayPart {
  String label(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (this) {
      case DayPart.breakfast:
        return l.dayPartBreakfast;
      case DayPart.lunch:
        return l.dayPartLunch;
      case DayPart.snack:
        return l.dayPartSnack;
      case DayPart.dinner:
        return l.dayPartDinner;
      case DayPart.lateNight:
        return l.dayPartLateNight;
    }
  }

  String greeting(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (this) {
      case DayPart.breakfast:
        return l.greetingMorning;
      case DayPart.lunch:
        return l.greetingAfternoon;
      case DayPart.snack:
        return l.greetingSnack;
      case DayPart.dinner:
        return l.greetingEvening;
      case DayPart.lateNight:
        return l.greetingLateNight;
    }
  }
}

String weatherHintLocalized(
  BuildContext context, {
  required double tempC,
  required double precipMm,
}) {
  final l = AppLocalizations.of(context);
  if (precipMm > 0.5) return l.weatherRainy;
  if (tempC <= 12) return l.weatherCold;
  if (tempC >= 30) return l.weatherHot;
  return l.weatherPleasant;
}
