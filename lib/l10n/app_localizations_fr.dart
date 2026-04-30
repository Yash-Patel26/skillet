// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

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
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get previous => 'Précédent';

  @override
  String get cancel => 'Annuler';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get languageStepTitle => 'Choisissez votre langue';

  @override
  String get languageStepSubtitle =>
      'Vous pourrez la modifier plus tard dans votre profil.';

  @override
  String get continueAction => 'Continuer';

  @override
  String get onboardOneTitle => 'Cuisinez avec le moment';

  @override
  String get onboardOneBody =>
      'Skillet propose des recettes selon l\'heure, la météo et ce que vous avez à portée de main.';

  @override
  String get onboardTwoTitle => 'Utilisez ce que vous avez';

  @override
  String get onboardTwoBody =>
      'Indiquez ce qu\'il y a dans votre garde-manger. Nous suggérerons des recettes réalisables tout de suite.';

  @override
  String get onboardThreeTitle => 'Enregistrez et cuisinez';

  @override
  String get onboardThreeBody =>
      'Mettez des recettes en favori et suivez le mode cuisson étape par étape, écran toujours allumé.';

  @override
  String get onboardCta => 'Définir mes préférences';

  @override
  String get prefsTitleInitial => 'Parlez-nous de vous';

  @override
  String get prefsTitle => 'Préférences';

  @override
  String get prefsDiet => 'Régime';

  @override
  String get prefsSkill => 'Niveau de cuisine';

  @override
  String get prefsAllergies => 'Allergies et à éviter';

  @override
  String get prefsCuisines => 'Cuisines préférées';

  @override
  String get prefsPantryTitle => 'Que contient votre garde-manger ?';

  @override
  String get prefsPantrySubtitle =>
      'Nous suggérerons des recettes faisables avec ces ingrédients.';

  @override
  String get prefsPantryHint => 'ex. poulet, tomate';

  @override
  String get prefsStartCooking => 'Commencer à cuisiner';

  @override
  String get dietAny => 'Tout';

  @override
  String get dietVegetarian => 'Végétarien';

  @override
  String get dietVegan => 'Végan';

  @override
  String get dietNonVeg => 'Non végétarien';

  @override
  String get skillBeginner => 'Débutant';

  @override
  String get skillIntermediate => 'Intermédiaire';

  @override
  String get skillPro => 'Confirmé';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingSnack => 'Une petite faim ?';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get greetingLateNight => 'Petit creux nocturne ?';

  @override
  String get dayPartBreakfast => 'Petit-déjeuner';

  @override
  String get dayPartLunch => 'Déjeuner';

  @override
  String get dayPartSnack => 'Goûter';

  @override
  String get dayPartDinner => 'Dîner';

  @override
  String get dayPartLateNight => 'Tard le soir';

  @override
  String get homeFeaturedTag => 'À ESSAYER';

  @override
  String homeDayPartIdeasTitle(String label) {
    return 'Idées pour $label';
  }

  @override
  String get homeDayPartIdeasSubtitle => 'Choisies selon l\'heure';

  @override
  String homeRegionTitle(String country) {
    return 'Tendance en $country';
  }

  @override
  String homeRegionSubtitle(String cuisine) {
    return 'Cuisine $cuisine, près de vous';
  }

  @override
  String get homeWeatherTitle => 'Selon la météo';

  @override
  String get homePantryTitle => 'Avec ce que vous avez';

  @override
  String get homePantrySubtitle => 'Depuis votre garde-manger';

  @override
  String get homeCuisinesTitle => 'Vos cuisines préférées';

  @override
  String get weatherRainy => 'Journée pluvieuse — soupes et currys chauds';

  @override
  String get weatherCold => 'Journée froide — plats chauds et nourrissants';

  @override
  String get weatherHot =>
      'Journée chaude — salades fraîches et bouchées légères';

  @override
  String get weatherPleasant => 'Temps agréable — tout convient';

  @override
  String get navHome => 'Accueil';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navSaved => 'Favoris';

  @override
  String get navMe => 'Moi';

  @override
  String get searchHint => 'Rechercher des recettes';

  @override
  String get searchEmpty => 'Cherchez par nom ou choisissez une catégorie';

  @override
  String get searchNoResults => 'Aucune recette trouvée';

  @override
  String get detailIngredients => 'Ingrédients';

  @override
  String get detailInstructions => 'Instructions';

  @override
  String get detailStartCooking => 'Commencer à cuisiner';

  @override
  String get detailNotFound => 'Recette introuvable';

  @override
  String cookStepCounter(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String get cookNoSteps => 'Aucune étape disponible';

  @override
  String get favoritesTitle => 'Favoris';

  @override
  String get favoritesEmpty => 'Aucune recette enregistrée';

  @override
  String get favoritesEmptyHint =>
      'Touchez l\'icône signet sur une recette pour la garder.';

  @override
  String get profileTitle => 'Moi';

  @override
  String get profileGreeting => 'Bonjour, Chef';

  @override
  String profileMetaLine(String diet, String skill) {
    return '$diet · $skill';
  }

  @override
  String get profilePreferences => 'Préférences';

  @override
  String get profilePreferencesSub =>
      'Régime, allergies, cuisines, garde-manger';

  @override
  String get profilePantry => 'Garde-manger';

  @override
  String get profilePantryEmpty => 'Aucun élément';

  @override
  String profilePantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileAppearance => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get offlineBanner =>
      'Vous êtes hors ligne · recettes enregistrées et en cache affichées';

  @override
  String get errorGeneric => 'Une erreur est survenue. Réessayez.';

  @override
  String get errorNoNetwork => 'Erreur réseau. Vérifiez votre connexion.';
}
