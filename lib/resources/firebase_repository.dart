import 'package:firebase_auth/firebase_auth.dart';
import 'package:skype_clone/models/person.dart';

import 'firebase_methods.dart';

class FirebaseRepository {
  final FirebaseMethods _firebasemethods = FirebaseMethods();

  Future<User> getCurrentUser() => _firebasemethods.getCurrentUser();

  Future<UserCredential> signIn() => _firebasemethods.signInWithGoogle();

  Future<bool> authenticateUser(UserCredential userCredential) =>
      _firebasemethods.authenticateUser(userCredential);

  Future<void> addDataToDb(UserCredential userCredential) =>
      _firebasemethods.addDataToDb(userCredential);

  Future<void> signOut() => _firebasemethods.signOut();

  Future<List<Person>> fetchAllusers(User currentUser) =>
      _firebasemethods.fetchAllUsers(currentUser);
}
