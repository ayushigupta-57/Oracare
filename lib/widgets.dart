import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'icons.dart';
import 'state.dart';
import 'tokens.dart';

String fmt(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

/// White card: 0.8px border, radius 16, padding 20.
class OCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? height;
  final Color color;
  final Color borderColor;
  const OCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.height, this.color = Colors.white, this.borderColor = T.border});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: child,
      );
}

/// Pill chip (e.g. "8 Minutes", "Earned 75 HP").
class Pill extends StatelessWidget {
  final String text;
  final Color bg, fg;
  final String? icon;
  final EdgeInsets padding;
  final Color? border;
  const Pill(this.text, {super.key, this.bg = T.container, this.fg = T.onContainer, this.icon, this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6), this.border});
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9999), border: border == null ? null : Border.all(color: border!)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Ic(icon!, w: 20, h: 20), const SizedBox(width: 4)],
          Text(text, style: ts(14, w: kMed, c: fg, lh: 20)),
        ]),
      );
}

/// Filled pill button (#00796B), 56 high.
class PillButton extends StatelessWidget {
  final String label;
  final String? icon;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Color bg, fg;
  final Color? border;
  const PillButton(this.label, {super.key, this.icon, this.iconData, this.onTap, this.bg = T.btn, this.fg = Colors.white, this.border});
  @override
  Widget build(BuildContext context) => Material(
        color: bg,
        shape: StadiumBorder(side: border == null ? BorderSide.none : BorderSide(color: border!)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              if (icon != null) ...[Ic(icon!), const SizedBox(width: 8)],
              if (iconData != null) ...[Icon(iconData, size: 24, color: fg), const SizedBox(width: 8)],
              Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts(16, w: kMed, c: fg, lh: 24))),
            ]),
          ),
        ),
      );
}

/// Small pill button (14 Medium) used on Home cards.
class SmallPill extends StatelessWidget {
  final String label;
  final bool outlined;
  const SmallPill(this.label, {super.key, this.outlined = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: T.btn, borderRadius: BorderRadius.circular(9999), border: outlined ? Border.all(color: Colors.white) : null),
        child: Text(label, style: ts(14, w: kMed, c: Colors.white, lh: 20)),
      );
}

/// 48x48 icon tile (radius 14).
class Tile extends StatelessWidget {
  final String glyph;
  final Color bg;
  final bool border;
  final double size;
  const Tile(this.glyph, {super.key, this.bg = T.container, this.border = false, this.size = 48});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: border ? Border.all(color: T.onContainer) : null),
        child: Ic(glyph, w: size, h: size),
      );
}

/// The 36x36 user button in the header.
class UserButton extends StatelessWidget {
  const UserButton({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: T.container, borderRadius: BorderRadius.circular(14)),
        child: Ic(userSvg('#00897B'), w: 20, h: 20),
      );
}

/// Top app bar: white, 56 high, below the status bar.
class OHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool leftTitle;
  const OHeader(this.title, {super.key, this.onBack, this.leftTitle = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
      height: 56,
      child: Stack(alignment: Alignment.center, children: [
        Align(
          alignment: Alignment.centerLeft,
          child: leftTitle
              ? Text(title, style: ts(22, w: kMed, lh: 28))
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: const SizedBox(width: 44, height: 44, child: Center(child: Ic(backSvg, w: 8, h: 16))),
                ),
        ),
        if (!leftTitle) Text(title, style: ts(22, w: kMed, lh: 28)),
        const Align(alignment: Alignment.centerRight, child: UserButton()),
      ]),
    );
  }
}

/// Page title + subtitle.
class PageTitle extends StatelessWidget {
  final String title;
  final String? sub;
  const PageTitle(this.title, {super.key, this.sub});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: ts(28, w: kBold, lh: 36)),
        if (sub != null) Text(sub!, style: ts(16, c: T.text2, lh: 24)),
      ]);
}

