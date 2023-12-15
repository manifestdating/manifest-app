part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.authUser);

  final AuthUser authUser;

  @override
  List<Object> get props => [authUser];
}

class AppSignOutRequested extends AppEvent {
  const AppSignOutRequested();
}
