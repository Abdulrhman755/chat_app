// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';

import 'package:chat_app/pages/cubits/cubit/login_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  String? email;
  String? password;
  bool isLoading = false;
  static const String id = 'LoginPage';
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showsnackbar(context, message: state.errorMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    Image.asset("assets/images/scholar.png"),
                    const Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'pacifico',
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 1),
                    const Row(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomFormTextField(
                      hintText: 'Email',
                      onChanged: (data) {
                        email = data;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextField(
                      obscureText: true,
                      hintText: 'Password',
                      onChanged: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'LOGIN',
                      onTap: () async {
                        if (formkey.currentState!.validate()) {
                          BlocProvider.of<LoginCubit>(
                            context,
                          ).loginUser(email!, password!);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterPage.id);
                          },
                          child: const Text(
                            '  Register',
                            style: TextStyle(
                              color: Color(0xffC7EDE6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showsnackbar(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? 'An error occurred.')));
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
