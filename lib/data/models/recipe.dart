class Ingredient {
  final String name;
  final String measure;
  const Ingredient({required this.name, required this.measure});

  Map<String, dynamic> toMap() => {'name': name, 'measure': measure};
  factory Ingredient.fromMap(Map<String, dynamic> m) =>
      Ingredient(name: m['name'] ?? '', measure: m['measure'] ?? '');
}

class Recipe {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? thumbnail;
  final String? instructions;
  final List<Ingredient> ingredients;
  final List<String> tags;
  final String? youtubeUrl;
  final String? sourceUrl;

  const Recipe({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.thumbnail,
    this.instructions,
    this.ingredients = const [],
    this.tags = const [],
    this.youtubeUrl,
    this.sourceUrl,
  });

  factory Recipe.fromMealDbLite(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString(),
    );
  }

  factory Recipe.fromMealDbFull(Map<String, dynamic> json) {
    final ings = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final ing = (json['strIngredient$i'] ?? '').toString().trim();
      final mes = (json['strMeasure$i'] ?? '').toString().trim();
      if (ing.isNotEmpty) {
        ings.add(Ingredient(name: ing, measure: mes));
      }
    }
    final tagsRaw = (json['strTags'] ?? '').toString();
    final tags = tagsRaw.isEmpty
        ? <String>[]
        : tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return Recipe(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString(),
      area: json['strArea']?.toString(),
      thumbnail: json['strMealThumb']?.toString(),
      instructions: json['strInstructions']?.toString(),
      ingredients: ings,
      tags: tags,
      youtubeUrl: json['strYoutube']?.toString(),
      sourceUrl: json['strSource']?.toString(),
    );
  }

  List<String> instructionSteps() {
    if (instructions == null || instructions!.trim().isEmpty) return const [];
    final raw = instructions!
        .replaceAll('\r\n', '\n')
        .replaceAll(RegExp(r'STEP\s*\d+\s*[:\.]?', caseSensitive: false), '\n');
    final parts = raw.split(RegExp(r'\n+|(?<=\.)\s+(?=[A-Z])'));
    return parts.map((s) => s.trim()).where((s) => s.length > 4).toList();
  }
}
