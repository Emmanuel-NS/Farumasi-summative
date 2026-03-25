import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../data/datasources/state_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(
        authRepository.currentUser.isEmpty
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(authRepository.currentUser),
      ) {
    on<AuthUserChanged>(_onUserChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);

    // Sync initial state if user is already logged in
    if (!authRepository.currentUser.isEmpty) {
      StateService().login(
        authRepository.currentUser.email,
        name: authRepository.currentUser.displayName,
      );
    } else {
      StateService().logout();
    }

    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<UserEntity> _userSubscription;

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user.isEmpty) {
      StateService().logout();
      emit(const AuthState.unauthenticated());
    } else {
      StateService().login(event.user.email, name: event.user.displayName);
      emit(AuthState.authenticated(event.user));
    }
  }

  void _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    unawaited(_authRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
