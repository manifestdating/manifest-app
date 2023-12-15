import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/auth/domain/usecases/stream_user_usecase.dart';
import '../../../features/auth/domain/entities/auth_user.dart';
import '../../../features/auth/domain/usecases/sign_out_usecase.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final StreamAuthUserUseCase _streamAuthUserUseCase;
  final SignOutUseCase _signOutUseCase;
  late StreamSubscription<AuthUser> _authUserSubscription;

  AppBloc({
    required StreamAuthUserUseCase streamAuthUserUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthUser authUser,
  })  : _streamAuthUserUseCase = streamAuthUserUseCase,
        _signOutUseCase = signOutUseCase,
        super(
          authUser == AuthUser.emptyUser
              ? const AppState.unauthenticated()
              : AppState.authenticated(authUser),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppSignOutRequested>(_onSignOutRequested);

    _authUserSubscription = _streamAuthUserUseCase().listen(_userChanged);
  }

  void _userChanged(AuthUser authUser) => add(AppUserChanged(authUser));

  void _onUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    return event.authUser.isEmpty
        ? emit(const AppState.unauthenticated())
        : emit(AppState.authenticated(event.authUser));
  }

  void _onSignOutRequested(
    AppSignOutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_signOutUseCase());
  }

  @override
  Future<void> close() {
    _authUserSubscription.cancel();
    return super.close();
  }
}
