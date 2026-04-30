import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Skillet'**
  String get appName;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @languageStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageStepTitle;

  /// No description provided for @languageStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in your profile.'**
  String get languageStepSubtitle;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @onboardOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Cook with the moment'**
  String get onboardOneTitle;

  /// No description provided for @onboardOneBody.
  ///
  /// In en, this message translates to:
  /// **'Skillet picks recipes that match the time of day, the weather, and what you have on hand.'**
  String get onboardOneBody;

  /// No description provided for @onboardTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Use what you have'**
  String get onboardTwoTitle;

  /// No description provided for @onboardTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us what is in your pantry. We will suggest recipes you can actually make right now.'**
  String get onboardTwoBody;

  /// No description provided for @onboardThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save and cook'**
  String get onboardThreeTitle;

  /// No description provided for @onboardThreeBody.
  ///
  /// In en, this message translates to:
  /// **'Bookmark recipes for later and follow step-by-step cook mode with the screen always on.'**
  String get onboardThreeBody;

  /// No description provided for @onboardCta.
  ///
  /// In en, this message translates to:
  /// **'Set my preferences'**
  String get onboardCta;

  /// No description provided for @prefsTitleInitial.
  ///
  /// In en, this message translates to:
  /// **'Tell us about you'**
  String get prefsTitleInitial;

  /// No description provided for @prefsTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get prefsTitle;

  /// No description provided for @prefsDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get prefsDiet;

  /// No description provided for @prefsSkill.
  ///
  /// In en, this message translates to:
  /// **'Cooking skill'**
  String get prefsSkill;

  /// No description provided for @prefsAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies & avoid'**
  String get prefsAllergies;

  /// No description provided for @prefsCuisines.
  ///
  /// In en, this message translates to:
  /// **'Favorite cuisines'**
  String get prefsCuisines;

  /// No description provided for @prefsPantryTitle.
  ///
  /// In en, this message translates to:
  /// **'What is in your pantry?'**
  String get prefsPantryTitle;

  /// No description provided for @prefsPantrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will suggest recipes you can make with these ingredients.'**
  String get prefsPantrySubtitle;

  /// No description provided for @prefsPantryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. chicken, tomato'**
  String get prefsPantryHint;

  /// No description provided for @prefsStartCooking.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get prefsStartCooking;

  /// No description provided for @dietAny.
  ///
  /// In en, this message translates to:
  /// **'Anything'**
  String get dietAny;

  /// No description provided for @dietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get dietVegetarian;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietNonVeg.
  ///
  /// In en, this message translates to:
  /// **'Non-veg'**
  String get dietNonVeg;

  /// No description provided for @skillBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get skillBeginner;

  /// No description provided for @skillIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get skillIntermediate;

  /// No description provided for @skillPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get skillPro;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingSnack.
  ///
  /// In en, this message translates to:
  /// **'Afternoon snack?'**
  String get greetingSnack;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingLateNight.
  ///
  /// In en, this message translates to:
  /// **'Late night cravings?'**
  String get greetingLateNight;

  /// No description provided for @dayPartBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get dayPartBreakfast;

  /// No description provided for @dayPartLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get dayPartLunch;

  /// No description provided for @dayPartSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack time'**
  String get dayPartSnack;

  /// No description provided for @dayPartDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dayPartDinner;

  /// No description provided for @dayPartLateNight.
  ///
  /// In en, this message translates to:
  /// **'Late night'**
  String get dayPartLateNight;

  /// No description provided for @homeFeaturedTag.
  ///
  /// In en, this message translates to:
  /// **'TRY TODAY'**
  String get homeFeaturedTag;

  /// No description provided for @homeDayPartIdeasTitle.
  ///
  /// In en, this message translates to:
  /// **'{label} ideas'**
  String homeDayPartIdeasTitle(String label);

  /// No description provided for @homeDayPartIdeasSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Picked for the time of day'**
  String get homeDayPartIdeasSubtitle;

  /// No description provided for @homeRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending in {country}'**
  String homeRegionTitle(String country);

  /// No description provided for @homeRegionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{cuisine} cuisine, near you'**
  String homeRegionSubtitle(String cuisine);

  /// No description provided for @homeWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather pick'**
  String get homeWeatherTitle;

  /// No description provided for @homePantryTitle.
  ///
  /// In en, this message translates to:
  /// **'Use what you have'**
  String get homePantryTitle;

  /// No description provided for @homePantrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'From your pantry'**
  String get homePantrySubtitle;

  /// No description provided for @homeCuisinesTitle.
  ///
  /// In en, this message translates to:
  /// **'From your favorite cuisines'**
  String get homeCuisinesTitle;

  /// No description provided for @weatherRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy weather — warm soups & curries'**
  String get weatherRainy;

  /// No description provided for @weatherCold.
  ///
  /// In en, this message translates to:
  /// **'Cold day — hearty, warming meals'**
  String get weatherCold;

  /// No description provided for @weatherHot.
  ///
  /// In en, this message translates to:
  /// **'Hot day — fresh salads & light bites'**
  String get weatherHot;

  /// No description provided for @weatherPleasant.
  ///
  /// In en, this message translates to:
  /// **'Pleasant weather — anything goes'**
  String get weatherPleasant;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get searchHint;

  /// No description provided for @searchEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search by name or pick a category'**
  String get searchEmpty;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get searchNoResults;

  /// No description provided for @detailIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get detailIngredients;

  /// No description provided for @detailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get detailInstructions;

  /// No description provided for @detailStartCooking.
  ///
  /// In en, this message translates to:
  /// **'Start cooking'**
  String get detailStartCooking;

  /// No description provided for @detailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get detailNotFound;

  /// No description provided for @cookStepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String cookStepCounter(int current, int total);

  /// No description provided for @cookNoSteps.
  ///
  /// In en, this message translates to:
  /// **'No steps available'**
  String get cookNoSteps;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved recipes yet'**
  String get favoritesEmpty;

  /// No description provided for @favoritesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon on any recipe to save it for later.'**
  String get favoritesEmptyHint;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get profileTitle;

  /// No description provided for @profileGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, Chef'**
  String get profileGreeting;

  /// No description provided for @profileMetaLine.
  ///
  /// In en, this message translates to:
  /// **'{diet} · {skill}'**
  String profileMetaLine(String diet, String skill);

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profilePreferencesSub.
  ///
  /// In en, this message translates to:
  /// **'Diet, allergies, cuisines, pantry'**
  String get profilePreferencesSub;

  /// No description provided for @profilePantry.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get profilePantry;

  /// No description provided for @profilePantryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get profilePantryEmpty;

  /// No description provided for @profilePantryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String profilePantryCount(int count);

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You are offline · showing saved & cached recipes'**
  String get offlineBanner;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorGeneric;

  /// No description provided for @errorNoNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get errorNoNetwork;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
