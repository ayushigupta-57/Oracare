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

  /// One step tile: 312 wide, padding 20, "Step N" box 48x62, name + duration, chevron.
  Widget _stepTile(int i, {bool advice = false}) {
    final s = kSteps[i];
    final row = Row(children: [
      Container(
        width: 48,
        height: 62,
        decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Step', softWrap: false, style: ts(11, w: kBold, c: T.primary, lh: 16)),
          const SizedBox(height: 2),
          Text('${i + 1}', softWrap: false, style: ts(18, w: kBold, c: T.primary, lh: 24)),
        ]),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.name, style: ts(18, w: kSemi, lh: 24)),
          const SizedBox(height: 5),
          Text(s.label, style: ts(14, c: T.text2, lh: 20)),
        ]),
      ),
      const Padding(padding: EdgeInsets.only(right: 4), child: Ic(chevSvg, w: 11, h: 18)),
    ]);
    return OCard(
      child: advice
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 32,
                padding: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(9999)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.lightbulb_outline, size: 20, color: T.onContainer),
                  const SizedBox(width: 4),
                  Text('Dentist’s Advice', style: ts(14, w: kMed, c: T.onContainer, lh: 20)),
                ]),
              ),
              const SizedBox(height: 12),
              row,
            ])
          : row,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Body([
      const PageTitle('Daily Routine', sub: 'Follow the clinical sequence recommended for you, for a healthier smile.', subWidth: 300),
      const SizedBox(height: 20),
      Center(
        child: Container(
          width: 342,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: T.border)),
          child: Row(children: [
            _seg(Session.morning, 'Morning', sunSvg),
            const SizedBox(width: 4),
            _seg(Session.evening, 'Evening', moonSvg(session == Session.evening ? '#00897B' : '#3F4946')),
          ]),
        ),
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
            Padding(padding: const EdgeInsets.symmetric(horizontal: 5.7), child: _stepTile(i, advice: i == 4)),
          ],
        ]),
      ),
      const SizedBox(height: 16),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Completing this routine will earn you 50\nHealth Points!', textAlign: TextAlign.center, style: ts(16, c: T.text2, lh: 24)),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerLeft, child: SizedBox(width: 320, child: PillButton('Begin Routine', iconData: Icons.play_arrow_rounded, onTap: onBegin))),
        ]),
      ),
    ]);
  }
}
