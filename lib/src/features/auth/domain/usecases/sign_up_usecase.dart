import 'package:manifest/src/features/auth/domain/entities/auth_user.dart';
import 'package:manifest/src/features/auth/domain/repositories/auth_repository.dart';

import '../value_objects/email.dart';
import '../value_objects/password.dart';

class SignUpUseCase {
  final AuthRepository authRepository;

  SignUpUseCase({required this.authRepository});

  Future<AuthUser> call(SignUpParams params) async {
    final SignUpParams(:email, :password) = params;
    try {
      return await authRepository.signUp(
          email: email.value, password: password.value);
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class SignUpParams {
  final Email email;
  final Password password;

  SignUpParams({required this.email, required this.password});
}
