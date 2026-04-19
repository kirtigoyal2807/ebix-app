/// Values sent to `POST /auth/goal` — independent of UI locale.
abstract final class PostLoginExperienceApi {
  static const beginner = 'beginner';
  static const intermediate = 'intermediate';
  static const advanced = 'advanced';
}

/// English `goal` strings (match product options; server stores as sent).
abstract final class PostLoginGoalApi {
  static const buildStrength = 'Build Strength';
  static const findMindfulness = 'Find Mindfulness';
  static const improveFlexibility = 'Improve Flexibility';
  static const generalFitness = 'General Fitness';

  static const List<String> ordered = [
    buildStrength,
    findMindfulness,
    improveFlexibility,
    generalFitness,
  ];
}
