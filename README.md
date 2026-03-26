# 🏥 Farumasi Patient App

A Flutter-based mobile application that connects patients with pharmacies and essential healthcare products. The platform enables users to search for medications, locate nearby pharmacies, manage shopping carts, and access health tips—all powered by a secure Firebase backend.

## 🌟 Key Features

- **🔐 Authentication**: Secure User Registration and Login using Firebase Authentication (Email/Password & Google Sign-In) with enforced Email Verification.
- **💊 Pharmacy & Medicine Directory**: Browse, search, and discover medicines dynamically. Supports full CRUD operations from an Admin Dashboard.
- **🛒 E-Commerce & Checkout**: Fully functional cart system, secure checkout workflows, and user order management. 
- **🏢 Admin Dashboard**: Dedicated administrative panels to add, edit, or remove Pharmacies, Medicines, and Health Tips dynamically.
- **Offline / Mock Fallback**: Intelligent fallback system that reverts to Mock Datasets if a Firebase connection encounters errors or is unavailable.
- **🌓 Dark / Light Mode**: Built-in dynamic theme support managed by BLoC.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **Backend as a Service (BaaS)**: [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore)
- **State Management**: [Flutter BLoC](https://bloclibrary.dev/) (lutter_bloc, equatable)
- **Dependency Injection**: Flutter's native RepositoryProvider
- **Testing**: lutter_test, loc_test, mocktail
- **UI & Routing**: Flutter Material UI, Custom Native Routing

## 📂 Project Structure

This project follows a strict separation of concerns, heavily inspired by **Clean Architecture**:

`	ext
lib/
 ├── core/              # Foundational utilities, themes (AppTheme), and constants
 ├── data/              # Models, API clients, Data Seeders, and Repository implementations
 ├── domain/            # Abstract base classes for repositories and core entities
 ├── presentation/      # UI layer
 │    ├── blocs/        # State Management logic (Auth, Theme, Medicine, Pharmacy)
 │    ├── screens/      # All user-facing screens and Admin dashboards
 │    └── widgets/      # Reusable UI components (MedicineItem, AppBars, etc.)
 ├── main.dart          # Entry point, Dependency Injection setup
 └── firebase_options.dart # Generated Firebase configuration (Ignored in Git)
`

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.10.4 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Firebase Project](https://console.firebase.google.com/)

### 🔧 Installation & Setup

1. **Clone the repository:**
   `ash
   git clone https://github.com/yourusername/farumasi_patient_app.git
   cd farumasi_patient_app
   `

2. **Install dependencies:**
   `ash
   flutter pub get
   `

3. **Configure Firebase:**
   This project relies on Firebase Cloud Firestore and Authentication. Ensure you run the Firebase CLI to link your own credentials.
   `ash
   dart pub global activate flutterfire_cli
   flutterfire configure
   `
   *(Note: The google-services.json and irebase_options.dart files are protected and must be generated locally).*

4. **Run the Application:**
   `ash
   flutter run
   `

## 🗄️ Database Seeding (Auto-Scaling)

The application includes a built-in DataSeeder (lib/data/datasources/data_seeder.dart) that detects if your Cloud Firestore collections (medicines, pharmacies, health_tips) are empty. If they are, it will automatically populate your live database with dummy data upon app launch so you can start testing immediately.

## 🧪 Testing

The codebase maintains rigorous unit and widget testing leveraging loc_test and mocktail.

To run tests:
`ash
flutter test
`

## 🛡️ Security Note

All application secrets and proprietary Firebase connection configurations (google-services.json, irebase_options.dart) are strictly guarded and added to .gitignore. Never commit API tokens to version control.
