import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/milestone_notice.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: ListView(
        padding: kPagePadding,
        children: const [
          MilestoneNotice(
            icon: Icons.restaurant,
            title: 'Nutrition arrives in M5',
            body:
                'No food database, meal plan or logging exists in this build yet. '
                'Your vegetarian, no-egg preference is saved in your profile and '
                'will be enforced once meals exist.',
            planned: [
              'Affordable Indian vegetarian food data with sources',
              'Meal planner with portions, swap and mark-eaten',
              'Portion or gram logging and an ingredient-based pantry',
            ],
          ),
        ],
      ),
    );
  }
}
