import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens.dart';
import 'shell.dart';

const _wd = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _mo = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});
  void _open(BuildContext c, Page p) => Navigator.of(c).pushReplacement(MaterialPageRoute(builder: (_) => Shell(start: p)));

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${_wd[now.weekday - 1]}, ${now.day} ${_mo[now.month - 1]}';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        backgroundColor: T.text,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragEnd: (d) {
            if ((d.primaryVelocity ?? 0) < -200) _open(context, Page.home);
          },
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 46),
              Text('7:00', style: ts(96, w: FontWeight.w300, c: Colors.white, lh: 112)),
              Text(date, style: ts(18, c: T.container, lh: 24)),
              const SizedBox(height: 89),
              Container(
                width: 372,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Oracare · now', style: ts(12, w: kMed, c: T.text2, lh: 16)),
                  const SizedBox(height: 6),
                  Text('Time for your morning routine 🪥', style: ts(18, w: kMed, lh: 24)),
                  const SizedBox(height: 6),
                  Text('6 guided steps · about 8 minutes · earn 20 HP', style: ts(16, c: T.onSurfaceVar, lh: 24)),
                  const SizedBox(height: 6),
                  Row(children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _open(context, Page.overview),
                      child: Text('I brushed ✓', style: ts(16, w: kMed, c: T.btn, lh: 24)),
                    ),
                    const SizedBox(width: 24),
                    Text('Remind me in 15 min', style: ts(16, w: kMed, c: T.btn, lh: 24)),
                  ]),
                ]),
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _open(context, Page.home),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text('Swipe up to open', style: ts(14, c: T.containerStrong, lh: 20)),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
