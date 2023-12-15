part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final Email? email;
  final String? password;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final ConfirmPasswordStatus confirmPasswordStatus;
  final FormStatus formStatus;

  const SignUpState({
    this.email,
    this.password,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.confirmPasswordStatus = ConfirmPasswordStatus.unknown,
    this.formStatus = FormStatus.initial,
  });

  SignUpState copyWith({
    Email? email,
    String? password,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    ConfirmPasswordStatus? confirmPasswordStatus,
    FormStatus? formStatus,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      confirmPasswordStatus:
          confirmPasswordStatus ?? this.confirmPasswordStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailStatus,
        passwordStatus,
        confirmPasswordStatus,
        formStatus,
      ];
}
