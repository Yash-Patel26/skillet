// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Skillet';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get previous => 'Previous';

  @override
  String get cancel => 'Cancel';

  @override
  String get seeAll => 'See all';

  @override
  String get languageStepTitle => 'Choose your language';

  @override
  String get languageStepSubtitle =>
      'You can change this later in your profile.';

  @override
  String get continueAction => 'Continue';

  @override
  String get onboardOneTitle => 'Cook with the moment';

  @override
  String get onboardOneBody =>
      'Skillet picks recipes that match the time of day, the weather, and what you have on hand.';

  @override
  String get onboardTwoTitle => 'Use what you have';

  @override
  String get onboardTwoBody =>
      'Tell us what is in your pantry. We will suggest recipes you can actually make right now.';

  @override
  String get onboardThreeTitle => 'Save and cook';

  @override
  String get onboardThreeBody =>
      'Bookmark recipes for later and follow step-by-step cook mode with the screen always on.';

  @override
  String get onboardCta => 'Set my preferences';

  @override
  String get prefsTitleInitial => 'Tell us about you';

  @override
  String get prefsTitle => 'Preferences';

  @override
  String get prefsDiet => 'Diet';

  @override
  String get prefsSkill => 'Cooking skill';

  @override
  String get prefsAllergies => 'Allergies & avoid';

  @override
  String get prefsCuisines => 'Favorite cuisines';

  @override
  String get prefsPantryTitle => 'What is in your pantry?';

  @override
  String get prefsPantrySubtitle =>
      'We will suggest recipes you can make with these ingredients.';

  @override
  String get prefsPantryHint => 'e.g. chicken, tomato';

  @override
  String get prefsStartCooking => 'Start cooking';

  @override
  String get dietAny => 'Anything';

  @override
  String get dietVegetarian => 'Vegetarian';

  @override
  String get dietVegan => 'Vegan';

  @override
  String get dietNonVeg => 'Non-veg';

  @override
  String get skillBeginner => 'Beginner';

  @override
  String get skillIntermediate => 'Intermediate';

  @override
  String get skillPro => 'Pro';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingSnack => 'Afternoon snack?';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingLateNight => 'Late night cravings?';

  @override
  String get dayPartBreakfast => 'Breakfast';

  @override
  String get dayPartLunch => 'Lunch';

  @override
  String get dayPartSnack => 'Snack time';

  @override
  String get dayPartDinner => 'Dinner';

  @override
  String get dayPartLateNight => 'Late night';

  @override
  String get homeFeaturedTag => 'TRY TODAY';

  @override
  String homeDayPartIdeasTitle(String label) {
    return '$label ideas';
  }

  @override
  String get homeDayPartIdeasSubtitle => 'Picked for the time of day';

  @override
  String homeRegionTitle(String country) {
    return 'Trending in $country';
  }

  @override
  String homeRegionSubtitle(String cuisine) {
    return '$cuisine cuisine, near you';
  }

  @override
  String get homeWeatherTitle => 'Weather pick';

  @override
  String get homePantryTitle => 'Use what you have';

  @override
  String get homePantrySubtitle => 'From your pantry';

  @override
  String get homeCuisinesTitle => 'From your favorite cuisines';

  @override
  String get weatherRainy => 'Rainy weather — warm soups & curries';

  @override
  String get weatherCold => 'Cold day — hearty, warming meals';

  @override
  String get weatherHot => 'Hot day — fresh salads & light bites';

  @override
  String get weatherPleasant => 'Pleasant weather — anything goes';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navSaved => 'Saved';

  @override
  String get navMe => 'Me';

  @override
  String get searchHint => 'Search recipes';

  @override
  String get searchEmpty => 'Search by name or pick a category';

  @override
  String get searchNoResults => 'No recipes found';

  @override
  String get detailIngredients => 'Ingredients';

  @override
  String get detailInstructions => 'Instructions';

  @override
  String get detailStartCooking => 'Start cooking';

  @override
  String get detailNotFound => 'Recipe not found';

  @override
  String cookStepCounter(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get cookNoSteps => 'No steps available';

  @override
  String get favoritesTitle => 'Saved';

  @override
  String get favoritesEmpty => 'No saved recipes yet';

  @override
  String get favoritesEmptyHint =>
      'Tap the bookmark icon on any recipe to save it for later.';

  @override
  String get profileTitle => 'Me';

  @override
  String get profileGreeting => 'Hello, Chef';

  @override
  String profileMetaLine(String diet, String skill) {
    return '$diet · $skill';
  }

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profilePreferencesSub => 'Diet, allergies, cuisines, pantry';

  @override
  String get profilePantry => 'Pantry';

  @override
  String get profilePantryEmpty => 'No items yet';

  @override
  String profilePantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get offlineBanner =>
      'You are offline · showing saved & cached recipes';

  @override
  String get errorGeneric => 'Something went wrong. Try again.';

  @override
  String get errorNoNetwork => 'Network error. Check your connection.';
}
