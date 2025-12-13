# todo_app_2

A new Flutter project.

# App starts
# 1. App initialization
flutter create violet_todo_app
cd violet_todo_app

# 2.
dart pub global activate flutterfire_cli   # needed to configure Firebase for Flutter.

# 3. Dependencies
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0                # app state, theme, and simple DI
  firebase_core: ^latest          # connect to Firebase. :contentReference[oaicite:5]{index=5}
  firebase_auth: ^latest          # user authentication. :contentReference[oaicite:6]{index=6}
  cloud_firestore: ^latest        # Firestore DB. :contentReference[oaicite:7]{index=7}
  salomon_bottom_bar: ^latest     # stylish bottom navigation (visual uplift). :contentReference[oaicite:8]{index=8}
  introduction_screen: ^latest    # onboarding slides with drag support. :contentReference[oaicite:9]{index=9}
  flutter_spinkit: ^latest        # optional loader animations
  cupertino_icons: ^1.0.2

# 4. — Firebase setup (project + app)

Follow these core steps (Firebase official flow):
Create a Firebase project in the Firebase console.
Add Android and/or iOS apps in Firebase; download google-services.json (Android) and GoogleService-Info.plist (iOS).

# Install the CLI globally using Dart Pub
dart pub global activate flutterfire_cli

Add the New Path
In the Edit environment variable window, click the "New" button.
Paste the exact directory path from the warning message:
C:\Users\SSK\AppData\Local\Pub\Cache\bin

Install Firebase Tools via npm
Once Node.js and npm are confirmed, run the following command to install the official Firebase CLI globally:
>>> npm install -g firebase-tools

Use FlutterFire CLI to configure the Flutter project:
>>> flutterfire configure
>>> firebase --version
>>> firebase login