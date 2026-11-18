import 'package:flutter/material.dart';
import '../icons.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';

class RoutineStep {
  final String name;
  final int seconds;
  final String technique;
  const RoutineStep(this.name, this.seconds, this.technique);
  String get label => seconds >= 60 ? '${seconds ~/ 60} Minute${seconds ~/ 60 > 1 ? 's' : ''}' : '$seconds Seconds';
}

const kSteps = <RoutineStep>[
  RoutineStep('Rinse', 30, 'Swish water around your whole mouth.'),
  RoutineStep('Brush Upper Teeth', 120, 'Small circular motions, 45-degree angle.'),
  RoutineStep('Brush Lower Teeth', 120, 'Small circular motions, 45-degree angle.'),
  RoutineStep('Tongue Cleaning', 30, 'Scrape gently from back to front, 5–6 times.'),
  RoutineStep('Flossing', 60, 'Slide floss gently between teeth in a C shape.'),
  RoutineStep('Mouthwash', 60, 'Swish for the full time, then spit. Do not rinse.'),
];

class RoutineStepsScreen extends StatefulWidget {
  final Session session;
  final VoidCallback onDone;
  const RoutineStepsScreen({super.key, required this.session, required this.onDone});
  @override
  State<RoutineStepsScreen> createState() => _StepsState();
}

class _StepsState extends State<RoutineStepsScreen> {
  int i = 0;

  void _next() {
    if (i < kSteps.length - 1) {
      setState(() => i++);
    } else {
      appState.completeRoutine(widget.session);
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = kSteps[i];
    final last = i == kSteps.length - 1;
    final title = widget.session == Session.morning ? 'Morning Routine' : 'Evening Routine';
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) => Body([
        PageTitle(title, sub: 'Complete the routine to earn Health Points'),
        const SizedBox(height: 16),
        // hero card
        Container(
          height: 186,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: T.text,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: T.border, width: 0.8),
          ),
          child: Stack(fit: StackFit.expand, children: [
            Opacity(
              opacity: 0.75,
              child: Image.asset('assets/images/hero.png', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2F6F68), Color(0xFF1C2F3F)])),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Ic(glyphPlay('#006B60', '#E0F2F1'), w: 48, h: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Pill(s.label, fg: T.primary, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      const SizedBox(height: 8),
                      Text('Step ${i + 1}- ${s.name}', style: ts(18, w: kSemi, c: Colors.white, lh: 24)),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        OCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Tile(glyphTick),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Current Technique', style: ts(18, w: kSemi, lh: 24)),
                  Text(s.technique, style: ts(16, c: T.text2, lh: 24)),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: PillButton('Replay', icon: replaySvg, onTap: () {})),
              const SizedBox(width: 16),
              Expanded(child: PillButton(last ? 'Finish Routine' : 'Skip Step', icon: last ? null : skipSvg, onTap: _next)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        WeeklyOverview(earnedHp: 75 + (appState.dayComplete(DateTime.now()) ? AppState.checkInHp : 0)),
      ]),
    );
  }
}

class RoutineCompleteScreen extends StatelessWidget {
  final Session session;
  const RoutineCompleteScreen({super.key, required this.session});
  @override
  Widget build(BuildContext context) {
    final name = session == Session.morning ? 'Morning' : 'Evening';
    final next = session == Session.morning ? 'this evening at 9:00 PM' : 'tomorrow morning at 7:00 AM';
    return Body([
      PageTitle('$name routine done ✓', sub: 'Check-in recorded · +${AppState.checkInHp} HP. See you $next.'),
      const SizedBox(height: 16),
      const WeeklyOverview(earnedHp: 95),
    ]);
  }
}
