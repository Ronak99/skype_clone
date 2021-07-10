import 'package:flutter/material.dart';
import 'package:skype_clone/resources/firebase_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginButton(),
    );
  }

  Widget loginButton() {
    return TextButton(
      onPressed: performLogin,
      child: Text(
        "Login",
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  void performLogin() {}
}
