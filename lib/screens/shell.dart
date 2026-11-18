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

enum Pg { home, overview, steps, complete, report }

class Shell extends StatefulWidget {
  final Pg start;
  const Shell({super.key, this.start = Pg.home});
  @override
  State<Shell> createState() => ShellState();
}

class ShellState extends State<Shell> {
  late Pg page = widget.start;
  Session session = Session.morning;
  String? toastText;
  Timer? _tt;

  int get tab => switch (page) { Pg.home => 0, Pg.report => 2, _ => 1 };

  void go(Pg p) => setState(() => page = p);

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
      Pg.home => ('Oracare', null, true),
      Pg.overview => ('Routine', () => go(Pg.home), false),
      Pg.steps => ('Routine', () => go(Pg.overview), false),
      Pg.complete => ('Routine', () => go(Pg.overview), false),
      Pg.report => ('Report', () => go(Pg.home), false),
    };
    final body = switch (page) {
      Pg.home => HomeScreen(onStartRoutine: () => go(Pg.overview)),
      Pg.overview => RoutineOverview(session: session, onSession: (s) => setState(() => session = s), onBegin: () => go(Pg.steps)),
      Pg.steps => RoutineStepsScreen(key: ValueKey(session), session: session, onDone: () {
          go(Pg.complete);
          showToast('${session == Session.morning ? 'Morning' : 'Evening'} check-in recorded · +${AppState.checkInHp} Health Points');
        }),
      Pg.complete => RoutineCompleteScreen(session: session),
      Pg.report => const ReportScreen(),
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
            ONavBar(selected: tab, onSelect: (i) => go([Pg.home, Pg.overview, Pg.report][i])),
          ]),
          Positioned(right: 24, bottom: 64 + bottomInset + 16, child: const Fab()),
          if (toastText != null)
            Positioned(left: 24, right: 24, bottom: 152 + bottomInset, child: ToastBar(toastText!)),
        ]),
      ),
    );
  }
}
