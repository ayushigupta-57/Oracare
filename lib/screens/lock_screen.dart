import 'package:flutter/material.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'routine_screens.dart';
import 'shell.dart';

/// Simulates the phone lock screen with the morning reminder notification.
/// (Real scheduled notifications are a later step - see README.)
class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  void _open(BuildContext c, {int tab = 0, bool startRoutine = false}) {
    final nav = Navigator.of(c);
    nav.pushReplacement(MaterialPageRoute(builder: (_) => Shell(initialTab: tab)));
    if (startRoutine) {
      nav.push(MaterialPageRoute(builder: (_) => const RoutineStepsScreen(session: Session.morning)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < -200) _open(context);
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B3B36), Color(0xFF00897B)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: T.s16),
              child: Column(children: [
                const SizedBox(height: 56),
                Text('7:00', style: ts(96, w: FontWeight.w300, c: Colors.white, h: 1.0)),
                const SizedBox(height: T.s8),
                Text('Tuesday, 29 September', style: ts(18, c: Colors.white)),
                const SizedBox(height: 56),
                Container(
                  padding: const EdgeInsets.all(T.s16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(T.r28),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(color: T.btn, borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.favorite_border, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: T.s8),
                      Text('Oracare · now', style: ts(12, c: T.text2)),
                    ]),
                    const SizedBox(height: T.s12),
                    Text('Time for your morning routine 🪥', style: ts(16, w: FontWeight.w500)),
                    const SizedBox(height: T.s4),
                    Text('6 guided steps · about 8 minutes · earn 20 HP', style: ts(14, c: T.text2)),
                    const SizedBox(height: T.s16),
                    Row(children: [
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: T.btn, minimumSize: const Size(0, 48)),
                          onPressed: () => _open(context, tab: 1, startRoutine: true),
                          child: Text('I brushed ✓', style: ts(14, w: FontWeight.w500, c: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: T.s12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: T.btn), minimumSize: const Size(0, 48)),
                          onPressed: () => toast(context, 'We will remind you in 15 min'),
                          child: Text('Remind me in 15 min', style: ts(12, w: FontWeight.w500, c: T.btn)),
                        ),
                      ),
                    ]),
                  ]),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _open(context),
                  child: Padding(
                    padding: const EdgeInsets.all(T.s24),
                    child: Text('Swipe up to open', style: ts(14, c: Colors.white)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
