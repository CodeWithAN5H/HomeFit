import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homefit/core/theme/app_tokens.dart';
import 'package:homefit/shared/widgets/selectable_chip.dart';

/// Regression tests for the chip's text layout.
///
/// A real device (iQOO Z3, 393 dp wide) overflowed the sleep option chips,
/// because the label was laid out in a `Row` with no flexible child. These
/// tests fail if a long label is ever painted outside its chip again.
void main() {
  Widget harness(Widget child, {double width = 320}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: width, child: child),
        ),
      ),
    );
  }

  testWidgets('long labels wrap inside a full-width chip', (tester) async {
    await tester.pumpWidget(
      harness(
        SelectableChip(
          label:
              'Fairly regular — About the same bedtime most nights '
              'and reasonably close to seven hours',
          selected: true,
          onTap: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('chips inside a Wrap do not overflow', (tester) async {
    await tester.pumpWidget(
      harness(
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final String label in <String>[
              'Build muscle',
              'Gain weight healthily',
              'Calisthenics skills',
              'Sturdy chair / table',
            ])
              SelectableChip(label: label, selected: false, onTap: () {}),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('tap reports selection changes', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      harness(
        SelectableChip(
          label: 'Evening',
          selected: false,
          onTap: () => taps += 1,
        ),
      ),
    );

    await tester.tap(find.byType(SelectableChip));
    await tester.pump();

    expect(taps, 1);
  });
}
