import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../resources/firebase_repository.dart';
import '../utils/universal_variables.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  bool isLoginPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: SafeArea(
          child: Stack(children: [
        Center(
          child: loginButton(),
        ),
        isLoginPressed
            ? Center(child: CircularProgressIndicator())
            : Container(),
      ])),
    );
  }

  Widget loginButton() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: UniversalVariables.senderColor,
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: performLogin,
          child: Text(
            "LOGIN",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((UserCredential userCredential) {
      authenticateUser(userCredential);
    });
  }

  void authenticateUser(UserCredential userCredential) {
    _repository.authenticateUser(userCredential).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _repository.addDataToDb(userCredential).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }),
          );
        });
        print(true);
      } else {
        print(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }),
        );
      }
    });
  }
}
