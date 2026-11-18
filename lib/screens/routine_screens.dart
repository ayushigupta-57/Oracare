import 'dart:async';
import 'package:flutter/material.dart';
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

/// Set > 1 to speed the timers up while testing (e.g. 10 = 10x faster).
const double kTimerSpeed = 1;

class RoutineStepsScreen extends StatefulWidget {
  final Session session;
  const RoutineStepsScreen({super.key, required this.session});
  @override
  State<RoutineStepsScreen> createState() => _StepsState();
}

class _StepsState extends State<RoutineStepsScreen> {
  int i = 0;
  late double left = kSteps[0].seconds.toDouble();
  Timer? _t;
  bool paused = false;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (paused) return;
      setState(() => left = (left - 0.25 * kTimerSpeed).clamp(0, 9999));
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _restart() {
    setState(() => left = kSteps[i].seconds.toDouble());
    toast(context, 'RoutineStep restarted');
  }

  void _next() {
    if (i == kSteps.length - 1) {
      appState.completeRoutine(widget.session); // only here: full routine finished
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RoutineCompleteScreen(session: widget.session, justRecorded: true)));
      return;
    }
    setState(() {
      i++;
      left = kSteps[i].seconds.toDouble();
    });
  }

  String _fmt(double s) {
    final v = s.ceil();
    return '${(v ~/ 60).toString().padLeft(2, '0')}:${(v % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final step = kSteps[i];
    final morning = widget.session == Session.morning;
    final frac = 1 - left / step.seconds;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: T.bg,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text('Routine'),
        centerTitle: true,
        titleTextStyle: ts(22, w: FontWeight.w500),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(T.s16, T.s8, T.s16, T.s24),
        children: [
          Text('${morning ? 'Morning' : 'Evening'} Routine', style: ts(28, w: FontWeight.w500)),
          const SizedBox(height: T.s4),
          Text('Complete the routine to earn Health Points', style: ts(16, c: T.text2)),
          const SizedBox(height: T.s16),
          Row(children: [
            for (var k = 0; k < kSteps.length; k++)
              Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: k == kSteps.length - 1 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: k <= i ? T.btn : T.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: T.s8),
          Text('RoutineStep ${i + 1} of ${kSteps.length} · ${step.name}', style: ts(14, w: FontWeight.w500, c: T.onContainer)),
          const SizedBox(height: T.s16),
          OCard(
            color: T.container,
            child: Column(children: [
              SizedBox(
                width: 168,
                height: 168,
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: frac.clamp(0.0, 1.0),
                      strokeWidth: 10,
                      backgroundColor: Colors.white,
                      color: T.primary,
                    ),
                  ),
                  Text(_fmt(left), style: ts(36, w: FontWeight.w500, c: T.onContainer)),
                ]),
              ),
              const SizedBox(height: T.s16),
              Text(step.name, style: ts(22, w: FontWeight.w500)),
            ]),
          ),
          const SizedBox(height: T.s16),
          OCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Current Technique', style: ts(16, w: FontWeight.w500)),
              const SizedBox(height: T.s4),
              Text(step.technique, style: ts(14, c: T.text2)),
            ]),
          ),
          const SizedBox(height: T.s16),
          Row(children: [
            Expanded(child: SecondaryButton('Restart', icon: Icons.replay, onPressed: _restart)),
            const SizedBox(width: T.s12),
            Expanded(
              child: SecondaryButton(paused ? 'Resume' : 'Pause',
                  icon: paused ? Icons.play_arrow : Icons.pause, onPressed: () => setState(() => paused = !paused)),
            ),
          ]),
          const SizedBox(height: T.s12),
          PrimaryButton(i == kSteps.length - 1 ? 'Finish routine' : 'Next step',
              icon: i == kSteps.length - 1 ? Icons.check : Icons.arrow_forward, onPressed: _next),
          const SizedBox(height: T.s24),
          const WeeklyOverview(),
          const SizedBox(height: T.s16),
          const SavingsCard(),
        ],
      ),
    );
  }
}

class RoutineCompleteScreen extends StatefulWidget {
  final Session session;
  final bool justRecorded;
  const RoutineCompleteScreen({super.key, required this.session, this.justRecorded = false});
  @override
  State<RoutineCompleteScreen> createState() => _CompleteState();
}

class _CompleteState extends State<RoutineCompleteScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.justRecorded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final s = widget.session == Session.morning ? 'Morning' : 'Evening';
          toast(context, '$s check-in recorded · +${AppState.checkInHp} Health Points');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final morning = widget.session == Session.morning;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(T.s16),
          children: [
            const SizedBox(height: T.s32),
            const Center(
              child: CircleAvatar(radius: 40, backgroundColor: T.btn, child: Icon(Icons.check, size: 44, color: Colors.white)),
            ),
            const SizedBox(height: T.s24),
            Text('${morning ? 'Morning' : 'Evening'} routine done ✓',
                textAlign: TextAlign.center, style: ts(28, w: FontWeight.w500)),
            const SizedBox(height: T.s8),
            Text(
                'Check-in recorded · +${AppState.checkInHp} HP. See you this ${morning ? 'evening at 9:00 PM' : 'morning at 7:00 AM'}.',
                textAlign: TextAlign.center,
                style: ts(16, c: T.text2)),
            const SizedBox(height: T.s24),
            const WeeklyOverview(),
            const SizedBox(height: T.s16),
            const SavingsCard(),
            const SizedBox(height: T.s24),
            PrimaryButton('Back to Home', onPressed: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
            }),
          ],
        ),
      ),
    );
  }
}
