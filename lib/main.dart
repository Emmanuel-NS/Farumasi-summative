import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:io'; // Import dart:io
import 'package:farumasi_patient_app/presentation/screens/splash_screen.dart'; // Import Splash Screen
import 'package:farumasi_patient_app/core/theme/app_theme.dart';
import 'package:farumasi_patient_app/data/datasources/notification_service.dart'; // Import NotificationService

// --- VISUAL FIX: SSL Bypass for Emulators ---
class  MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Apply the override before running the app
  HttpOverrides.global = MyHttpOverrides();
  
  // Initialize Notification Service (NON-BLOCKING)
  // Moved to SplashScreen to prevent startup hang
  // NotificationService().init();

  runApp(const FarumasiApp());
}

class FarumasiApp extends StatelessWidget {
  const FarumasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farumasi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: const SplashScreen(),
    );
  }
}
