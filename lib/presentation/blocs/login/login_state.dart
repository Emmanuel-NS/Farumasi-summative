part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.userEmail,
  });

  final LoginStatus status;
  final String? errorMessage;
  final String? userEmail;

  @override
  List<Object?> get props => [status, errorMessage, userEmail];
}
