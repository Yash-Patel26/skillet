// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

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
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Listo';

  @override
  String get previous => 'Anterior';

  @override
  String get cancel => 'Cancelar';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get languageStepTitle => 'Elige tu idioma';

  @override
  String get languageStepSubtitle => 'Puedes cambiarlo más tarde en tu perfil.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get onboardOneTitle => 'Cocina con el momento';

  @override
  String get onboardOneBody =>
      'Skillet sugiere recetas según la hora del día, el clima y lo que tienes a mano.';

  @override
  String get onboardTwoTitle => 'Usa lo que tienes';

  @override
  String get onboardTwoBody =>
      'Cuéntanos qué hay en tu despensa. Te sugeriremos recetas que puedes preparar ahora mismo.';

  @override
  String get onboardThreeTitle => 'Guarda y cocina';

  @override
  String get onboardThreeBody =>
      'Marca recetas para más tarde y sigue el modo cocción paso a paso con la pantalla siempre encendida.';

  @override
  String get onboardCta => 'Configurar mis preferencias';

  @override
  String get prefsTitleInitial => 'Cuéntanos sobre ti';

  @override
  String get prefsTitle => 'Preferencias';

  @override
  String get prefsDiet => 'Dieta';

  @override
  String get prefsSkill => 'Nivel de cocina';

  @override
  String get prefsAllergies => 'Alergias y evitar';

  @override
  String get prefsCuisines => 'Cocinas favoritas';

  @override
  String get prefsPantryTitle => '¿Qué hay en tu despensa?';

  @override
  String get prefsPantrySubtitle =>
      'Sugeriremos recetas que puedas preparar con estos ingredientes.';

  @override
  String get prefsPantryHint => 'p. ej. pollo, tomate';

  @override
  String get prefsStartCooking => 'Empezar a cocinar';

  @override
  String get dietAny => 'Cualquier cosa';

  @override
  String get dietVegetarian => 'Vegetariano';

  @override
  String get dietVegan => 'Vegano';

  @override
  String get dietNonVeg => 'Con carne';

  @override
  String get skillBeginner => 'Principiante';

  @override
  String get skillIntermediate => 'Intermedio';

  @override
  String get skillPro => 'Experto';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingSnack => '¿Hora del aperitivo?';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get greetingLateNight => '¿Antojo nocturno?';

  @override
  String get dayPartBreakfast => 'Desayuno';

  @override
  String get dayPartLunch => 'Almuerzo';

  @override
  String get dayPartSnack => 'Aperitivo';

  @override
  String get dayPartDinner => 'Cena';

  @override
  String get dayPartLateNight => 'Tarde noche';

  @override
  String get homeFeaturedTag => 'PRUEBA HOY';

  @override
  String homeDayPartIdeasTitle(String label) {
    return 'Ideas para $label';
  }

  @override
  String get homeDayPartIdeasSubtitle => 'Elegidas según la hora';

  @override
  String homeRegionTitle(String country) {
    return 'Popular en $country';
  }

  @override
  String homeRegionSubtitle(String cuisine) {
    return 'Cocina $cuisine, cerca de ti';
  }

  @override
  String get homeWeatherTitle => 'Según el clima';

  @override
  String get homePantryTitle => 'Usa lo que tienes';

  @override
  String get homePantrySubtitle => 'De tu despensa';

  @override
  String get homeCuisinesTitle => 'De tus cocinas favoritas';

  @override
  String get weatherRainy => 'Día lluvioso — sopas y curris calientes';

  @override
  String get weatherCold => 'Día frío — comidas calientes y reconfortantes';

  @override
  String get weatherHot => 'Día caluroso — ensaladas frescas y bocados ligeros';

  @override
  String get weatherPleasant => 'Clima agradable — todo va bien';

  @override
  String get navHome => 'Inicio';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSaved => 'Guardados';

  @override
  String get navMe => 'Yo';

  @override
  String get searchHint => 'Buscar recetas';

  @override
  String get searchEmpty => 'Busca por nombre o elige una categoría';

  @override
  String get searchNoResults => 'No se encontraron recetas';

  @override
  String get detailIngredients => 'Ingredientes';

  @override
  String get detailInstructions => 'Instrucciones';

  @override
  String get detailStartCooking => 'Empezar a cocinar';

  @override
  String get detailNotFound => 'Receta no encontrada';

  @override
  String cookStepCounter(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get cookNoSteps => 'Sin pasos disponibles';

  @override
  String get favoritesTitle => 'Guardados';

  @override
  String get favoritesEmpty => 'Aún no hay recetas guardadas';

  @override
  String get favoritesEmptyHint =>
      'Toca el icono de marcador en cualquier receta para guardarla.';

  @override
  String get profileTitle => 'Yo';

  @override
  String get profileGreeting => 'Hola, Chef';

  @override
  String profileMetaLine(String diet, String skill) {
    return '$diet · $skill';
  }

  @override
  String get profilePreferences => 'Preferencias';

  @override
  String get profilePreferencesSub => 'Dieta, alergias, cocinas, despensa';

  @override
  String get profilePantry => 'Despensa';

  @override
  String get profilePantryEmpty => 'Aún sin elementos';

  @override
  String profilePantryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get offlineBanner =>
      'Estás sin conexión · mostrando recetas guardadas y en caché';

  @override
  String get errorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get errorNoNetwork => 'Error de red. Comprueba tu conexión.';
}
