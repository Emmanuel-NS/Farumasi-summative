import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:farumasi_patient_app/data/repositories/health_repository_impl.dart';
import 'package:farumasi_patient_app/data/repositories/mock_health_repository.dart';
import 'package:farumasi_patient_app/domain/repositories/health_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/health_tips/health_tips_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/health_tips/health_tips_event.dart';
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
import 'package:farumasi_patient_app/data/repositories/medicine_repository_impl.dart';
// import 'package:farumasi_patient_app/data/repositories/mock_medicine_repository.dart'; // REMOVED mock usage or keep as fallback
import 'package:farumasi_patient_app/presentation/blocs/medicine/medicine_bloc.dart';
import 'package:farumasi_patient_app/domain/repositories/cart_repository.dart';
import 'package:farumasi_patient_app/data/repositories/mock_cart_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_bloc.dart';
import 'package:farumasi_patient_app/presentation/blocs/cart/cart_event.dart'; // Import to fire initial LoadCart

import 'package:farumasi_patient_app/presentation/blocs/theme/theme_cubit.dart';
import 'package:farumasi_patient_app/domain/repositories/order_repository.dart';
import 'package:farumasi_patient_app/data/repositories/order_repository_impl.dart';
import 'package:farumasi_patient_app/data/repositories/mock_medicine_repository.dart';
import 'package:farumasi_patient_app/data/repositories/mock_order_repository.dart';
import 'package:farumasi_patient_app/presentation/blocs/order/order_bloc.dart';
import 'firebase_options.dart'; // Import the generated file
import 'package:farumasi_patient_app/data/datasources/data_seeder.dart'; // Added for seeding

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
  MedicineRepository medicineRepository;
  OrderRepository orderRepository;
  HealthRepository healthRepository;

  try {
    // Attempt real initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    authRepository = AuthRepositoryImpl();
    medicineRepository = MedicineRepositoryImpl();
    orderRepository = OrderRepositoryImpl();
    healthRepository = HealthRepositoryImpl();
    debugPrint("Firebase initialized successfully. Using Real Repositories.");

    // ---- SEED DATA IF NEEDED ----
    await DataSeeder.seedData();
    // -----------------------------
  } catch (e) {
    debugPrint("Firebase initialization failed or timed out: $e");
    debugPrint("Falling back to Mock Repositories (Offline Mode).");
    authRepository = MockAuthRepository();
    medicineRepository = MockMedicineRepository();
    orderRepository = MockOrderRepository();
    healthRepository = MockHealthRepository();
  }
  
  final cartRepository = MockCartRepository();

  runApp(FarumasiApp(
    authRepository: authRepository,
    medicineRepository: medicineRepository,
    cartRepository: cartRepository,
    orderRepository: orderRepository,
    healthRepository: healthRepository,
  ));
}

class FarumasiApp extends StatelessWidget {
  final AuthRepository authRepository;
  final MedicineRepository medicineRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;
  final HealthRepository healthRepository;

  const FarumasiApp({
    super.key, 
    required this.authRepository,
    required this.medicineRepository,
    required this.cartRepository,
    required this.orderRepository,
    required this.healthRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: medicineRepository),
        RepositoryProvider.value(value: cartRepository),
        RepositoryProvider.value(value: orderRepository),
        RepositoryProvider.value(value: healthRepository),
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
          BlocProvider(
            create: (context) => OrderBloc(orderRepository: orderRepository),
          ),
          BlocProvider(
            create: (context) => HealthTipsBloc(healthRepository: healthRepository)..add(LoadHealthTips()),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
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
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Farumasi',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          themeMode: ThemeMode.light,
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
      },
    );
  }
}
