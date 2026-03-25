import 'dart:async';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final StreamController<UserEntity> _userController =
      StreamController<UserEntity>.broadcast();
  UserEntity _currentUser = UserEntity.empty;

  MockAuthRepository() {
    // Emit initial empty user
    _userController.add(_currentUser);
  }

  @override
  Stream<UserEntity> get user => _userController.stream;

  @override
  UserEntity get currentUser => _currentUser;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserEntity(
      id: 'mock_user_id',
      email: email,
      displayName: displayName ?? 'Mock User',
    );
    _userController.add(_currentUser);
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserEntity(
      id: 'mock_user_id',
      email: email,
      displayName: 'Mock User',
    );
    _userController.add(_currentUser);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = const UserEntity(
      id: 'mock_google_user',
      email: 'mock@gmail.com',
      displayName: 'Mock Google User',
    );
    _userController.add(_currentUser);
  }

  @override
  Future<void> logOut() async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserEntity.empty;
    _userController.add(_currentUser);
  }

  @override
  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserEntity(
      id: uid,
      email: email ?? _currentUser.email,
      displayName: displayName ?? _currentUser.displayName,
      photoUrl: _currentUser.photoUrl,
    );
    _userController.add(_currentUser);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'uid': uid,
      'email': _currentUser.email,
      'displayName': _currentUser.displayName,
      'phoneNumber': '1234567890',
      'role': 'patient',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'uid': 'mock_user_id',
        'email': 'mock@gmail.com',
        'displayName': 'Mock User',
        'phoneNumber': '1234567890',
        'role': 'patient',
      },
    ];
  }
}
