import '../domain/exercise.dart';
import 'catalog/arms.dart';
import 'catalog/back.dart';
import 'catalog/chest.dart';
import 'catalog/core.dart';
import 'catalog/full_body.dart';
import 'catalog/legs.dart';
import 'catalog/shoulders.dart';

/// The offline library, bundled with the app.
///
/// Data lives in [catalog] files grouped by primary muscle so new movements
/// are added by appending to one small file. Everything is `const`, so the
/// library is available on the first frame with no asset loading, cache or
/// network call.
final List<Exercise> exerciseCatalog = List<Exercise>.unmodifiable(<Exercise>[
  ...chestExercises,
  ...backExercises,
  ...shoulderExercises,
  ...armExercises,
  ...legExercises,
  ...coreExercises,
  ...fullBodyExercises,
]);
