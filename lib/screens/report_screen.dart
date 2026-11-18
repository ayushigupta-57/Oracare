import 'package:flutter/material.dart';
import '../tokens.dart';
import '../widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // 16 upper + 16 lower teeth. 0 healthy, 1 monitor, 2 action
  static const upper = [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0];
  static const lower = [0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0];

  static const _col = [T.good, T.fair, T.poor];

  Widget _row(List<int> v) => Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final s in v)
            Container(
              width: 18,
              height: 26,
              decoration: BoxDecoration(color: _col[s], borderRadius: BorderRadius.circular(6)),
            ),
        ],
      );

  Widget _legend(String l, Color c) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(l, style: ts(12)),
      ]);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(T.s16, T.s16, T.s16, 120),
        children: [
          Text('Latest Scan', style: ts(28, w: FontWeight.w500)),
          const SizedBox(height: T.s4),
          Text('Your latest Oral Scan Summary', style: ts(16, c: T.text2)),
          const SizedBox(height: T.s16),
          OCard(
            color: T.container,
            child: Row(children: [
              Text('78', style: ts(36, w: FontWeight.w500, c: T.onContainer)),
              Text('/100', style: ts(14, c: T.text2)),
              const Spacer(),
              Text('+4% since last scan', style: ts(12, w: FontWeight.w500, c: T.ok)),
            ]),
          ),
          const SizedBox(height: T.s24),
          Text('Interactive Tooth Map', style: ts(18, w: FontWeight.w500)),
          const SizedBox(height: T.s4),
          Text('32 Points Checked', style: ts(12, c: T.text2)),
          const SizedBox(height: T.s12),
          OCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Upper Jaw', style: ts(14, w: FontWeight.w500)),
              const SizedBox(height: T.s8),
              _row(upper),
              const SizedBox(height: T.s16),
              Text('Lower Jaw', style: ts(14, w: FontWeight.w500)),
              const SizedBox(height: T.s8),
              _row(lower),
              const SizedBox(height: T.s16),
              Wrap(spacing: T.s16, children: [
                _legend('Healthy', T.good),
                _legend('Monitor', T.fair),
                _legend('Action', T.poor),
              ]),
            ]),
          ),
          const SizedBox(height: T.s12),
          Row(children: [
            Expanded(child: _stat('Gum Health', 'Good', T.good)),
            const SizedBox(width: T.s12),
            Expanded(child: _stat('Plaque Level', 'Moderate', T.fair)),
          ]),
          const SizedBox(height: T.s16),
          OCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Dentist’s Note', style: ts(16, w: FontWeight.w500)),
              Text('Dr. Sarah Malik • Today', style: ts(12, c: T.text2)),
              const SizedBox(height: T.s8),
              Text('"Great improvement on the upper left molars. Continue the focused brushing technique we discussed."',
                  style: ts(14)),
            ]),
          ),
          const SizedBox(height: T.s16),
          const PrimaryButton('Share Report', icon: Icons.ios_share),
        ],
      ),
    );
  }

  Widget _stat(String l, String v, Color c) => OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: ts(12, c: T.text2)),
          const SizedBox(height: T.s8),
          Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(v, style: ts(16, w: FontWeight.w500)),
          ]),
        ]),
      );
}
