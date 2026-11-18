import 'package:flutter/material.dart';
import '../icons.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'routine_screens.dart';

class RoutineOverview extends StatelessWidget {
  final Session session;
  final ValueChanged<Session> onSession;
  final VoidCallback onBegin;
  const RoutineOverview({super.key, required this.session, required this.onSession, required this.onBegin});

  Widget _seg(Session s, String label, String icon) {
    final sel = session == s;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSession(s),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: !sel ? null : s == Session.morning ? T.container : T.containerStrong,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Ic(icon, w: 18, h: 18),
            const SizedBox(width: 8),
            Text(label, style: ts(16, w: sel ? kSemi : kMed, c: sel ? T.primary : T.onSurfaceVar, lh: 24)),
          ]),
        ),
      ),
    );
  }

  Widget _stepTile(int n, RoutineStep s) => OCard(
        child: Row(children: [
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Step', style: ts(11, w: kBold, c: T.primary, lh: 16)),
              const SizedBox(height: 2),
              Text('$n', style: ts(18, w: kBold, c: T.primary, lh: 24)),
            ]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.name, style: ts(18, w: kSemi, lh: 24)),
              const SizedBox(height: 8),
              Text(s.label, style: ts(14, c: T.text2, lh: 20)),
            ]),
          ),
          const Ic(chevSvg, w: 8, h: 16),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Body([
      const PageTitle('Daily Routine', sub: 'Follow the clinical sequence recommended for you, for a healthier smile.'),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: T.border)),
        child: Row(children: [
          _seg(Session.morning, 'Morning', sunSvg),
          const SizedBox(width: 4),
          _seg(Session.evening, 'Evening', moonSvg(session == Session.evening ? '#00897B' : '#3F4946')),
        ]),
      ),
      const SizedBox(height: 16),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 32,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Guided Steps', style: ts(18, w: kSemi, lh: 24)),
              const Pill('8 Minutes', icon: clockSvg),
            ]),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kSteps.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            if (i == 4)
              OCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Pill('Dentist’s Advice'),
                  const SizedBox(height: 12),
                  _tileRow(i),
                ]),
              )
            else
              _stepTile(i + 1, kSteps[i]),
          ],
        ]),
      ),
      const SizedBox(height: 16),
      OCard(
        child: Column(children: [
          Text('Completing this routine will earn you 50\nHealth Points!', textAlign: TextAlign.center, style: ts(16, c: T.text2, lh: 24)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: PillButton('Begin Routine', iconData: Icons.play_arrow_rounded, onTap: onBegin)),
        ]),
      ),
    ]);
  }

  Widget _tileRow(int i) {
    final s = kSteps[i];
    return Row(children: [
      Container(
        width: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Step', style: ts(11, w: kBold, c: T.primary, lh: 16)),
          const SizedBox(height: 2),
          Text('${i + 1}', style: ts(18, w: kBold, c: T.primary, lh: 24)),
        ]),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.name, style: ts(18, w: kSemi, lh: 24)),
          const SizedBox(height: 8),
          Text(s.label, style: ts(14, c: T.text2, lh: 20)),
        ]),
      ),
      const Ic(chevSvg, w: 8, h: 16),
    ]);
  }
}
