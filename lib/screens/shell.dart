import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'routine_overview.dart';
import 'routine_screens.dart';

enum Page { home, overview, steps, complete, report }

class Shell extends StatefulWidget {
  final Page start;
  const Shell({super.key, this.start = Page.home});
  @override
  State<Shell> createState() => ShellState();
}

class ShellState extends State<Shell> {
  late Page page = widget.start;
  Session session = Session.morning;
  String? toastText;
  Timer? _tt;

  int get tab => switch (page) { Page.home => 0, Page.report => 2, _ => 1 };

  void go(Page p) => setState(() => page = p);

  void showToast(String t) {
    _tt?.cancel();
    setState(() => toastText = t);
    _tt = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => toastText = null);
    });
  }

  @override
  void dispose() {
    _tt?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final (title, back, left) = switch (page) {
      Page.home => ('Oracare', null, true),
      Page.overview => ('Routine', () => go(Page.home), false),
      Page.steps => ('Routine', () => go(Page.overview), false),
      Page.complete => ('Routine', () => go(Page.overview), false),
      Page.report => ('Report', () => go(Page.home), false),
    };
    final body = switch (page) {
      Page.home => HomeScreen(onStartRoutine: () => go(Page.overview)),
      Page.overview => RoutineOverview(session: session, onSession: (s) => setState(() => session = s), onBegin: () => go(Page.steps)),
      Page.steps => RoutineStepsScreen(key: ValueKey(session), session: session, onDone: () {
          go(Page.complete);
          showToast('${session == Session.morning ? 'Morning' : 'Evening'} check-in recorded · +${AppState.checkInHp} Health Points');
        }),
      Page.complete => RoutineCompleteScreen(session: session),
      Page.report => const ReportScreen(),
    };
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: T.bg,
        body: Stack(children: [
          Column(children: [
            Container(height: top, color: T.bg),
            OHeader(title, onBack: back, leftTitle: left),
            Expanded(child: body),
            ONavBar(selected: tab, onSelect: (i) => go([Page.home, Page.overview, Page.report][i])),
          ]),
          Positioned(right: 24, bottom: 64 + bottomInset + 16, child: const Fab()),
          if (toastText != null)
            Positioned(left: 24, right: 24, bottom: 152 + bottomInset, child: ToastBar(toastText!)),
        ]),
      ),
    );
  }
}