/// Circular score gauge (arc starts at 12 o'clock, clockwise).
class Ring extends StatelessWidget {
  final double value; // 0..100
  const Ring(this.value, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 96,
        height: 96,
        child: CustomPaint(
          painter: _RingPainter(value / 100),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${value.round()}', style: ts(28, w: kMed, lh: 32)),
              Text('/100', style: ts(14, c: T.text2, lh: 16)),
            ]),
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  final double f;
  _RingPainter(this.f);
  @override
  void paint(Canvas c, Size s) {
    const sw = 8.0;
    final r = Rect.fromLTWH(sw / 2, sw / 2, s.width - sw, s.height - sw);
    final track = Paint()..style = PaintingStyle.stroke..strokeWidth = sw..color = T.container;
    final arc = Paint()..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round..color = T.primary;
    c.drawArc(r, 0, math.pi * 2, false, track);
    c.drawArc(r, -math.pi / 2, math.pi * 2 * f, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.f != f;
}

/// Weekly Overview card, with the savings bar underneath.
class WeeklyOverview extends StatelessWidget {
  final int earnedHp;
  const WeeklyOverview({super.key, required this.earnedHp});
  static const _days = ['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
  static const _h = [42.0, 52.0, 36.0, 64.0, 48.0, 58.0, 12.0];
  Color _c(int i) => i == 5 ? T.containerStrong : i == 6 ? T.borderDefault : T.primary;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) => OCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 32,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Weekly Overview', style: ts(18, w: kSemi, lh: 24)),
              Pill('Earned $earnedHp HP'),
            ]),
          ),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
            for (var i = 0; i < 7; i++)
              SizedBox(
                width: 36,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 32,
                    height: _h[i],
                    decoration: BoxDecoration(color: _c(i), borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
                  ),
                  const SizedBox(height: 16),
                  Text(_days[i], style: ts(18, w: kBold, c: T.text2, lh: 24)),
                ]),
              ),
          ]),
          const SizedBox(height: 16),
          Text('₹${appState.rupees} of ₹${AppState.goalRupees} saved for your next visit', style: ts(16, w: kMed, lh: 24)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LayoutBuilder(
              builder: (_, c) => Stack(children: [
                Container(height: 8, width: c.maxWidth, color: T.containerStrong),
                Container(height: 8, width: c.maxWidth * appState.savedFraction, color: T.primary),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          Text('${fmt(appState.hp)} HP · 10 HP = ₹1 · covers up to 50% of Dr. Sarah Malik’s ₹400 fee', style: ts(12, c: T.text2, lh: 16)),
        ]),
      ),
    );
  }
}

/// Bottom navigation bar + chat FAB.
class ONavBar extends StatelessWidget {
  final int selected; // 0 home, 1 routine, 2 report
  final ValueChanged<int> onSelect;
  const ONavBar({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Home', navHome, navHomeF),
      ('Routine', navRoutine, navRoutineF),
      ('Report', navReport, navReportF),
      ('Community', navCommunity, navCommunity),
    ];
    return Container(
      color: T.surface,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        height: 64,
        child: Row(children: [
          for (var i = 0; i < 4; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: i == 3 ? null : () => onSelect(i),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 56,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: selected == i ? T.container : Colors.transparent, borderRadius: BorderRadius.circular(9999)),
                    child: Ic(selected == i ? items[i].$3 : items[i].$2, w: 24, h: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(items[i].$1, style: ts(12, w: kMed, c: T.onSurfaceVar, lh: 16)),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: T.container,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x26000000), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 3),
            BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 3),
          ],
        ),
        child: const Ic(fabChat, w: 24, h: 24),
      );
}

/// Dark toast (Figma "toast").
class ToastBar extends StatelessWidget {
  final String text;
  const ToastBar(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: T.text,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x29000000), offset: Offset(0, 4), blurRadius: 12)],
        ),
        child: Row(children: [
          const Ic(toastCheck, w: 28, h: 28),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: ts(16, w: kMed, c: Colors.white, lh: 24))),
        ]),
      );
}

/// Scroll body with the standard 24px side padding and 152px bottom spacer.
class Body extends StatelessWidget {
  final List<Widget> children;
  const Body(this.children, {super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 152),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
      );
}
