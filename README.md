# Oracare - daily loop (Flutter)

Screens: Lock-screen reminder, Home, Routine overview (morning/evening), guided Routine steps (timers),
Check-in toast, Routine complete, Oral report. Everything outside the daily loop is visible but not tappable.

## Logic
- Check-in (+20 HP) is recorded only when the FULL routine is finished.
- 10 HP = Rs 1; savings bar shows Rs, capped at 50% of the Rs 400 fee (Rs 200).
- HP and check-ins persist on the phone. Long-press the greeting on Home to reset demo data.
- Set `kTimerSpeed` in lib/screens/routine_screens.dart to e.g. 10 to test faster.

## Build the APK (Windows)
1. Install Flutter (https://docs.flutter.dev/get-started/install/windows/mobile) - it walks you through
   Android Studio + the Android SDK. Then run `flutter doctor` and accept licences: `flutter doctor --android-licenses`.
2. Open a terminal in this folder and run `build_apk.bat`.
3. APK appears at build\app\outputs\flutter-apk\app-release.apk
4. Copy it to your phone (USB / Drive), open it, allow "install unknown apps". Or plug in the phone
   with USB debugging on and run `flutter install`.

## Build on GitHub (no local setup)
Push to `main` (or run the "Build APK" workflow from the Actions tab). When it finishes, open the run and
download the **oracare-daily-apk** artifact - it contains `app-release.apk`.
