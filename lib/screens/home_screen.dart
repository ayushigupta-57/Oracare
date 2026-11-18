import 'package:flutter/material.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(T.s16, T.s16, T.s16, 120),
        children: [
          GestureDetector(
            onLongPress: () {
              appState.resetDemo();
              toast(context, 'Demo data reset');
            },
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good Morning, Rajan', style: ts(28, w: FontWeight.w500)),
              const SizedBox(height: T.s4),
              Text('Welcome back!', style: ts(16, c: T.text2)),
            ]),
          ),
          const SizedBox(height: T.s24),
          _score(),
          const SizedBox(height: T.s24),
          Text('Quick Actions', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s12),
          _quickActions(context),
          const SizedBox(height: T.s24),
          Text('Your Doctor', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s12),
          OCard(
            child: Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: T.container, child: Icon(Icons.person_outline, color: T.onContainer)),
              const SizedBox(width: T.s12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Dr. Sarah Malik • BDS • 2.1 km away', style: ts(14, w: FontWeight.w500)),
                  const SizedBox(height: T.s4),
                  Text('Shree Dental Clinic • Speaks Marathi, Hindi, English', style: ts(12, c: T.text2)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: T.s12),
          OCard(
            color: T.container,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Next Dentist Visit', style: ts(14, w: FontWeight.w500, c: T.onContainer)),
              const SizedBox(height: T.s4),
              Text('Dr. Sarah Malik • Oct 15, 2024 • 10:30 AM', style: ts(14)),
              Text('Shree Dental Clinic', style: ts(12, c: T.text2)),
            ]),
          ),
          const SizedBox(height: T.s24),
          Text('Tip of the Day', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s12),
          OCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Complete your Dental Routines daily and earn Health Points to redeem at your Dentist Appointments.',
                  style: ts(14)),
              const SizedBox(height: T.s12),
              Text('Know More', style: ts(14, w: FontWeight.w500, c: T.btn)),
            ]),
          ),
          const SizedBox(height: T.s24),
          Text('Dental Camp Nearby', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s12),
          OCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Free Dental Checkup Camp • Oct 24, 2026', style: ts(14, w: FontWeight.w500)),
              const SizedBox(height: T.s4),
              Text('RK Dental Clinic', style: ts(12, c: T.text2)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _score() => OCard(
        color: T.container,
        child: Row(children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            alignment: Alignment.center,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('78', style: ts(36, w: FontWeight.w500, c: T.onContainer, h: 1.1)),
              Text('/100', style: ts(12, c: T.text2)),
            ]),
          ),
          const SizedBox(width: T.s16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Oral Health Score', style: ts(12, c: T.text2)),
              const SizedBox(height: T.s4),
              Text('+4% since last scan', style: ts(12, w: FontWeight.w500, c: T.ok)),
              const SizedBox(height: T.s8),
              Text('Excellent progress this week', style: ts(16, w: FontWeight.w500)),
              const SizedBox(height: T.s4),
              Text('Your oral health is trending up. Keep your routine consistent to maintain this momentum.',
                  style: ts(12, c: T.text2)),
            ]),
          ),
        ]),
      );

  Widget _quickActions(BuildContext c) {
    final items = <(IconData, String, VoidCallback?)>[
      (Icons.qr_code_scanner, 'Link Kiosk', null),
      (Icons.calendar_today_outlined, 'Book Appointment', null),
      (Icons.chat_bubble_outline, 'Talk to Dentist', null),
      (Icons.play_circle_outline, 'Start a Routine', () => Shell.of(c)?.goTo(1)),
    ];
    // All four cards are the same size and equally spaced.
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: T.s12,
      crossAxisSpacing: T.s12,
      childAspectRatio: 1.5,
      children: [
        for (final it in items)
          OCard(
            onTap: it.$3,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(it.$1, color: T.onContainer),
              const SizedBox(height: T.s8),
              Text(it.$2, style: ts(14, w: FontWeight.w500)),
            ]),
          ),
      ],
    );
  }
}
