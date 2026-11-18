@echo off
REM Builds the Oracare daily-loop APK. Run from this folder, after installing Flutter + Android Studio.
where flutter >nul 2>nul || (echo Flutter not found in PATH. See README.md step 1. & exit /b 1)
call flutter create --org com.oracare --project-name oracare_daily --platforms android .
if exist test\widget_test.dart del test\widget_test.dart
call flutter pub get
call flutter build apk --release
echo.
echo APK: build\app\outputs\flutter-apk\app-release.apk
