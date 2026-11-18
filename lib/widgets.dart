import 'package:flutter/material.dart';
import 'state.dart';
import 'tokens.dart';

void toast(BuildContext c, String msg) {
  final m = ScaffoldMessenger.of(c);
  m.hideCurrentSnackBar();
  m.showSnackBar(SnackBar(content: Text(msg)));
}

class OCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const OCard({super.key, required this.child, this.color = Colors.white, this.padding = const EdgeInsets.all(T.s16), this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: color,
        borderRadius: BorderRadius.circular(T.r16),
        child: InkWell(
          borderRadius: BorderRadius.circular(T.r16),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(T.r16),
              border: Border.all(color: T.border),
            ),
            child: child,
          ),
        ),
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const PrimaryButton(this.label, {super.key, this.icon, this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: T.btn,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.r28)),
          ),
          icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
          label: Text(label, style: ts(16, w: FontWeight.w500, c: Colors.white)),
        ),
      );
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const SecondaryButton(this.label, {super.key, this.icon, this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: T.btn),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(T.r28)),
          ),
          icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20, color: T.btn),
          label: Text(label, style: ts(16, w: FontWeight.w500, c: T.btn)),
        ),
      );
}

class Segmented extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  const Segmented({super.key, required this.labels, required this.index, required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: T.surface, borderRadius: BorderRadius.circular(T.r28)),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == index ? T.btn : Colors.transparent,
                      borderRadius: BorderRadius.circular(T.r28),
                    ),
                    child: Text(labels[i],
                        style: ts(14, w: FontWeight.w500, c: i == index ? Colors.white : T.text2)),
                  ),
                ),
              ),
          ],
        ),
      );
}

/// Savings bar - shows Rs, never HP as the headline.
class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: appState,
        builder: (_, __) => OCard(
          color: T.container,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('₹${appState.rupees} of ₹${AppState.goalRupees} saved for your next visit',
                style: ts(16, w: FontWeight.w500, c: T.onContainer)),
            const SizedBox(height: T.s12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: appState.savedFraction,
                minHeight: 8,
                backgroundColor: Colors.white,
                color: T.primary,
              ),
            ),
            const SizedBox(height: T.s12),
            Text(
                '${_n(appState.hp)} HP · 10 HP = ₹1 · covers up to 50% of Dr. Sarah Malik’s ₹400 fee',
                style: ts(12, c: T.text2)),
          ]),
        ),
      );
}

String _n(int v) => v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

class WeeklyOverview extends StatelessWidget {
  const WeeklyOverview({super.key});
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    const letters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return ListenableBuilder(
      listenable: appState,
      builder: (_, __) => OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Weekly Overview', style: ts(16, w: FontWeight.w500)),
          const SizedBox(height: T.s16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            for (var i = 0; i < 7; i++)
              Builder(builder: (_) {
                final d = monday.add(Duration(days: i));
                final done = appState.dayComplete(d);
                final today = i == now.weekday - 1;
                return Column(children: [
                  Text(letters[i], style: ts(12, c: T.text2)),
                  const SizedBox(height: T.s8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? T.btn : Colors.transparent,
                      border: Border.all(color: done ? T.btn : (today ? T.primary : T.border), width: today ? 2 : 1),
                    ),
                    child: done ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
                  ),
                ]);
              }),
          ]),
        ]),
      ),
    );
  }
}
