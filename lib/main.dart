import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/splash_screen.dart';
import 'package:farumasi_patient_app/core/theme/app_theme.dart';
import 'package:farumasi_patient_app/data/repositories/auth_repository_impl.dart';
import 'package:farumasi_patient_app/data/repositories/mock_auth_repository.dart';
import 'package:farumasi_patient_app/domain/repositories/auth_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/medicine_repository.dart';
import 'package:farumasi_patient_app/data/repositories/mock_medicine_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/cart_repository.dart';
import 'package:farumasi_patient_app/data/repositories/mock_cart_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_event.dart'; // Import to fire initial LoadCart

// --- VISUAL FIX: SSL Bypass for Emulators ---
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  AuthRepository authRepository;

  try {
    // Attempt real initialization with a short timeout
    // If it takes longer than 3 seconds (e.g. invalid config), fallback
    await Firebase.initializeApp().timeout(const Duration(seconds: 3));
    authRepository = AuthRepositoryImpl();
    debugPrint("Firebase initialized successfully. Using AuthRepositoryImpl.");
  } catch (e) {
    debugPrint("Firebase initialization failed or timed out: $e");
    debugPrint("Falling back to MockAuthRepository (Offline Mode).");
    authRepository = MockAuthRepository();
  }
  
  // Use MockMedicineRepository for now until Firestore integration is ready
  final medicineRepository = MockMedicineRepository();
  final cartRepository = MockCartRepository();

  runApp(FarumasiApp(
    authRepository: authRepository,
    medicineRepository: medicineRepository,
    cartRepository: cartRepository,
  ));
}

class FarumasiApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MedicineRepository medicineRepository;
  final CartRepository cartRepository;

  const FarumasiApp({
    super.key, 
    required this.authRepository,
    required this.medicineRepository,
    required this.cartRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: medicineRepository),
        RepositoryProvider.value(value: cartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider(
            create: (context) => MedicineBloc(medicineRepository)..add(LoadMedicines()),
          ),
          BlocProvider(
            create: (context) => CartBloc(cartRepository: cartRepository)..add(LoadCart()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

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
