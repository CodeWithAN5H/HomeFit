import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../shared/widgets/milestone_notice.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: kPagePadding,
        children: const [
          MilestoneNotice(
            icon: Icons.insights,
            title: 'Progress tracking arrives in M7',
            body:
                'Weight entries, measurements, private photos and the Body Goal '
                'Timeline are not implemented yet. Nothing is being tracked or '
                'estimated in this build.',
            planned: [
              'Weekly weight and monthly measurements',
              'Local-only progress photos with explicit consent',
              'Weekly reports and a conservative Body Goal Timeline',
            ],
          ),
        ],
      ),
    );
  }
}
