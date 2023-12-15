import 'package:flutter_test/flutter_test.dart';
import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:manifest/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:manifest/src/features/auth/domain/value_objects/email.dart';
import 'package:manifest/src/features/auth/domain/value_objects/password.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUpUseCase signUpUseCase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
  });

  final tEmail = Email((email) => email.value = 'test@test.com');
  final tPassword = Password((password) => password.value = 'password123');
  const tAuthUser = AuthUser(id: '123', email: 'test@test.com');
  final tSignUpParams = SignUpParams(email: tEmail, password: tPassword);

  group('SignUpUseCase', () {
    test('calls signUp and returns auth user', () async {
      when(mockAuthRepository.signUp(
              email: tEmail.value, password: tPassword.value))
          .thenAnswer((_) async => tAuthUser);

      final result = await signUpUseCase.call(tSignUpParams);

      verify(mockAuthRepository.signUp(
          email: tEmail.value, password: tPassword.value));
      expect(result, equals(tAuthUser));
    });
  });

  test('throws when authRepository errors', () async {
    when(mockAuthRepository.signUp(
            email: tEmail.value, password: tPassword.value))
        .thenThrow(Exception());

    expect(() => signUpUseCase.call(tSignUpParams),
        throwsA(isInstanceOf<Exception>()));
  });
}
