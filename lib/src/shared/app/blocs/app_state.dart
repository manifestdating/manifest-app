part of 'app_bloc.dart';

enum AppStatus { unknown, authenticated, unauthenticated }

class AppState extends Equatable {
  final AppStatus status;
  final AuthUser authUser;

  const AppState({
    required this.status,
    this.authUser = AuthUser.emptyUser,
  });

  const AppState.authenticated(AuthUser authUser)
      : this(status: AppStatus.authenticated, authUser: authUser);

  const AppState.unauthenticated() : this(status: AppStatus.unauthenticated);

  AppState copyWith({
    AppStatus? status,
    AuthUser? authUser,
  }) {
    return AppState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
    );
  }

  @override
  List<Object?> get props => [status, authUser];
}
