import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/search_screen.dart';
import 'resources/firebase_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skype Clone',
      initialRoute: "/",
      routes: {"/search_screen": (context) => const SearchScreen()},
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
