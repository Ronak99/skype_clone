import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebasemethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebasemethods.getCurrentUser();
  
}
