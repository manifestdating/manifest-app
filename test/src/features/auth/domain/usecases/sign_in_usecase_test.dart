import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:manifest/src/features/auth/domain/value_objects/email.dart';
import 'package:manifest/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignInUseCase signInUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(authRepository: mockAuthRepository);
  });

  final tEmail = Email((email) => email.value = 'test@test.com');
  final tPassword = Password((password) => password.value = 'password123');
  const tAuthUser = AuthUser(id: '123', email: 'test@test.com');
  final tSignInParams = SignInParams(email: tEmail, password: tPassword);

  group('SignInUseCase', () {
    test(
      'should call signIn method on the AuthRepository with correct parameters and return authUser',
      () async {
        when(mockAuthRepository.signIn(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => tAuthUser);

        final result = await signInUseCase.call(tSignInParams);

        verify(mockAuthRepository.signIn(
          email: tEmail.value,
          password: tPassword.value,
        ));
        expect(result, equals(tAuthUser));
      },
    );

    test(
      'should throw an exception when the signIn method on the AuthRepository throws an exception',
      () async {
        when(mockAuthRepository.signIn(
          email: tEmail.value,
          password: tPassword.value,
        )).thenThrow(Exception());

        final call = signInUseCase.call;

        expect(() => call(tSignInParams), throwsA(isInstanceOf<Exception>()));
      },
    );
  });
}
