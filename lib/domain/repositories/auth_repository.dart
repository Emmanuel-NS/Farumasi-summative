import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity> get user;
  UserEntity get currentUser;
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> logInWithGoogle();
  Future<void> logOut();
  Future<void> sendPasswordResetEmail(String email);
}

class SignUpFailure implements Exception {
  final String message;
  SignUpFailure([this.message = 'An unknown exception occurred.']);
}

class LogInWithEmailAndPasswordFailure implements Exception {
  final String message;
  LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

class LogInWithGoogleFailure implements Exception {
  final String message;
  LogInWithGoogleFailure([this.message = 'An unknown exception occurred.']);
}

class LogOutFailure implements Exception {}

class ResetPasswordFailure implements Exception {
  final String message;
  ResetPasswordFailure([this.message = 'An unknown exception occurred.']);
}
