import '../domain/exercise.dart';
import 'exercise_catalog.dart';

/// Read access to the exercise library.
///
/// An interface keeps the presentation layer independent of where the data
/// comes from, so a future downloadable library can replace the bundled one
/// without touching screens or providers.
abstract interface class ExerciseRepository {
  /// Every exercise, in catalogue order.
  List<Exercise> all();

  /// The exercise with [id], or null when it does not exist.
  Exercise? byId(String id);
}

/// Serves the catalogue compiled into the app. Fully offline.
class BundledExerciseRepository implements ExerciseRepository {
  BundledExerciseRepository({List<Exercise>? exercises})
    : _exercises = List<Exercise>.unmodifiable(exercises ?? exerciseCatalog),
      _byId = <String, Exercise>{
        for (final Exercise exercise in exercises ?? exerciseCatalog)
          exercise.id: exercise,
      };

  final List<Exercise> _exercises;
  final Map<String, Exercise> _byId;

  @override
  List<Exercise> all() => _exercises;

  @override
  Exercise? byId(String id) => _byId[id];
}
