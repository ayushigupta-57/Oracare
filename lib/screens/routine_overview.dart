import 'package:flutter/material.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'routine_screens.dart';

class RoutineOverviewScreen extends StatefulWidget {
  const RoutineOverviewScreen({super.key});
  @override
  State<RoutineOverviewScreen> createState() => _S();
}

class _S extends State<RoutineOverviewScreen> {
  int seg = DateTime.now().hour >= 16 ? 1 : 0; // evening after 4pm

  @override
  Widget build(BuildContext context) {
    final session = seg == 0 ? Session.morning : Session.evening;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(T.s16, T.s16, T.s16, 120),
        children: [
          Text('Daily Routine', style: ts(28, w: FontWeight.w500)),
          const SizedBox(height: T.s4),
          Text('Follow the clinical sequence recommended for you, for a healthier smile.', style: ts(16, c: T.text2)),
          const SizedBox(height: T.s20),
          Segmented(labels: const ['Morning', 'Evening'], index: seg, onChanged: (i) => setState(() => seg = i)),
          const SizedBox(height: T.s24),
          Text('Guided Steps', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s12),
          for (var i = 0; i < kSteps.length; i++) ...[
            OCard(
              padding: const EdgeInsets.symmetric(horizontal: T.s16, vertical: T.s12),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: T.container, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${i + 1}', style: ts(16, w: FontWeight.w500, c: T.onContainer)),
                ),
                const SizedBox(width: T.s12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(kSteps[i].name, style: ts(16, w: FontWeight.w500)),
                    Text(kSteps[i].label, style: ts(14, c: T.text2)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: T.s8),
          ],
          const SizedBox(height: T.s8),
          Text('Completing this routine will earn you ${AppState.checkInHp} Health Points!',
              style: ts(14, c: T.text2)),
          const SizedBox(height: T.s16),
          PrimaryButton('Start Routine', icon: Icons.play_arrow, onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoutineStepsScreen(session: session)));
          }),
        ],
      ),
    );
  }
}
