import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:manifest/src/features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
import 'package:manifest/src/features/auth/presentation/bloc/status.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
          signUpUseCase:
              SignUpUseCase(authRepository: context.read<AuthRepository>())),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
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
                      'Error signing you up, please try again.',
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
                            key: const Key('SignUp_emailInput_textField'),
                            decoration: InputDecoration(
                              labelText: 'email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              errorText:
                                  state.emailStatus == EmailStatus.invalid
                                      ? 'invalid email'
                                      : null,
                            ),
                            onChanged: (String value) {
                              if (debounce?.isActive ?? false) {
                                debounce?.cancel();
                              }
                              debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                context.read<SignUpCubit>().emailChanged(value);
                              });
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
                            errorText:
                                state.passwordStatus == PasswordStatus.invalid
                                    ? 'invalid password'
                                    : null,
                          ),
                          obscureText: true,
                          onChanged: (String value) {
                            context.read<SignUpCubit>().passwordChanged(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                          key: const Key(
                              'SignIn_confirmPasswordInput_textField'),
                          decoration: InputDecoration(
                            labelText: 'confirm Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            errorText: state.confirmPasswordStatus ==
                                    ConfirmPasswordStatus.invalid
                                ? 'passwords must match'
                                : null,
                          ),
                          obscureText: true,
                          onChanged: (String value) {
                            context
                                .read<SignUpCubit>()
                                .confirmPasswordChanged(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 60,
                          width: 200,
                          child: ElevatedButton(
                            key: const Key('SignUp_continue_elevatedButton'),
                            onPressed: () =>
                                {context.read<SignUpCubit>().signUp()},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'sign up',
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
                              text: "already have an account? ",
                              children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.goNamed('sign-in'),
                                text: 'sign In',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                          ]))
                    ]),
              ))));
}
