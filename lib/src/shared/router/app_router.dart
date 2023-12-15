import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:manifest/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:manifest/src/features/chat/presentation/screens/chat_screen.dart';
import 'package:manifest/src/shared/app/blocs/app_bloc.dart';

class AppRouter {
  final AppBloc appBloc;
  AppRouter(this.appBloc);

  late final GoRouter router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
            path: '/sign-in',
            name: 'sign-in',
            pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const SignInScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                )),
        GoRoute(
            path: '/sign-up',
            name: 'sign-up',
            pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const SignUpScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                )),
        GoRoute(
            path: '/',
            name: 'chat',
            pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ChatScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                )),
      ],
      redirect: (context, state) {
        final bool isAuthenticated =
            appBloc.state.status == AppStatus.authenticated;
        final bool isSignIn = state.matchedLocation == '/sign-in';
        final bool isSignUp = state.matchedLocation == '/sign-up';

        if (!isAuthenticated) {
          return isSignUp ? '/sign-up' : '/sign-in';
        }

        if (isAuthenticated && (isSignUp || isSignIn)) {
          return '/';
        }
        ;

        return null;
      },
      refreshListenable: GoRouterRefreshStream(appBloc.stream));
}

// https://github.com/flutter/flutter/issues/108128
// https://github.com/csells/go_router/discussions/122
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
