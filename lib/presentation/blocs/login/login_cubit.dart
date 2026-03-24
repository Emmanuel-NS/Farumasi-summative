import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> logInWithCredentials(String email, String password) async {
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      await _authRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginState(status: LoginStatus.success, userEmail: email));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(LoginState(status: LoginStatus.error, errorMessage: "Login Failed: ${e.message}"));
    } catch (_) {
      emit(const LoginState(status: LoginStatus.error, errorMessage: "Login Failed: Unknown error"));
    }
  }

  Future<void> signUp(String email, String password, {String? displayName}) async {
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      await _authRepository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      emit(LoginState(status: LoginStatus.success, userEmail: email));
    } on SignUpFailure catch (e) {
        emit(LoginState(status: LoginStatus.error, errorMessage: "Sign Up Failed: ${e.message}"));
    } catch (_) {
        emit(const LoginState(status: LoginStatus.error, errorMessage: "Sign Up Failed"));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      await _authRepository.logInWithGoogle();
      // Google user email is retrieved dynamically from the repository
      final userEmail = _authRepository.currentUser.email;
      emit(LoginState(status: LoginStatus.success, userEmail: userEmail));
    } on LogInWithGoogleFailure catch (e) {
      emit(LoginState(status: LoginStatus.error, errorMessage: "Google Login Failed: ${e.message}"));
    } catch (_) {
      emit(const LoginState(status: LoginStatus.error, errorMessage: "Google Login Failed"));
    }
  }
}
