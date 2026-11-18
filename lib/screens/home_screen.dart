import 'package:flutter/material.dart';
import '../icons.dart';
import '../tokens.dart';
import '../widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartRoutine;
  const HomeScreen({super.key, required this.onStartRoutine});

  Widget _qa(String glyph, String label, {VoidCallback? onTap}) => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: OCard(
            height: 145.6,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Tile(glyph, border: true),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center, style: ts(16, w: kMed, lh: 24)),
            ]),
          ),
        ),
      );

  Widget _info(Widget leading, String title, List<String> lines, Widget action) => OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            leading,
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: ts(18, w: kSemi, lh: 24)),
                for (final l in lines) Text(l, style: ts(14, c: T.text2, lh: 20)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          action,
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Body([
      const PageTitle('Good Morning, Rajan', sub: 'Welcome back!'),
      const SizedBox(height: 16),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 32,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Oral Health Score', style: ts(18, w: kSemi, lh: 24)),
              Row(children: [
                Ic(trendSvg, w: 18, h: 18),
                const SizedBox(width: 4),
                Text('+4% since last scan', style: ts(14, w: kMed, c: T.primary, lh: 20)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Ring(78),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Excellent progress this week', style: ts(16, w: kMed, lh: 24)),
                Text('Your oral health is trending up. Keep your routine consistent to maintain this momentum.', style: ts(16, c: T.text2, lh: 24)),
              ]),
            ),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      OCard(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Tile(glyphTip),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tip of the Day', style: ts(18, w: kSemi, lh: 24)),
              Text('Complete your Dental Routines daily and earn Health Points to redeem at your Dentist Appointments.', style: ts(16, c: T.text2, lh: 24)),
              const SizedBox(height: 8),
              Text('Know More', style: ts(16, w: kMed, c: T.primary, lh: 24)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      Text('Quick Actions', style: ts(18, w: kSemi, lh: 24)),
      const SizedBox(height: 16),
      Row(children: [_qa(glyphPin, 'Link Kiosk'), const SizedBox(width: 16), _qa(glyphCalendar, 'Book Appointment')]),
      const SizedBox(height: 16),
      Row(children: [_qa(glyphChat, 'Talk to Dentist'), const SizedBox(width: 16), _qa(glyphPlay('#E0F2F1', '#006B60'), 'Start a Routine', onTap: onStartRoutine)]),
      const SizedBox(height: 16),
      _info(
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)),
          child: Ic(userSvg('#00796B'), w: 24, h: 24),
        ),
        'Your Doctor',
        const ['Dr. Sarah Malik • BDS • 2.1 km away', 'Shree Dental Clinic • Speaks Marathi, Hindi, English'],
        const Align(alignment: Alignment.centerLeft, child: SmallPill('Change Doctor')),
      ),
      const SizedBox(height: 16),
      _info(const Tile(glyphCalendar), 'Next Dentist Visit', const ['Dr. Sarah Malik • Oct 15, 2024 • 10:30 AM', 'Shree Dental Clinic'], const Align(alignment: Alignment.centerLeft, child: SmallPill('Reschedule'))),
      const SizedBox(height: 16),
      _info(const Tile(glyphPin), 'Dental Camp Nearby', const ['Free Dental Checkup Camp • Oct 24, 2026', 'RK Dental Clinic'], const Align(alignment: Alignment.centerLeft, child: SmallPill('Register', outlined: true))),
    ]);
  }
}
