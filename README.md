# Todo App 2.0 📝

A modern, production-ready **Todo application built with Flutter and Firebase**, featuring authentication, real-time sync, dark/light theme persistence, onboarding flow, and a polished UI/UX.

---
## IMAGES
LOGIN/REGISTER - HOME PAGE - PROFILE PAGE
<img width="402" height="539" alt="image" src="https://github.com/user-attachments/assets/59fb32ae-09a2-42c8-8d14-ace1690336ba" />
<img width="302" height="442" alt="image" src="https://github.com/user-attachments/assets/76ba1898-a2d5-420c-9021-572dd5bde174" />

<img width="500" height="645" alt="image" src="https://github.com/user-attachments/assets/6e4ae29d-88ae-4259-ab76-ace00ad065b7" />
<img width="498" height="641" alt="image" src="https://github.com/user-attachments/assets/37e638aa-f1c0-4245-ab5d-3e92b469293d" />


## ✨ Features

### 🔐 Authentication
- Email & password login
- Secure registration
- Password reset
- Change password from profile

### ✅ Todo Management
- Create, complete, and delete todos
- Real-time sync using Firebase Firestore
- Completed tasks with visual distinction

### 🎨 UI / UX
- Clean and minimal Material UI
- Light & Dark theme support
- Theme preference synced with Firebase
- Animated splash screen
- Onboarding flow for first-time users

### 👤 Profile
- Update display name
- Toggle Dark Mode (persisted across app restarts)
- Logout securely

---

## 🛠️ Tech Stack

- **Flutter** (UI framework)
- **Firebase Authentication**
- **Cloud Firestore**
- **SharedPreferences** (local caching)
- **Material Design 3**

---

## 📂 Project Structure

lib/
├── core/
│ ├── services/ # Auth, profile, todo services
│ └── theme/ # App colors, themes, controller
│
├── features/
│ ├── auth/ # Login, register, auth gate
│ ├── onboarding/ # Onboarding screens
│ ├── splash/ # Splash screen & bootstrap
│ ├── home/ # Todo home page
│ └── profile/ # Profile & settings
│
├── main.dart

## 🚀 Getting Started

### 1️⃣ Prerequisites
- Flutter SDK (stable)
- Android Studio (with Android SDK)
- Firebase project set up
- Java JDK 17+

Verify:
>>> flutter doctor
2️⃣ Firebase Setup
Create a Firebase project

Add an Android app

Download google-services.json

Place it in:
android/app/google-services.json
Enable:
Firebase Authentication (Email/Password)

Cloud Firestore

3️⃣ Install Dependencies
>>> flutter pub get
4️⃣ Run the App (Debug)
>>> flutter run
📦 Build APK (Release)
To generate a shareable APK:
>>> flutter clean
>>> flutter build apk --release
APK output:
build/app/outputs/flutter-apk/app-release.apk
⚠️ Installing APKs requires enabling “Install unknown apps” on the device (Android OS requirement).
