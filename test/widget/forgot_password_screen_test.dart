import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:farumasi_patient_app/presentation/screens/forgot_password_screen.dart';
import 'package:farumasi_patient_app/presentation/blocs/login/login_cubit.dart';
import 'package:farumasi_patient_app/domain/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock AuthRepository to pass to Cubit
class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  testWidgets('ForgotPasswordScreen renders correctly', (WidgetTester tester) async {
    // Mock dependencies
    final mockAuthRepo = MockAuthRepo();

    await tester.pumpWidget(
      MaterialApp(
        home: RepositoryProvider<AuthRepository>.value(
          value: mockAuthRepo,
          child: const ForgotPasswordScreen(),
        ),
      ),
    );

    // Verify UI elements
    expect(find.text('Reset Password'), findsOneWidget); // App Bar title
    expect(find.text('Enter your email to receive a password reset link.'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
  });
}
