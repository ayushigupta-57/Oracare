import 'package:flutter/material.dart';
import '../icons.dart';
import '../tokens.dart';
import '../widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  Widget _legend(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(t, style: ts(16, c: T.text2, lh: 24)),
      ]);

  Widget _stat(String chip, Color bg, Color fg, String label) => Expanded(
        child: OCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9999)),
              child: Text(chip, style: ts(16, w: kMed, c: fg, lh: 24)),
            ),
            const SizedBox(height: 8),
            Text(label, style: ts(16, c: T.text2, lh: 24)),
          ]),
        ),
      );

  Widget _outBtn(String label, IconData icon) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 320,
          height: 56,
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(9999), border: Border.all(color: T.onContainer)),
          child: Row(children: [
            Icon(icon, size: 24, color: T.onContainer),
            const SizedBox(width: 8),
            Text(label, style: ts(16, w: kMed, c: T.onContainer, lh: 24)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Body([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Latest Scan', style: ts(28, w: kBold, lh: 36)),
              Text('Your latest Oral Scan Summary', style: ts(16, c: T.text2, lh: 24)),
              const SizedBox(height: 8),
              const TrendChip(),
            ]),
          ),
          const SizedBox(width: 24),
          const Ring(78),
        ]),
      ),
      const SizedBox(height: 20),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 32,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Interactive Tooth Map', style: ts(18, w: kSemi, lh: 24)),
              const Pill('32 Points Checked', padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Upper Jaw', textAlign: TextAlign.center, style: ts(16, w: kMed, lh: 24)),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 307,
              height: 353,
              child: Image.asset('assets/images/mouth.png', fit: BoxFit.fill),
            ),
          ),
          const SizedBox(height: 8),
          Text('Lower Jaw', textAlign: TextAlign.center, style: ts(16, w: kMed, lh: 24)),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 307,
              height: 28,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _legend(T.good, 'Healthy'),
                  _legend(T.fair, 'Monitor'),
                  _legend(T.poor, 'Action'),
                ]),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Row(children: [
        _stat('Good', T.container, T.btn, 'Gum Health'),
        const SizedBox(width: 16),
        _stat('Moderate', T.warnContainer, T.warn, 'Plaque Level'),
      ]),
      const SizedBox(height: 16),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 42,
            child: Row(children: [
              Container(width: 40, height: 40, decoration: const BoxDecoration(color: T.container, shape: BoxShape.circle), child: Center(child: Ic(userSvg('#00796B'), w: 20, h: 20))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Dentist’s Note', style: ts(18, w: kSemi, lh: 21)),
                  Text('Dr. Sarah Malik • Today', style: ts(14, c: T.text2, lh: 20)),
                ]),
              ),
              Container(width: 42, height: 42, decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.chat_bubble, size: 16, color: T.onContainer)),
            ]),
          ),
          const SizedBox(height: 10),
          Text('"Great improvement on the upper left molars. Continue the focused brushing technique we discussed."', style: ts(16, c: T.text, lh: 24, style: FontStyle.italic)),
        ]),
      ),
      const SizedBox(height: 16),
      OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Share Report', style: ts(16, w: kMed, lh: 24)),
          const SizedBox(height: 12),
          _outBtn('Email Report', Icons.mail_outline),
          const SizedBox(height: 12),
          _outBtn('Download PDF', Icons.download),
        ]),
      ),
    ]);
  }
}
