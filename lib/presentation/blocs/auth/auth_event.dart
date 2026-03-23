part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserEntity user;

  @override
  List<Object> get props => [user];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
