import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:manifest/src/features/auth/domain/usecases/stream_user_usecase.dart';
import 'package:manifest/src/shared/app/blocs/app_bloc.dart';
import 'package:manifest/src/shared/router/app_router.dart';
import 'package:manifest/src/shared/theme/app_theme.dart';

class App extends StatelessWidget {
  const App(
      {required AuthRepository authRepository,
      required AuthUser authUser,
      super.key})
      : _authRepository = authRepository,
        _authUser = authUser;

  final AuthRepository _authRepository;
  final AuthUser _authUser;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _authRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => AppBloc(
                    streamAuthUserUseCase:
                        StreamAuthUserUseCase(authRepository: _authRepository),
                    signOutUseCase:
                        SignOutUseCase(authRepository: _authRepository),
                    authUser: _authUser)
                  ..add(AppUserChanged(_authUser)))
          ],
          child: const AppView(),
        ));
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      title: 'Manifest',
      theme: AppTheme.theme,
      routerConfig: AppRouter(context.read<AppBloc>()).router);
}
