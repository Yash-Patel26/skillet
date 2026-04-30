enum DietPref { any, vegetarian, vegan, nonVeg }
enum SkillLevel { beginner, intermediate, pro }

extension DietPrefX on DietPref {
  String get storageKey => name;

  static DietPref fromKey(String? key) {
    return DietPref.values.firstWhere(
      (e) => e.name == key,
      orElse: () => DietPref.any,
    );
  }
}

extension SkillLevelX on SkillLevel {
  static SkillLevel fromKey(String? key) {
    return SkillLevel.values.firstWhere(
      (e) => e.name == key,
      orElse: () => SkillLevel.beginner,
    );
  }
}

class UserPrefs {
  final DietPref diet;
  final List<String> allergies;
  final List<String> cuisines;
  final SkillLevel skill;
  final List<String> pantry;

  const UserPrefs({
    this.diet = DietPref.any,
    this.allergies = const [],
    this.cuisines = const [],
    this.skill = SkillLevel.beginner,
    this.pantry = const [],
  });

  UserPrefs copyWith({
    DietPref? diet,
    List<String>? allergies,
    List<String>? cuisines,
    SkillLevel? skill,
    List<String>? pantry,
  }) =>
      UserPrefs(
        diet: diet ?? this.diet,
        allergies: allergies ?? this.allergies,
        cuisines: cuisines ?? this.cuisines,
        skill: skill ?? this.skill,
        pantry: pantry ?? this.pantry,
      );
}
