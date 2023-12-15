import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/sign_up_usecase.dart';
import '../../../domain/value_objects/email.dart';
import '../../../domain/value_objects/password.dart';
import '../status.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpUseCase _signUpUseCase;

  SignUpCubit({
    required SignUpUseCase signUpUseCase,
  })  : _signUpUseCase = signUpUseCase,
        super(const SignUpState());

  void emailChanged(String value) {
    try {
      Email email = Email((email) => email..value = value);
      emit(
        state.copyWith(
          email: email,
          emailStatus: EmailStatus.valid,
        ),
      );
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
      ),
    );
    if (value.length < 8) {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
      return;
    }
    emit(state.copyWith(passwordStatus: PasswordStatus.valid));
  }

  void confirmPasswordChanged(String value) {
    if (value == state.password) {
      emit(state.copyWith(confirmPasswordStatus: ConfirmPasswordStatus.valid));
      return;
    }
    emit(state.copyWith(confirmPasswordStatus: ConfirmPasswordStatus.invalid));
  }

  Future<void> signUp() async {
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid) ||
        !(state.confirmPasswordStatus == ConfirmPasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      emit(state.copyWith(formStatus: FormStatus.initial));
      return;
    }

    // password needs to be a string up until here so we can always compare it
    // to the confirmed password, but now change it back to its proper
    // Password form
    Password password;
    try {
      password = Password(((password) => password..value = state.password));
    } on ArgumentError {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
      return;
    }

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    try {
      await _signUpUseCase(
        SignUpParams(email: state.email!, password: password),
      );
      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (err) {
      debugPrint('Something really unknown: $err');
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
