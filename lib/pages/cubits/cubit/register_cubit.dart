import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(String email, String password) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(
          RegisterFailure(errorMessage: 'The password provided is too weak.'),
        );
      } else if (ex.code == 'email-already-in-use') {
        emit(
          RegisterFailure(
            errorMessage: 'The account already exists for that email.',
          ),
        );
      } else {
        emit(
          RegisterFailure(errorMessage: 'An error occurred. Please try again.'),
        );
      }
    }
  }
}
