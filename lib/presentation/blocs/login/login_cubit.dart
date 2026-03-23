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
      emit(const LoginState(status: LoginStatus.success));
    } catch (_) {
      emit(const LoginState(status: LoginStatus.error, errorMessage: "Login Failed"));
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
      emit(const LoginState(status: LoginStatus.success));
    } catch (_) {
        emit(const LoginState(status: LoginStatus.error, errorMessage: "Sign Up Failed"));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(const LoginState(status: LoginStatus.submitting));
    try {
      await _authRepository.logInWithGoogle();
      emit(const LoginState(status: LoginStatus.success));
    } catch (_) {
      emit(const LoginState(status: LoginStatus.error, errorMessage: "Google Login Failed"));
    }
  }
}
