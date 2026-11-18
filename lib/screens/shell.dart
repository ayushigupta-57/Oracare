import 'package:flutter/material.dart';
import '../tokens.dart';
import '../widgets.dart';
import 'home_screen.dart';
import 'report_screen.dart';
import 'routine_overview.dart';

/// Bottom nav: Home, Routine, Report, Community. Outlined by default, filled when selected.
class Shell extends StatefulWidget {
  final int initialTab;
  const Shell({super.key, this.initialTab = 0});
  static ShellState? of(BuildContext c) => c.findAncestorStateOfType<ShellState>();
  @override
  State<Shell> createState() => ShellState();
}

class ShellState extends State<Shell> {
  late int tab = widget.initialTab;
  void goTo(int i) => setState(() => tab = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tab, children: const [
        HomeScreen(),
        RoutineOverviewScreen(),
        ReportScreen(),
        SizedBox.shrink(),
      ]),
      // Care Hub: visible as in the design, but not interactive in this prototype.
      floatingActionButton: IgnorePointer(
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: T.btn, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) {
          if (i != 3) goTo(i); // Community is outside the daily loop: not tappable
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.schedule_outlined), selectedIcon: Icon(Icons.schedule), label: 'Routine'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Community'),
        ],
      ),
    );
  }
}

