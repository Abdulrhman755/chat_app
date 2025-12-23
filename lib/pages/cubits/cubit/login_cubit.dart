import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'invalid-credential') {
        emit(LoginFailure(errorMessage: 'Invalid email or password.'));
      } else if (ex.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: 'User not found.'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginFailure(errorMessage: 'Wrong password.'));
      } else {
        emit(
          LoginFailure(errorMessage: 'An error occurred. Please try again.'),
        );
      }
    }
  }
}
