import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/milestone_notice.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach')),
      body: ListView(
        padding: kPagePadding,
        children: const [
          MilestoneNotice(
            icon: Icons.psychology,
            title: 'Coaching arrives in M6',
            body:
                'Daily guidance, Restart Mode, anti-procrastination and reminder '
                'settings are not built yet. Your reminder preference is saved, '
                'but no notification can be scheduled in this build.',
            planned: [
              'Reminder scheduling with quiet hours and caps',
              'Restart Mode after a break, without guilt',
              'Coaching style preference and honest daily guidance',
            ],
          ),
        ],
      ),
    );
  }
}
