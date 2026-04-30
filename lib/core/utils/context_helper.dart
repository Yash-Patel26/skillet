enum DayPart { breakfast, lunch, snack, dinner, lateNight }

class ContextHelper {
  ContextHelper._();

  static DayPart dayPartFor(DateTime now) {
    final h = now.hour;
    if (h >= 5 && h < 11) return DayPart.breakfast;
    if (h >= 11 && h < 15) return DayPart.lunch;
    if (h >= 15 && h < 18) return DayPart.snack;
    if (h >= 18 && h < 22) return DayPart.dinner;
    return DayPart.lateNight;
  }

  static String dayPartLabel(DayPart p) {
    switch (p) {
      case DayPart.breakfast:
        return 'Breakfast';
      case DayPart.lunch:
        return 'Lunch';
      case DayPart.snack:
        return 'Snack time';
      case DayPart.dinner:
        return 'Dinner';
      case DayPart.lateNight:
        return 'Late night';
    }
  }

  static String greetingFor(DayPart p) {
    switch (p) {
      case DayPart.breakfast:
        return 'Good morning';
      case DayPart.lunch:
        return 'Good afternoon';
      case DayPart.snack:
        return 'Afternoon snack?';
      case DayPart.dinner:
        return 'Good evening';
      case DayPart.lateNight:
        return 'Late night cravings?';
    }
  }

  static List<String> categoriesForDayPart(DayPart p) {
    switch (p) {
      case DayPart.breakfast:
        return ['Breakfast', 'Dessert'];
      case DayPart.lunch:
        return ['Chicken', 'Pasta', 'Vegetarian'];
      case DayPart.snack:
        return ['Side', 'Dessert', 'Starter'];
      case DayPart.dinner:
        return ['Beef', 'Seafood', 'Pasta', 'Chicken'];
      case DayPart.lateNight:
        return ['Dessert', 'Side'];
    }
  }

  static String weatherHint({required double tempC, required double precipMm}) {
    if (precipMm > 0.5) return 'Rainy weather — warm soups & curries';
    if (tempC <= 12) return 'Cold day — go for hearty, warming meals';
    if (tempC >= 30) return 'Hot day — try fresh salads & light bites';
    return 'Pleasant weather — anything goes';
  }

  static List<String> categoriesForWeather({
    required double tempC,
    required double precipMm,
  }) {
    if (precipMm > 0.5 || tempC <= 12) {
      return ['Beef', 'Chicken', 'Pasta'];
    }
    if (tempC >= 30) {
      return ['Vegetarian', 'Seafood', 'Side'];
    }
    return ['Chicken', 'Vegetarian'];
  }
}
