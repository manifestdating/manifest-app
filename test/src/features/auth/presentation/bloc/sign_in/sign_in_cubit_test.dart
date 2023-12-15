import 'package:bloc_test/bloc_test.dart';
import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:manifest/src/features/auth/domain/value_objects/email.dart';
import 'package:manifest/src/features/auth/domain/value_objects/password.dart';
import 'package:manifest/src/features/auth/presentation/bloc/status.dart';
import 'package:manifest/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_cubit_test.mocks.dart';

@GenerateMocks([SignInUseCase])
void main() {
  late MockSignInUseCase mockSignInUseCase;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
  });

  group('SignInCubit', () {
    blocTest<SignInCubit, SignInState>(
      'emits [] when nothing is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      expect: () => [],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [valid email state] when valid email is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.emailChanged('test@test.com'),
      expect: () => [
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          emailStatus: EmailStatus.valid,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [invalid email state] when invalid email is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.emailChanged('invalid_email'),
      expect: () => [
        const SignInState(emailStatus: EmailStatus.invalid),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [valid password state] when valid password is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.passwordChanged('password'),
      expect: () => [
        SignInState(
          password: Password((p) => p..value = 'password'),
          passwordStatus: PasswordStatus.valid,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [invalid password state] when invalid password is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.passwordChanged('pass'),
      expect: () => [
        const SignInState(passwordStatus: PasswordStatus.invalid),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits formStatus [invalid, initial] when the form is not validated',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      seed: () => const SignInState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
      ),
      act: (cubit) => cubit.signIn(),
      expect: () => const [
        SignInState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.invalid,
        ),
        SignInState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.initial,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [submissionInProgress, submissionSuccess] when signIn is successful',
      setUp: () {
        when(mockSignInUseCase(any)).thenAnswer(
          (_) => Future.value(
            const AuthUser(id: 'id', email: 'test@test.com'),
          ),
        );
      },
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      seed: () => SignInState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
      ),
      act: (cubit) => cubit.signIn(),
      expect: () => [
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionInProgress,
        ),
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionSuccess,
        ),
      ],
      verify: (bloc) {
        verify(mockSignInUseCase(any)).called(1);
      },
    );
  });
}
