import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/features/exercises/application/exercise_providers.dart';
import 'package:homefit/features/exercises/data/exercise_catalog.dart';
import 'package:homefit/features/exercises/domain/exercise.dart';
import 'package:homefit/features/exercises/domain/exercise_query.dart';
import 'package:homefit/features/exercises/presentation/exercise_detail_screen.dart';
import 'package:homefit/features/profile/application/profile_providers.dart';
import 'package:homefit/features/profile/domain/profile_options.dart';
import 'package:homefit/features/profile/domain/user_profile.dart';

import '../../fixtures/profile_fixtures.dart';

Exercise byId(String id) =>
    exerciseCatalog.firstWhere((Exercise exercise) => exercise.id == id);

/// A tall surface renders the whole detail page, so assertions do not depend
/// on which section happens to be in the viewport.
Future<ProviderContainer> pumpDetail(
  WidgetTester tester,
  String exerciseId, {
  UserProfile? profile,
}) async {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final ProviderContainer container = ProviderContainer(
    overrides: [
      initialProfileProvider.overrideWithValue(profile ?? buildTestProfile()),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: ExerciseDetailScreen(exerciseId: exerciseId)),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('shows muscles, difficulty, steps and form cues', (tester) async {
    final Exercise exercise = byId('band-row');
    await pumpDetail(
      tester,
      'band-row',
      profile: buildTestProfile().copyWith(
        equipment: <EquipmentItem>{
          EquipmentItem.bodyweight,
          EquipmentItem.resistanceBand,
        },
      ),
    );

    expect(find.text(exercise.primaryMuscle.label), findsWidgets);
    expect(find.text(exercise.difficulty.label), findsWidgets);
    expect(find.text('Secondary muscles'), findsOneWidget);
    expect(find.text('Step by step'), findsOneWidget);
    for (final String step in exercise.steps) {
      expect(find.text(step), findsOneWidget);
    }
    expect(find.text('Form and safety'), findsOneWidget);
    for (final String cue in exercise.formCues) {
      expect(find.text(cue), findsOneWidget);
    }
  });

  testWidgets('states when the saved equipment is enough', (tester) async {
    await pumpDetail(
      tester,
      'band-row',
      profile: buildTestProfile().copyWith(
        equipment: <EquipmentItem>{
          EquipmentItem.bodyweight,
          EquipmentItem.resistanceBand,
        },
      ),
    );
    expect(find.text('Ready with your equipment'), findsOneWidget);
    expect(find.text('Needs additional equipment'), findsNothing);
  });

  testWidgets('names the missing equipment instead of hiding the movement', (
    tester,
  ) async {
    await pumpDetail(tester, 'pull-up');
    expect(find.text('Needs additional equipment'), findsOneWidget);
    expect(find.textContaining('Pull-up bar'), findsWidgets);
  });

  testWidgets('alternatives are ranked and marked when equipment is missing', (
    tester,
  ) async {
    final ProviderContainer container = await pumpDetail(tester, 'pull-up');
    final List<ExerciseAlternative> alternatives = container.read(
      exerciseAlternativesProvider('pull-up'),
    );

    expect(alternatives, isNotEmpty);
    expect(
      alternatives.every(
        (ExerciseAlternative entry) => entry.exercise.id != 'pull-up',
      ),
      isTrue,
    );
    expect(
      alternatives.any((ExerciseAlternative entry) => !entry.equipmentReady),
      isTrue,
      reason: 'a profile with no equipment cannot perform every alternative',
    );
    expect(find.text('Needs Resistance band'), findsWidgets);
    expect(
      find.byKey(Key('alternative_${alternatives.first.exercise.id}')),
      findsOneWidget,
    );
  });

  testWidgets('shows the profile experience used for ranking', (tester) async {
    await pumpDetail(
      tester,
      'push-up',
      profile: buildTestProfile().copyWith(
        experience: ExperienceLevel.intermediate,
      ),
    );
    expect(find.text('Your experience'), findsOneWidget);
    expect(find.text('Intermediate'), findsWidgets);
  });

  testWidgets('an unknown id explains itself instead of crashing', (
    tester,
  ) async {
    await pumpDetail(tester, 'not-a-real-exercise');
    expect(find.text('Exercise not found'), findsOneWidget);
    expect(find.text('Back to library'), findsOneWidget);
    expect(find.text('Step by step'), findsNothing);
  });
}
