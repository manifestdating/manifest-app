import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:manifest/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:manifest/src/features/auth/presentation/bloc/status.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
          signInUseCase:
              SignInUseCase(authRepository: context.read<AuthRepository>())),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state.formStatus == FormStatus.invalid) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("Looks like you're missing some fields"),
                  ),
                );
            }
            if (state.formStatus == FormStatus.submissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Error signing you in, please try again.',
                    ),
                  ),
                );
            }
          },
          builder: (context, state) => SafeArea(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 180),
                      const Text(
                        'manifest',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pattaya',
                            color: Color(0xffD64045)),
                      ),
                      SizedBox(height: 60),
                      Padding(
                          padding: EdgeInsets.all(15),
                          child: TextFormField(
                            key: const Key('SignIn_emailInput_textField'),
                            decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onChanged: (String value) {
                              context.read<SignInCubit>().emailChanged(value);
                            },
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          key: const Key('SignIn_passwordInput_textField'),
                          decoration: InputDecoration(
                            labelText: 'password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          obscureText: true,
                          onChanged: (String value) {
                            context.read<SignInCubit>().passwordChanged(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 60,
                          width: 200,
                          child: ElevatedButton(
                            key: const Key('SignIn_continue_elevatedButton'),
                            onPressed: () =>
                                {context.read<SignInCubit>().signIn()},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'sign in',
                              style: TextStyle(fontSize: 18),
                            ),
                          )),
                      const SizedBox(height: 24),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 20),
                              text: "or ",
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.goNamed('sign-up'),
                                text: 'sign up here',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                          ]))
                    ],
                  )))));
}
