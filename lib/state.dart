import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Session { morning, evening }

String _day(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// App state: Health Points + which routines were fully completed.
/// Rule: a check-in counts only when the FULL routine is finished (+20 HP).
class AppState extends ChangeNotifier {
  static const startHp = 1200; // demo starting balance (matches Figma: 1,200 HP)
  static const checkInHp = 20;
  static const hpPerRupee = 10; // 10 HP = Rs 1
  static const feeRupees = 400;
  static const goalRupees = 200; // up to 50% of the fee

  int hp = startHp;
  final Set<String> _done = {}; // "yyyy-MM-dd|morning"
  SharedPreferences? _p;

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    hp = _p!.getInt('hp') ?? startHp;
    _done
      ..clear()
      ..addAll(_p!.getStringList('done') ?? const []);
    notifyListeners();
  }

  int get rupees => hp ~/ hpPerRupee;
  double get savedFraction => (rupees / goalRupees).clamp(0.0, 1.0);

  bool isDone(DateTime d, Session s) => _done.contains('${_day(d)}|${s.name}');
  bool dayComplete(DateTime d) => isDone(d, Session.morning) || isDone(d, Session.evening);

  /// Returns true if HP were awarded (first completion of that session today).
  bool completeRoutine(Session s) {
    final key = '${_day(DateTime.now())}|${s.name}';
    if (_done.contains(key)) return false;
    _done.add(key);
    hp += checkInHp;
    _save();
    notifyListeners();
    return true;
  }

  void resetDemo() {
    hp = startHp;
    _done.clear();
    _save();
    notifyListeners();
  }

  void _save() {
    _p?.setInt('hp', hp);
    _p?.setStringList('done', _done.toList());
  }
}

final appState = AppState();
