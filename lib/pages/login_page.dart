// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = 'LoginPage'; // إضافة ID لسهولة التنقل

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                    email = data; // تحديث الإيميل
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTextField(
                  obscureText: true,
                  hintText: 'Password',
                  onChanged: (data) {
                    password = data; // تحديث كلمة المرور
                  },
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'LOGIN', // تغيير النص إلى LOGIN
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatPage.id, arguments: email);
                        // يمكنك إضافة الانتقال لصفحة الشات هنا
                      } on FirebaseAuthException catch (ex) {
                        // استخدام 'invalid-credential' للتعامل مع الإيميل أو الباسورد الخطأ
                        if (ex.code == 'invalid-credential') {
                          showsnackbar(
                            context,
                            message: 'Invalid email or password.',
                          );
                        } else {
                          showsnackbar(
                            context,
                            message: 'An error occurred. Please try again.',
                          );
                        }
                      } catch (e) {
                        showsnackbar(context, message: 'There was an error.');
                      }
                      isLoading = false;
                      setState(() {});
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
                        Navigator.pushNamed(
                          context,
                          RegisterPage.id,
                        ); // الانتقال لصفحة التسجيل
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
  }

  // دالة إظهار الـ Snackbar
  void showsnackbar(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? 'An error occurred.')));
  }

  // دالة تسجيل الدخول
  Future<void> loginUser() async {
    // ignore: unused_local_variable
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
