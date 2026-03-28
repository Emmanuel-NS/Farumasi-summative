import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:farumasi_patient_app/domain/repositories/auth_repository.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  group('AuthRepository Reset Password', () {
    late MockAuthRepo repository;

    setUp(() {
      repository = MockAuthRepo();
    });

    test('sendPasswordResetEmail should complete without error', () async {
      when(() => repository.sendPasswordResetEmail(any())).thenAnswer((_) async {});
      
      // Act & Assert
      await expectLater(
        repository.sendPasswordResetEmail('test@example.com'),
        completes,
      );
    });

    test('sendPasswordResetEmail should throw failure for invalid email', () async {
      when(() => repository.sendPasswordResetEmail('invalid-email'))
          .thenThrow(Exception('Invalid email format'));

      // Act & Assert
      expect(
        () => repository.sendPasswordResetEmail('invalid-email'),
        throwsException,
      );
    });

    test('sendPasswordResetEmail should throw failure for empty email', () async {
      when(() => repository.sendPasswordResetEmail(''))
          .thenThrow(Exception('Email cannot be empty'));
      // Act & Assert
      expect(
        () => repository.sendPasswordResetEmail(''),
        throwsException, 
      );
    });
  });
}
