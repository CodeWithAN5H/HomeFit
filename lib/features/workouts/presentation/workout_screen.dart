import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/milestone_notice.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: ListView(
        padding: kPagePadding,
        children: const [
          MilestoneNotice(
            icon: Icons.fitness_center,
            title: 'Training arrives in M4',
            body:
                'This build stores your profile and preferences only. It has no '
                'exercise library, plan generator or session runner yet, so there '
                'is nothing here to start.',
            planned: [
              'Full-body beginner plan built from your profile',
              'Quick, recovery, targeted and skill sessions',
              'Recorded reps, rest timer and honest progression',
            ],
          ),
        ],
      ),
    );
  }
}
