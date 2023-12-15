// Mocks generated by Mockito 5.4.2 from annotations
// in manifest/test/src/features/auth/data/repositories/auth_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:manifest/src/features/auth/data/datasources/auth_local_datasource.dart'
    as _i5;
import 'package:manifest/src/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i3;
import 'package:manifest/src/features/auth/data/models/auth_user_model.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthUserModel_0 extends _i1.SmartFake implements _i2.AuthUserModel {
  _FakeAuthUserModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRemoteDataSource extends _i1.Mock
    implements _i3.AuthRemoteDataSource {
  MockAuthRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i2.AuthUserModel?> get user => (super.noSuchMethod(
        Invocation.getter(#user),
        returnValue: _i4.Stream<_i2.AuthUserModel?>.empty(),
      ) as _i4.Stream<_i2.AuthUserModel?>);

  @override
  _i4.Future<_i2.AuthUserModel> signUpWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUpWithEmailAndPassword,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.AuthUserModel>.value(_FakeAuthUserModel_0(
          this,
          Invocation.method(
            #signUpWithEmailAndPassword,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.AuthUserModel>);

  @override
  _i4.Future<_i2.AuthUserModel> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithEmailAndPassword,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.AuthUserModel>.value(_FakeAuthUserModel_0(
          this,
          Invocation.method(
            #signInWithEmailAndPassword,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.AuthUserModel>);

  @override
  _i4.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [AuthLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthLocalDataSource extends _i1.Mock
    implements _i5.AuthLocalDataSource {
  MockAuthLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, Object?> get authLocalDataSource => (super.noSuchMethod(
        Invocation.getter(#authLocalDataSource),
        returnValue: <String, Object?>{},
      ) as Map<String, Object?>);

  @override
  void write<T extends Object?>({
    required String? key,
    T? value,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #write,
          [],
          {
            #key: key,
            #value: value,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  T? read<T extends Object?>({required String? key}) =>
      (super.noSuchMethod(Invocation.method(
        #read,
        [],
        {#key: key},
      )) as T?);
}
