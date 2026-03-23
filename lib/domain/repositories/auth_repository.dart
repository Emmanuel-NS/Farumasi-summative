import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity> get user;
  UserEntity get currentUser;
  Future<void> signUp({required String email, required String password, String? displayName});
  Future<void> logInWithEmailAndPassword({required String email, required String password});
  Future<void> logInWithGoogle();
  Future<void> logOut();
}
